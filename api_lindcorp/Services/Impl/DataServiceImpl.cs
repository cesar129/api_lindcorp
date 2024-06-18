using api_lindcorp.Models;
using api_lindcorp.Repositories;

namespace api_lindcorp.Services.Impl
{
    public class DataServiceImpl : IDataService
    {

        private readonly IDataRepository _dataRepository;

        public DataServiceImpl(
            IDataRepository dataRepository
        ){
            _dataRepository = dataRepository;
        }

        public string sendData(string json)
        {
            return this._dataRepository.sendData(json);

        }

    }
}
