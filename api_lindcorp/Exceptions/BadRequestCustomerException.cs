namespace api_lindcorp.Exceptions
{
    public class BadRequestCustomerException : Exception
    {
        public BadRequestCustomerException()
        {
        }

        public BadRequestCustomerException(string message)
            : base(message)
        {
        }
    }
}
