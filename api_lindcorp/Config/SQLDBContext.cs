using api_lindcorp.Models;
using Microsoft.EntityFrameworkCore;

namespace api_lindcorp.Config
{
    public class SqlDbContext : DbContext
    {

        public SqlDbContext(DbContextOptions<SqlDbContext> options): base(options)
        {
        }

    }
}
