using api_lindcorp.Config;
using api_lindcorp.Exceptions;
using api_lindcorp.Models;
using api_lindcorp.Services.Impl;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;
using System.Net;

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
                            throw new UnauthorizedCustomerException("Credenciales inválidas");
                        }
                        else
                        {
                            LoginResponse loginResponse = new LoginResponse();
                            loginResponse.token = this._itoken.CreateToken(aplication);

                            response.statusCode = HttpStatusCode.OK;
                            response.data = loginResponse;
                        }
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
