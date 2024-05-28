using api_lindcorp.Config;
using api_lindcorp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace api_lindcorp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerEntityController : ControllerBase
    {
        private readonly SampleDBContext _context;

        public CustomerEntityController(SampleDBContext context)
        {
            _context = context;
        }

        [HttpGet]
        public ActionResult<IEnumerable<Categoria>> GetCustomers()
        {
            var categorias = _context.Categoria.ToList();
            return Ok(categorias);
        }

        [HttpGet("{id}")]
        public ActionResult<Categoria> GetCustomerById(int id)
        {
            // Buscar una categoría por su ID
            var categoria = _context.Categoria.Find(id);

            if (categoria == null)
            {
                return NotFound();
            }

            return categoria;
        }

        [HttpPost]
        public IActionResult CreateCustomer(Categoria categoria)
        {
            _context.Categoria.Add(categoria);
            _context.SaveChanges();

            return CreatedAtAction(nameof(GetCustomerById), new { id = categoria.Id }, categoria);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateCustomer(int id, Categoria categoria)
        {
            if (id != categoria.Id)
            {
                return BadRequest();
            }

            // Actualizar una categoría existente en la base de datos
            _context.Entry(categoria).State = EntityState.Modified;
            _context.SaveChanges();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteCustomer(int id)
        {
            var categoria = _context.Categoria.Find(id);

            if (categoria == null)
            {
                return NotFound();
            }

            _context.Categoria.Remove(categoria);
            _context.SaveChanges();

            return NoContent();
        }
    }

}
