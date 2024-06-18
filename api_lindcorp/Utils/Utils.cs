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

    }
}
