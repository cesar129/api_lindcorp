using api_lindcorp.Models;

namespace api_lindcorp.Repositories
{
    public interface ILoginRepository
    {
        Response Login(LoginBody body);
    }
}
