namespace api_lindcorp.Utils
{
    public class Utils
    {

        public static string generatePassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }

        public static bool verifyPassword(string passwordHash, string password)
        {
            return BCrypt.Net.BCrypt.Verify(passwordHash, password);
        }

        public static string extractBearerToken(string authorizationHeader)
        {
            if (authorizationHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
            {
                return authorizationHeader.Substring("Bearer ".Length).Trim();
            }
            return "";
        }

    }
}
