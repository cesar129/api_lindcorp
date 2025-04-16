# Utilizar la imagen base de ASP.NET Core 8.0
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Fase de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Development
WORKDIR /src

# Copiar el archivo del proyecto y restaurar dependencias
COPY ["api_lindcorp/api_lindcorp.csproj", "api_lindcorp/"]
RUN dotnet restore "./api_lindcorp/api_lindcorp.csproj"

# Copiar el resto del código fuente y construir el proyecto
COPY . .
WORKDIR "/src/api_lindcorp"
RUN dotnet build "./api_lindcorp.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Fase de publicación
FROM build AS publish
ARG BUILD_CONFIGURATION=Development
RUN dotnet publish "./api_lindcorp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Crear la imagen final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Configurar el punto de entrada para la aplicación
ENTRYPOINT ["dotnet", "api_lindcorp.dll"]