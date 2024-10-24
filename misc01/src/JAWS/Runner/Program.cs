using System;
using System.Management.Automation.Runspaces;
using System.Text;

namespace Runner
{
    internal class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.Error.WriteLine("Invalid number of arguments. Expected 1, received {0}", args.Length);
                return;
            }

            string decodedCommand = Encoding.UTF8.GetString(Convert.FromBase64String(args[0]));

            Microsoft.PowerShell.ConsoleShell.Start(RunspaceConfiguration.Create(), null, null, new[]
            {
                 "-NoLogo", "-NoProfile", "-NonInteractive", "-Command", decodedCommand
            });
        }
    }
}
