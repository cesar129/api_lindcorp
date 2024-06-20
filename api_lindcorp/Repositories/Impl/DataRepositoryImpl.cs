﻿using api_lindcorp.Config;
using api_lindcorp.Exceptions;
using api_lindcorp.Services.Impl;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;
using System.Text.Json;

namespace api_lindcorp.Repositories.Impl
{
    public class DataRepositoryImpl : IDataRepository
    {

        private readonly SqlDbContext _context;
        private readonly ITokenService _itoken;

        public DataRepositoryImpl(
            SqlDbContext sqlDbContext,
            ITokenService itoken
        )
        {
            _context = sqlDbContext;
            _itoken = itoken;
        }

        public string sendData(string json, string token)
        {
            string response = "{}";

            var username = this._itoken.ValidateToken(token).FindFirst("user").Value;
            

            // Deserializar el JSON a un objeto dinámico
            var jsonObject = JsonSerializer.Deserialize<JsonElement>(json);

            // Crear un diccionario para modificar el JSON
            var dictionary = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(json);

            // Modificar el valor de userName usando una variable
            dictionary["userName"] = JsonDocument.Parse($"\"{username}\"").RootElement;

            string updatedJsonString = JsonSerializer.Serialize(dictionary);

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "sp_send_data_json";
                command.CommandType = System.Data.CommandType.StoredProcedure;

                DbParameter parameter = command.CreateParameter();
                parameter.ParameterName = "@p_vJson";
                parameter.Value = updatedJsonString;
                command.Parameters.Add(parameter);

                _context.Database.OpenConnection();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {;

                        response = reader.GetString(0);
            
                    }
                    else
                    {
                        throw new UnauthorizedCustomerException("Credenciales inválidas");
                    }
                }
            }

            return response;
        }
    }
}
