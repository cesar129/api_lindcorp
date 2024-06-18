using api_lindcorp.Models;
using api_lindcorp.Services.Impl;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace api_lindcorp.Services
{
    public class TokenServiceImpl : ITokenService
    {

        private readonly IConfiguration _configuration;

        public TokenServiceImpl(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        

        public string CreateToken(Aplication aplication)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]!);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                   new Claim("user", aplication.userAplication),
                   new Claim("app", aplication.aplicationCode.ToString()),
                }),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
                Issuer = _configuration["Jwt:Issuer"],
                Audience = _configuration["Jwt:Issuer"]
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);

        }


        public ClaimsPrincipal ValidateToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]!);
            try
            {
                var validationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ClockSkew = TimeSpan.Zero
                };

                var principal = tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);

                return principal;
            }
            catch (SecurityTokenValidationException ex)
            {
                throw new UnauthorizedAccessException("Invalid token", ex);
            }
        }

        public string RefreshToken(string oldToken, Aplication aplication)
        {
            var principal = ValidateToken(oldToken);

            if (principal == null || !principal.Identity.IsAuthenticated)
            {
                throw new UnauthorizedAccessException("Invalid token");
            }

            var newToken = CreateToken(aplication);
            return newToken;
        }
    }
}
