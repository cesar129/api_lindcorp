using System.Net;

namespace api_lindcorp.Models
{
    public class Response
    {
        public HttpStatusCode statusCode { get; set; }
        public object data { get; set; }

    }
}
