using api_lindcorp.Config;
using api_lindcorp.Models;

namespace api_lindcorp.Repositories.Impl
{
    public class LoginRepositoryImpl : ILoginRepository
    {

        private readonly SqlDbContext _context;

        public LoginRepositoryImpl(
            SqlDbContext sqlDbContext
        ){
            _context = sqlDbContext;
        }

        public LoginResponse Login(LoginBody body)
        {
            return new LoginResponse();
        }
    }
}
