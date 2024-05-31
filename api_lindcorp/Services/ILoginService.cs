using api_lindcorp.Models;

namespace api_lindcorp.Services
{
    public interface ILoginService
    {
        LoginResponse Login(LoginBody body);
    }
}
