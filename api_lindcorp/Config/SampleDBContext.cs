using api_lindcorp.Models;
using Microsoft.EntityFrameworkCore;

namespace api_lindcorp.Config
{
    public class SampleDBContext: DbContext
    {

        public virtual DbSet<Categoria> Categoria { get; set; }

        public SampleDBContext(DbContextOptions<SampleDBContext> options): base(options)
        {
        }

    }
}
