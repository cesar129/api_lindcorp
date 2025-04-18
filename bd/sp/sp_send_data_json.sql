CREATE PROCEDURE [dbo].[sp_send_data_json]
(
    @p_vJson    varchar(max)='{}', -- JSON de entrada con los datos necesarios
    @p_appuser  varchar(max)       -- Usuario de la aplicación
)
AS BEGIN
    BEGIN TRY 
        -- Declaración de variables de control
        DECLARE @pi_method varchar(100) = ''; -- Método que define la acción a realizar
        DECLARE @pi_userName varchar(50) = ''; -- Nombre de usuario tomado del JSON
        DECLARE @pi_parameters nvarchar(max) = ''; -- Parámetros adicionales en JSON
        DECLARE @pi_requestId int = 0; -- ID de la solicitud que se insertará en la tabla REQUEST
        DECLARE @index INT = 0; -- Control del ciclo
        DECLARE @totalCount INT = 0; -- Número total de órdenes en el JSON
        DECLARE @p_starDate datetime = GETDATE(); -- Fecha de inicio de la ejecución del procedimiento

        -- Parseo del JSON de entrada para obtener método, nombre de usuario, requestId y parámetros
        SELECT 
            @pi_method = method,
            @pi_userName = userName,
            @pi_requestId = requestId,
            @pi_parameters = parameters
        FROM OPENJSON(@p_vJson) WITH
        (
            method          varchar(100),
            userName        varchar(50),
            requestId       int,
            parameters      nvarchar(max) '$.parameters' AS JSON
        );

        -- Verificación del método. Si es 'set_list', se ejecuta el siguiente bloque
        IF(@pi_method = 'set_list')
        BEGIN
            -- Declaración de variables para la construcción de las consultas
            DECLARE @tableName NVARCHAR(100) = ''; -- Vatiable donde estara todas las tablas con los join apartir del from
            DECLARE @selectColumns NVARCHAR(MAX) = ''; -- Variable donde estara todas las columnas seleccionadas
            DECLARE @joinConditions NVARCHAR(MAX) = '';
            DECLARE @sigla NVARCHAR(5) = ''; -- Alias para las tablas en la consulta dinámica
            DECLARE @control int = 0; -- Control de la primera iteración para definir el FROM
            DECLARE @selectQuery NVARCHAR(MAX) = ''; -- Consulta SELECT generada dinámicamente
            DECLARE @tableQuery NVARCHAR(MAX) = ''; -- Consulta para las tablas involucradas
            DECLARE @selectFinal NVARCHAR(MAX) = ''; -- Consulta final con los SELECT y JOINs

            -- Inserta un registro en la tabla REQUEST para llevar un seguimiento del proceso
            INSERT INTO [dbo].[REQUEST]
            (
                [Status],
                [InitDate],
                [userAplication],
                [userName]
            )
            VALUES(
                0, -- Status inicial (pendiente)
                GETDATE(), -- Fecha de inicio
                @p_appuser, -- Usuario de la aplicación
                @pi_userName -- Nombre del usuario extraído del JSON
            );

            -- Obtener el ID de la solicitud recién insertada
            SET @pi_requestId = SCOPE_IDENTITY();

            -- Parseo del JSON de parámetros para extraer los datos de las tablas, columnas y condiciones de unión
            SELECT id, tableName, selects, orders, joins, 'T' + CAST(orders AS varchar) sigla
            INTO #jsonData
            FROM OPENJSON(@pi_parameters) WITH
            (
                id          varchar(50),     
                tableName   varchar(50),
                selects     nvarchar(max) '$.selects' AS JSON,
                orders      int,
                joins       nvarchar(max) '$.joins' AS JSON
            );

            -- Obtener el orden mínimo y máximo de las tablas a procesar
            SET @index  = (SELECT MIN(orders) FROM #jsonData);
            SET @totalCount  = (SELECT MAX(orders) FROM #jsonData);

            -- Ciclo para recorrer las tablas y construir las consultas dinámicas
            WHILE @index <= @totalCount
            BEGIN
                -- Obtener los datos de la tabla actual
                SELECT @tableName = 'VW_' + tableName, @selectColumns = selects, @joinConditions = joins, @sigla = sigla 
                FROM #jsonData WHERE orders = @index;

                -- Construir el SELECT dinámico con las columnas de la tabla actual
                SET @selectQuery = @selectQuery + ',' + STUFF((
                    SELECT ',' + @sigla + '.' + value
                    FROM OPENJSON(@selectColumns)
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

                -- Si es la primera tabla, se construye la parte FROM de la consulta
                IF(@control = 0)
                BEGIN
                    SET @tableQuery = ' FROM ' + @tableName + ' ' + @sigla;
                    SET @control = 1;
                END
                -- En caso contrario, se construyen los INNER JOIN con las tablas siguientes
                ELSE
                BEGIN
                    SET @tableQuery = @tableQuery + ' INNER JOIN ' + @tableName + ' ' + @sigla + ' ON ' +
                    STUFF((
                        SELECT ' AND ' + CONCAT(
                            @sigla + '.' + JSON_VALUE(value, '$.parameter'), ' = ', 
                            (SELECT sigla FROM #jsonData WHERE tableName = JSON_VALUE(value, '$.target.tableName')) + '.' + 
                            JSON_VALUE(value, '$.target.parameter')
                        )
                        FROM OPENJSON(@joinConditions)
                        FOR XML PATH (''), TYPE
                    ).value('.', 'NVARCHAR(MAX)'), 1, 4, '');
                END

                -- Incrementar el índice para pasar a la siguiente tabla
                SET @index = @index + 1;
            END;

            -- Eliminar la coma inicial de la consulta SELECT
            SET @selectQuery = SUBSTRING(@selectQuery, 2, LEN(@selectQuery));
            -- Construir la consulta final combinando los SELECTs y las tablas unidas
            SET @selectFinal = 'SELECT ' + @selectQuery + @tableQuery;

            -- Declaración de variables para almacenar los resultados en formato JSON
            DECLARE @jsonResult NVARCHAR(MAX);
            DECLARE @totalResult NVARCHAR(MAX);

            -- Ejecutar la consulta dinámica para obtener los resultados en formato JSON
            DECLARE @sql NVARCHAR(MAX);
            SET @sql = N'SELECT @result = (' + @selectFinal + ' FOR JSON PATH )';
            EXEC sp_executesql @sql, N'@result NVARCHAR(MAX) OUTPUT', @result = @jsonResult OUTPUT;

            -- Obtener el total de registros devueltos por la consulta
            SET @sql = N'SELECT @total = (SELECT COUNT(*) ' + @tableQuery + ')';
            EXEC sp_executesql @sql, N'@total NVARCHAR(MAX) OUTPUT', @total = @totalResult OUTPUT;

            -- Actualizar la solicitud en la tabla REQUEST con los detalles del proceso
            UPDATE [dbo].[REQUEST]
            SET [EndDate] = GETDATE(), TotalRecords = @totalResult, 
                [responseTables] = (STUFF((
                    SELECT ',' + tableName
                    FROM #jsonData
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''))
            WHERE [RequestCode] = @pi_requestId;

            -- Insertar un detalle de la solicitud en la tabla REQUEST_DETAIL
            INSERT INTO [dbo].[REQUEST_DETAIL]
            (
                [RquestCode], [Ip], [UserAplication], [Username], [Method], 
                [Parameters], [selects], [front], [status], [RegDate]
            )
            VALUES (
                @pi_requestId, '', @p_appuser, @pi_userName, @pi_method, @p_vJson, 
                @selectQuery, @tableQuery, 1, GETDATE()
            );

            -- Verificación y actualización de tablas de control según el resultado obtenido
            IF @totalResult > 0
            BEGIN
                SET @index  = (SELECT MIN(orders) FROM #jsonData);
                DECLARE @controlTable  NVARCHAR(MAX) = '';

                WHILE @index <= @totalCount
                BEGIN
                    -- Actualización de las tablas de control
                    SELECT @tableName = tableName, @sigla = sigla 
                    FROM #jsonData WHERE orders = @index;

                    IF (SELECT COUNT(*) FROM MASTER_CONTROL WHERE tableName = @tableName AND status = 1) = 0
                    BEGIN
                        -- Insertar en las tablas de control si no existen
                        SET @controlTable = 'INSERT INTO ' + @tableName + '_CONTROL SELECT DISTINCT ' + 
                        (STUFF((
                            SELECT ',' + @sigla + '.' + ku.column_name
                            FROM QAGlamBrands_Repl.INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
                            INNER JOIN QAGlamBrands_Repl.INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
                            ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
                            WHERE ku.TABLE_NAME = @tableName
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')) + ', 0, '''', ' + CAST(@pi_requestId AS VARCHAR) + ' ' + @tableQuery;

                        -- Ejecutar la inserción en la tabla de control
                        EXEC sp_executesql @controlTable;
                    END

                    -- Incrementar el índice
                    SET @index = @index + 1;
                END;
            END;

        END
        -- Verificación del método. Si es 'set_valid', se ejecuta el siguiente bloque
        ELSE IF (@pi_method = 'set_valid')
        BEGIN
            -- Proceso para validar registros en las tablas de control
            -- ...
            -- [COMENTARIOS DE TU LÓGICA AQUÍ]
        END

        -- Retornar el resultado en formato JSON
        SELECT
            requestId = @pi_requestId,
            initDate = @p_starDate,
            endDate = GETDATE(),
            status = 'OK',
            totalRecords = @totalResult,
            data = @jsonResult;
    END TRY
    BEGIN CATCH
        -- Manejo de errores y retorno del error en formato JSON
        SELECT 
            requestId = @pi_requestId,
            initDate = @p_starDate,
            endDate = GETDATE(),
            status = 'ERROR',
            errorMessage = ERROR_MESSAGE();
    END CATCH
END;
