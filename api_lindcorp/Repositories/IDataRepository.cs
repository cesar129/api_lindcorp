using api_lindcorp.Models;

namespace api_lindcorp.Repositories
{
    public interface IDataRepository
    {
        DataResponse sendData(DataBody body);
    }
}
