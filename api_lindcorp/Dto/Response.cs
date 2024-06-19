using Newtonsoft.Json.Linq;
using System.Net;

namespace api_lindcorp.Models
{
    public class Response
    {
        public HttpStatusCode statusCode { get; set; }
        public Object data { get; set; }
        public string message { get; set; }
        public JArray json { get; set; }

    }
}
