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

        public DataResponse sendData(DataBody body)
        {
            return this._dataRepository.sendData(body);

        }

    }
}
