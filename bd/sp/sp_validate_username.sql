CREATE PROCEDURE [dbo].[sp_validate_username]
    @username VARCHAR(50) -- Parámetro de entrada: el nombre de usuario que se desea validar
AS
BEGIN
    -- Selecciona todos los registros de la tabla 'Aplication' donde el campo 'UserAplication' 
    -- coincida con el valor del nombre de usuario proporcionado como parámetro
    SELECT * 
    FROM Aplication 
    WHERE UserAplication = @username;
END;
