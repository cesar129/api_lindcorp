using api_lindcorp.Config;
using api_lindcorp.Models;
using api_lindcorp.Services;
using api_lindcorp.Services.Impl;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace api_lindcorp.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class CustomerNativeController : ControllerBase
    {

        private readonly SqlDbContext _context;
        private readonly IToken _itoken;

        public CustomerNativeController(SqlDbContext context, IToken token)
        {
            _context = context;
            _itoken = token;
        }

        [HttpGet("/token")]
        public ActionResult<string> GetToken()
        {
            return _itoken.CreateToken("tokennn");
        }

        [HttpGet]
        public ActionResult<IEnumerable<Categoria>> GetCustomers()
        {
            List<Categoria> categorias = new List<Categoria>();            

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "SELECT * FROM Categoria";

                _context.Database.OpenConnection();

                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var categoria = new Categoria
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                        };
                        categorias.Add(categoria);
                    }
                }
            }

            return Ok(categorias);
        }

        [HttpGet("{id}")]
        public ActionResult<Categoria> GetCustomerById(int id)
        {
            Categoria categoria = null;

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "SELECT * FROM Categoria WHERE Id = @Id";
                var a = command.CreateParameter();
                a.ParameterName = "id";
                a.Value = id;
                command.Parameters.Add(a);

                _context.Database.OpenConnection();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        categoria = new Categoria
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                        };
                    }
                }
            }

            if (categoria == null)
            {
                return NotFound();
            }

            return categoria;
        }

        [HttpPost]
        public IActionResult CreateCustomer(Categoria categoria)
        {
            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "INSERT INTO Categoria (Nombre) VALUES (@Nombre); SELECT SCOPE_IDENTITY();";
                var a = command.CreateParameter();
                a.ParameterName = "Nombre";
                a.Value = categoria.Nombre;
                command.Parameters.Add(a);

                _context.Database.OpenConnection();

                int newId = Convert.ToInt32(command.ExecuteScalar());
                categoria.Id = newId;
            }

            return CreatedAtAction(nameof(GetCustomerById), new { id = categoria.Id }, categoria);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateCustomer(int id, Categoria categoria)
        {
            if (id != categoria.Id)
            {
                return BadRequest();
            }

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "UPDATE Categoria SET Nombre = @Nombre WHERE id = @Id";
                var a = command.CreateParameter();
                a.ParameterName = "id";
                a.Value = id;
                command.Parameters.Add(a);

                var b = command.CreateParameter();
                b.ParameterName = "Nombre";
                b.Value = categoria.Nombre;
                command.Parameters.Add(b);

                _context.Database.OpenConnection();

                int rowsAffected = command.ExecuteNonQuery();
                if (rowsAffected == 0)
                {
                    return NotFound();
                }
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteCustomer(int id)
        {
            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "DELETE FROM Categoria WHERE id = @Id";
                var a = command.CreateParameter();
                a.ParameterName = "id";
                a.Value = id;
                command.Parameters.Add(a);

                _context.Database.OpenConnection();

                int rowsAffected = command.ExecuteNonQuery();
                if (rowsAffected == 0)
                {
                    return NotFound();
                }
            }

            return NoContent();
        }
    }

}