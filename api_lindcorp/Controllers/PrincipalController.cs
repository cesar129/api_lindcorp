using api_lindcorp.Models;
using api_lindcorp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace api_lindcorp.Controllers
{

    [ProducesResponseType(typeof(Response), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(Response), StatusCodes.Status500InternalServerError)]
    [ApiController]
    [Route("EndPoint")]
    public class PrincipalController
    {
        private readonly ILoginService _loginService;
        private readonly IDataService _dataService;

        public PrincipalController(
            ILoginService loginService,
            IDataService dataService
        )
        {
            _loginService = loginService;
            _dataService = dataService;
        }

        [ProducesResponseType(typeof(Response), StatusCodes.Status200OK)]
        [Produces("application/json")]
        [Consumes("application/json")]
        [HttpPost("/login")]
        public ActionResult<Response> login(LoginBody body)
        {
            return this._loginService.Login(body);
        }

        [Authorize]
        [ProducesResponseType(typeof(Response), StatusCodes.Status201Created)]
        [Produces("application/json")]
        [Consumes("application/json")]
        [HttpPost("/sendData")]
        public ActionResult<DataResponse> sendData(DataBody body)
        {
            return this._dataService.sendData(body);
        }

    }
}
