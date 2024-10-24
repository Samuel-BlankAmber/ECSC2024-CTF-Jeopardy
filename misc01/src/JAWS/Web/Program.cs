using Microsoft.AspNetCore.Authentication.Negotiate;
using System.Runtime.Versioning;
using System.Security.Principal;
using System.Text.Json.Serialization;

namespace Web
{
    public class CommandOutput
    {
        [JsonPropertyName("output")]
        public string Output { get; set; }
        [JsonPropertyName("error")]
        public string Error { get; set; }

        public CommandOutput()
        {
            Output = "";
            Error = "";
        }
    }

    public class CommandInput
    {
        [JsonPropertyName("command")]
        public string Command { get; set; }

        public CommandInput()
        {
            Command = "";
        }
    }

    [SupportedOSPlatform("windows")]
    public class Program
    {
        public static void Main(string[] args)
        {
            Native.CreateHiddenDesktop(RunAs.HIDDEN_WINDOWS_STATION_NAME, RunAs.HIDDEN_DESKTOP_NAME);

            var builder = WebApplication.CreateBuilder(args);

            ConfigureServices(builder.Services);

            var app = builder.Build();

            Configure(app);

            app.Run();
        }

        /// <summary>
        /// Configures services for the application.
        /// </summary>
        /// <param name="services">The service collection.</param>
        private static void ConfigureServices(IServiceCollection services)
        {
            services.AddAuthentication(NegotiateDefaults.AuthenticationScheme).AddNegotiate();

            services.AddAuthorization(options =>
            {
                // By default, all incoming requests will be authorized according to the default policy.
                options.FallbackPolicy = options.DefaultPolicy;
            });

            services.AddRazorPages();
        }

        /// <summary>
        /// Configures the HTTP request pipeline.
        /// </summary>
        /// <param name="app">The web application.</param>
        private static void Configure(WebApplication app)
        {
            app.UseStaticFiles();
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.MapRazorPages();
            app.MapPost("/command", RunCommand);
        }

        /// <summary>
        /// Runs a command with the specified input.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <param name="command">The command input.</param>
        /// <returns>The command output.</returns>
        private async static Task<IResult> RunCommand(HttpContext context, CommandInput command)
        {
            var user = (WindowsIdentity?)context.User.Identity;

            if (user == null)
            {
                return Results.Ok(new CommandOutput
                {
                    Output = "",
                    Error = "No user context."
                });
            }

            if (!user.IsAuthenticated)
            {
                return Results.Ok(new CommandOutput
                {
                    Output = "",
                    Error = "User is not authenticated."
                });
            }

            if (user.AccessToken == null)
            {
                return Results.Ok(new CommandOutput
                {
                    Output = "",
                    Error = "No user access token."
                });
            }

            if (command.Command.Length > 700)
            {
                return Results.Ok(new CommandOutput
                {
                    Output = "",
                    Error = "Command is too long."
                });
            }

            var runas = new RunAs();
            CommandOutput res;
            try
            {
                Console.WriteLine("Running command: {0}", command.Command);
                res = await runas.Run(user.AccessToken, command.Command);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (!message.EndsWith("."))
                {
                    message += ".";
                }
                Console.Error.WriteLine(ex.ToString());
                res = new CommandOutput
                {
                    Output = "",
                    Error = $"{message} If you believe this is a mistake, contact support."
                };
            }

            return Results.Ok(res);
        }
    }
}