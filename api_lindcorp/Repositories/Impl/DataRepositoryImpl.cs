using api_lindcorp.Config;
using api_lindcorp.Models;

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

        public DataResponse sendData(DataBody body)
        {
            return new DataResponse();
        }
    }
}
