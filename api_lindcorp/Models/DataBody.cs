using Newtonsoft.Json.Linq;
using System.ComponentModel.DataAnnotations;

namespace api_lindcorp.Models
{
    public class DataBody
    {
        [Required]
        public string method { get; set; }

        [Required]
        public string user { get; set; }

        [Required]
        public JObject parameters { get; set; }

        [Required]
        public int requestId { get; set; }
    }
}
