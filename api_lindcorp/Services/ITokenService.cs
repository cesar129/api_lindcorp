using api_lindcorp.Models;

namespace api_lindcorp.Services.Impl
{
    public interface ITokenService
    {
        string CreateToken(Aplication aplication);
    }
}
