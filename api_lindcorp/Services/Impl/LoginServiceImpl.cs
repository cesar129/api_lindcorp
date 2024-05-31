using api_lindcorp.Models;
using api_lindcorp.Repositories;

namespace api_lindcorp.Services.Impl
{
    public class LoginServiceImpl : ILoginService
    {

        private readonly ILoginRepository _loginRepository;

        public LoginServiceImpl(
            ILoginRepository loginRepository
        ){
            _loginRepository = loginRepository;
        }

        public LoginResponse Login(LoginBody body)
        {
            return this._loginRepository.Login(body);
        }
    }
}
