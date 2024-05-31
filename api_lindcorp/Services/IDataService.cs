using api_lindcorp.Models;

namespace api_lindcorp.Services
{
    public interface IDataService
    {
        DataResponse sendData(DataBody body);
    }
}
