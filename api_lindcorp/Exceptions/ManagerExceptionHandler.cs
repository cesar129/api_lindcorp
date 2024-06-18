using api_lindcorp.Models;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.Data.SqlClient;

namespace api_lindcorp.Exceptions
{
    public class ManagerExceptionHandler : IExceptionHandler
    {
        private readonly ILogger<ManagerExceptionHandler> _logger;
        public ManagerExceptionHandler(ILogger<ManagerExceptionHandler> logger)
        {
            _logger = logger;
        }
        public async ValueTask<bool> TryHandleAsync(
            HttpContext httpContext,
            Exception exception,
            CancellationToken cancellationToken)
        {
            Response response = new Response();

            if (exception is BadRequestCustomerException badRequestException)
            {
                _logger.LogError(badRequestException,"Exception occurred: {Message}",badRequestException.Message);
                response.statusCode = System.Net.HttpStatusCode.BadRequest;
                response.message = badRequestException.Message;

                httpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
                await httpContext.Response.WriteAsJsonAsync(response, cancellationToken);
            }

            if (exception is NotFoundCustomerException notFoundException)
            {
                _logger.LogError(notFoundException, "Exception occurred: {Message}", notFoundException.Message);
                response.statusCode = System.Net.HttpStatusCode.NotFound;
                response.message = notFoundException.Message;

                httpContext.Response.StatusCode = StatusCodes.Status404NotFound;
                await httpContext.Response.WriteAsJsonAsync(response, cancellationToken);
            }

            if (exception is UnauthorizedCustomerException unauthorizedException)
            {
                _logger.LogError(unauthorizedException, "Exception occurred: {Message}", unauthorizedException.Message);
                response.statusCode = System.Net.HttpStatusCode.Unauthorized;
                response.message = unauthorizedException.Message;

                httpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await httpContext.Response.WriteAsJsonAsync(response, cancellationToken);
            }

            if (exception is SqlException sqlException)
            {
                _logger.LogError(sqlException, "Exception occurred: {Message}", sqlException.Message);
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                response.message = sqlException.Message;

                httpContext.Response.StatusCode = StatusCodes.Status500InternalServerError;
                await httpContext.Response.WriteAsJsonAsync(response, cancellationToken);
            }

            

            return false;
        }
    }
}
