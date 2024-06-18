using api_lindcorp.Config;
using api_lindcorp.Models;
using api_lindcorp.Services.Impl;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using System.Data.Common;
using System.Net;
using System.Reflection.Metadata;

namespace api_lindcorp.Repositories.Impl
{
    public class LoginRepositoryImpl : ILoginRepository
    {

        private readonly SqlDbContext _context;
        private readonly ITokenService _itoken;

        public LoginRepositoryImpl(
            SqlDbContext sqlDbContext,
            ITokenService itoken
        )
        {
            _context = sqlDbContext;
            _itoken = itoken;
        }

        public Response Login(LoginBody body)
        {
            Response response = new Response();

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "sp_validate_username";
                command.CommandType = System.Data.CommandType.StoredProcedure;

                DbParameter parameter = command.CreateParameter();
                parameter.ParameterName = "@username";
                parameter.Value = body.username;
                command.Parameters.Add(parameter);

                _context.Database.OpenConnection();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Aplication aplication = new Aplication();
                        aplication.aplicationCode = reader.GetInt32(reader.GetOrdinal("AplicationCode"));
                        aplication.userAplication = reader.GetString(reader.GetOrdinal("UserAplication"));
                        aplication.password = reader.GetString(reader.GetOrdinal("Password"));

                        bool verifyPassword =  Utils.Utils.verifyPassword(body.password, aplication.password);
                        if(!verifyPassword)
                        {
                            response.statusCode = HttpStatusCode.Unauthorized;
                            response.data = "Credenciales inválidas";
                        }else
                        {
                            LoginResponse loginResponse = new LoginResponse();
                            loginResponse.token = this._itoken.CreateToken(aplication);

                            response.statusCode = HttpStatusCode.OK;
                            response.data = loginResponse;
                        }
                    }
                    else
                    {
                        response.statusCode = HttpStatusCode.Unauthorized;
                        response.data = "Credenciales inválidas";
                    }
                }
            }

            return response;
        }
    }
}
