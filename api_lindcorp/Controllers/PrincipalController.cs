using api_lindcorp.Exceptions;
using api_lindcorp.Models;
using api_lindcorp.Services;
using Azure.Core;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace api_lindcorp.Controllers
{

    [ProducesResponseType(typeof(Response), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(Response), StatusCodes.Status500InternalServerError)]
    [ApiController]
    [Route("EndPoint")]
    public class PrincipalController : ControllerBase
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
        [ProducesResponseType(typeof(Response), StatusCodes.Status401Unauthorized)]
        [Produces("application/json")]
        [Consumes("application/json")]
        [HttpPost("/login")]
        public ActionResult<Response> login(LoginBody body)
        {
            return this._loginService.Login(body);
        }

        [Authorize]
        [ProducesResponseType(typeof(Response), StatusCodes.Status201Created)]
        [ProducesResponseType(typeof(Response), StatusCodes.Status401Unauthorized)]
        [Produces("application/json")]
        [Consumes("application/json")]
        [HttpPost("/sendData")]
        public ActionResult sendData([FromBody] object json)
        {
            if (!Request.Headers.TryGetValue("Authorization", out StringValues authorizationHeader)) {
                throw new UnauthorizedCustomerException("no autorizado");
            }
            string token = Utils.Utils.extractBearerToken(authorizationHeader);

            JObject jsonResult = JObject.Parse(this._dataService.sendData(json.ToString(), token));
            if(jsonResult["totalRecords"]!=null && (int)jsonResult["totalRecords"]>0)
            {
                jsonResult["data"] = JArray.Parse((string)jsonResult["data"]);
            }
            
            

            return Content(jsonResult.ToString(), "application/json"); ;
        }

    }
}
