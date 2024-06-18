using api_lindcorp.Models;

namespace api_lindcorp.Services
{
    public interface ILoginService
    {
        Response Login(LoginBody body);
    }
}
