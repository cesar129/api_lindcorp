using System.ComponentModel.DataAnnotations;

namespace api_lindcorp.Models
{
    public class LoginBody
    {
        [Required]
        public string username { get; set; }

        [Required]
        public string password { get; set; }
    }
}
