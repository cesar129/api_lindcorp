using api_lindcorp.Models;
using System.Security.Claims;

namespace api_lindcorp.Services.Impl
{
    public interface ITokenService
    {
        string CreateToken(Aplication aplication);
        ClaimsPrincipal ValidateToken(string token);

        string RefreshToken(string oldToken, Aplication aplication);

    }
}
