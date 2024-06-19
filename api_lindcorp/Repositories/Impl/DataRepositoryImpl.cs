using api_lindcorp.Config;
using api_lindcorp.Exceptions;
using Microsoft.EntityFrameworkCore;
using System.Data.Common;

namespace api_lindcorp.Repositories.Impl
{
    public class DataRepositoryImpl : IDataRepository
    {

        private readonly SqlDbContext _context;

        public DataRepositoryImpl(
            SqlDbContext sqlDbContext
        )
        {
            _context = sqlDbContext;
        }

        public string sendData(string json)
        {
            string response = "{}";

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "sp_send_data_json";
                command.CommandType = System.Data.CommandType.StoredProcedure;

                DbParameter parameter = command.CreateParameter();
                parameter.ParameterName = "@p_vJson";
                parameter.Value = json;
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
