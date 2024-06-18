namespace api_lindcorp.Exceptions
{
    public class UnauthorizedCustomerException : Exception
    {
        public UnauthorizedCustomerException()
        {
        }

        public UnauthorizedCustomerException(string message)
            : base(message)
        {
        }
    }
}
