using api_lindcorp.Controllers;
using api_lindcorp.Exceptions;
using api_lindcorp.Models;
using api_lindcorp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Newtonsoft.Json.Linq;
using System.Net;

namespace api_lindcorp_test
{
    public class PrincipalTest
    {
        private readonly Mock<ILoginService> _mockLoginService;
        private readonly Mock<IDataService> _mockDataService;
        private readonly PrincipalController _controller;

        public PrincipalTest()
        {
            _mockLoginService = new Mock<ILoginService>();
            _mockDataService = new Mock<IDataService>();
            _controller = new PrincipalController(_mockLoginService.Object, _mockDataService.Object);
        }

        [Fact]
        public void Login_ReturnsOkResult()
        {

            var loginBody = new LoginBody { username = "user", password = "password" };
            var response = new Response { statusCode = HttpStatusCode.OK, data = "", message = "", json = null };
            _mockLoginService.Setup(service => service.Login(loginBody)).Returns(response);

            var result = _controller.login(loginBody);

            var okResult = Assert.IsType<ActionResult<Response>>(result);
            var returnValue = Assert.IsType<Response>(okResult.Value);
            Assert.Equal(HttpStatusCode.OK, returnValue.statusCode);
        }

        [Fact]
        public void SendData_UnauthorizedHeader_ReturnsUnauthorized()
        {
            var json = new { key = "value" };

            _controller.ControllerContext = new ControllerContext();
            _controller.ControllerContext.HttpContext = new DefaultHttpContext();

            var exception = Assert.Throws<UnauthorizedCustomerException>(() => _controller.sendData(json));
            Assert.Equal("no autorizado", exception.Message);
        }

        [Fact]
        public void SendData_ReturnsCompletedSetListdResult()
        {
            var json = "{\r\n    \"method\": \"set_list\",\r\n    \"userName\": \"admin\",\r\n    \"parameters\": [\r\n        {\r\n            \"tableName\": \"CUSTOMER\",\r\n            \"id\": \"CustomerNo\",\r\n            \"selects\": [\r\n                \"CustomerNo\",\r\n                \"StoreNo\",\r\n                \"StatusCode\",\r\n                \"CustomerType\",\r\n                \"FirstName\",\r\n                \"LastName\"\r\n            ],\r\n            \"orders\": 1,\r\n            \"joins\": []\r\n        },\r\n        {\r\n            \"tableName\": \"CUSTOMER_ADDRESS\",\r\n            \"id\": \"CustomerNo\",\r\n            \"selects\": [\r\n                \"Address1\"\r\n            ],\r\n            \"orders\": 2,\r\n            \"joins\": [\r\n                {\r\n                    \"parameter\": \"CustomerNo\",\r\n                    \"target\": {\r\n                        \"tableName\": \"CUSTOMER\",\r\n                        \"parameter\": \"CustomerNo\"\r\n                    }\r\n                }\r\n            ]\r\n        }\r\n    ],\r\n    \"requestId\": 1\r\n}";
            var token = "fake-token";
            var expectedMessage = "Request completed successfully set list";

            _mockDataService.Setup(service => service.sendData(json, token)).Returns("{\"requestId\":10039,\"start\":\"2024-06-21T04:22:34.790\",\"end\":\"2024-06-21T04:22:34.810\",\"status\":1,\"totalRecords\":\"1\",\"message\":\"Request completed successfully set list\",\"data\":\"[{\\\"CustomerNo\\\":1000000003,\\\"StoreNo\\\":0,\\\"StatusCode\\\":\\\"A\\\",\\\"CustomerType\\\":\\\"I\\\",\\\"FirstName\\\":\\\"MICHELLE\\\",\\\"LastName\\\":\\\"TURRIATE\\\",\\\"Address1\\\":\\\"\\\"}]\"}");

            _controller.ControllerContext = new ControllerContext();
            _controller.ControllerContext.HttpContext = new DefaultHttpContext();
            _controller.ControllerContext.HttpContext.Request.Headers["Authorization"] = "Bearer " + token;

            var result = _controller.sendData(json);

            var response = Assert.IsType<ActionResult<object>>(result);

            var jsonResult = response.Value.ToString();
            var message = JObject.Parse(jsonResult)["message"].ToString();

            Assert.Equal(expectedMessage, message);
        }

        [Fact]
        public void SendData_ReturnsCompletedSetValiddResult()
        {
            var json = "{\r\n  \"method\": \"set_valid\",\r\n  \"userName\": \"admin\",\r\n  \"parameters\": [\r\n    {\r\n      \"tableName\": \"CUSTOMER\",\r\n      \"ids\": [\r\n        {\r\n          \"param\": \"CustomerNo\",\r\n          \"value\": \"1000000003\"\r\n        }\r\n      ],\r\n      \"msg\": \"ERROR FALTA DE DATOS\"\r\n    }\r\n  ],\r\n  \"requestId\": 59\r\n}";
            var token = "fake-token";
            var expectedMessage = "Request completed successfully set valid";

            _mockDataService.Setup(service => service.sendData(json, token)).Returns("{\"requestId\":59,\"start\":\"2024-06-21T04:28:05.427\",\"end\":\"2024-06-21T04:28:05.437\",\"status\":1,\"message\":\"Request completed successfully set valid\"}");

            _controller.ControllerContext = new ControllerContext();
            _controller.ControllerContext.HttpContext = new DefaultHttpContext();
            _controller.ControllerContext.HttpContext.Request.Headers["Authorization"] = "Bearer " + token;

            var result = _controller.sendData(json);

            var response = Assert.IsType<ActionResult<object>>(result);

            var jsonResult = response.Value.ToString();
            var message = JObject.Parse(jsonResult)["message"].ToString();

            Assert.Equal(expectedMessage, message);
        }
    }
}