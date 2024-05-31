using api_lindcorp.Models;

namespace api_lindcorp.Repositories
{
    public interface ILoginRepository
    {
        LoginResponse Login(LoginBody body);
    }
}
