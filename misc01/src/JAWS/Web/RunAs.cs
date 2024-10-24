using Microsoft.Win32.SafeHandles;
using static Web.Native;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

namespace Web
{
    public class RunAs
    {
        // Constants
        private const int TIMEOUT = 30000;
        public const string RUNNER_PATH = @"C:\Program Files\JAWS\Runner\Runner.exe";
        public const string HIDDEN_WINDOWS_STATION_NAME = "HiddenWinSta0";
        public const string HIDDEN_DESKTOP_NAME = "Default";

        // Fields
        private IntPtr hProcess = IntPtr.Zero;
        private IntPtr hThread = IntPtr.Zero;
        private SafeFileHandle? hStdInputRead, hStdInputWrite, hStdOutputRead, hStdOutputWrite, hStdErrorRead, hStdErrorWrite;

        // Destructor
        ~RunAs()
        {
            hStdInputRead?.Close();
            hStdInputWrite?.Close();
            hStdOutputRead?.Close();
            hStdOutputWrite?.Close();
            hStdErrorRead?.Close();
            hStdErrorWrite?.Close();
            if (hProcess != IntPtr.Zero) CloseHandle(hProcess);
            if (hThread != IntPtr.Zero) CloseHandle(hThread);
        }

        // Public Methods
        /// <summary>
        /// Runs a command with the specified token.
        /// </summary>
        /// <param name="hToken">The access token handle.</param>
        /// <param name="command">The command to run.</param>
        /// <returns>The command output.</returns>
        public async Task<CommandOutput> Run(SafeAccessTokenHandle hToken, string command)
        {
            CreateAnonymousPipeEveryoneAccess(out hStdInputRead, out hStdInputWrite);
            CreateAnonymousPipeEveryoneAccess(out hStdOutputRead, out hStdOutputWrite);
            CreateAnonymousPipeEveryoneAccess(out hStdErrorRead, out hStdErrorWrite);

            STARTUPINFO startupInfo = new()
            {
                cb = Marshal.SizeOf(typeof(STARTUPINFO)),
                dwFlags = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES,
                wShowWindow = SW_HIDE,
                hStdInput = hStdInputRead!,
                hStdOutput = hStdOutputWrite!,
                hStdError = hStdErrorWrite!,
                lpDesktop = $"{HIDDEN_WINDOWS_STATION_NAME}\\{HIDDEN_DESKTOP_NAME}",
            };

            string encodedCommand = Convert.ToBase64String(Encoding.UTF8.GetBytes(command));

            if (!CreateProcessWithToken(hToken.DangerousGetHandle(), 0, null, $"\"{RUNNER_PATH}\" {encodedCommand}", CREATE_NO_WINDOW, IntPtr.Zero, @"C:\", ref startupInfo, out PROCESS_INFORMATION processInformation))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            hStdInputRead?.Close();
            hStdOutputWrite?.Close();
            hStdErrorWrite?.Close();

            hProcess = processInformation.hProcess;
            hThread = processInformation.hThread;

            return await GetCommandOutput();
        }

        // Private Methods
        /// <summary>
        /// Gets the command output.
        /// </summary>
        /// <returns>The command output.</returns>
        private async Task<CommandOutput> GetCommandOutput()
        {
            var cts = new CancellationTokenSource(TIMEOUT);
            string output;
            string error;
            bool timedOut = false;
            bool errorWhileWaiting = false;

            async Task WaitForProcessAsync()
            {
                try
                {
                    var wh = new ProcessWaitHandle(hProcess);
                    var result = await WaitForSingleObjectAsync(wh, TIMEOUT);
                    if (result == WAIT_TIMEOUT)
                    {
                        timedOut = true;
                        TerminateProcess(hProcess, 1);
                    }
                    else if (result == WAIT_OBJECT_0)
                    {
                        // All good
                    }
                    else
                    {
                        errorWhileWaiting = true;
                        Console.Error.WriteLine($"Unexpected WaitForSingleObject result: {result}");
                    }
                }
                catch (TimeoutException)
                {
                    timedOut = true;
                    TerminateProcess(hProcess, 1);
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine(ex.ToString());
                    errorWhileWaiting = true;
                    TerminateProcess(hProcess, 1);
                }
            }

            var waitTask = WaitForProcessAsync();

            async Task<string> ReadFromStreamAsync(SafeFileHandle hFile)
            {
                using var reader = new StreamReader(new FileStream(hFile, FileAccess.Read));
                try
                {
                    return await reader.ReadToEndAsync().WaitAsync(cts.Token);
                }
                catch (OperationCanceledException)
                {
                    timedOut = true;
                    TerminateProcess(hProcess, 1);
                    return string.Empty;
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine(ex.ToString());
                    errorWhileWaiting = true;
                    return string.Empty;
                }
            }

            var outputTask = ReadFromStreamAsync(hStdOutputRead!);
            var errorTask = ReadFromStreamAsync(hStdErrorRead!);

            await Task.WhenAll(waitTask, outputTask, errorTask);

            output = await outputTask;
            error = await errorTask;

            if (timedOut)
            {
                error = AppendErrorMessage(error, "Process wait timed out.");
            }

            if (errorWhileWaiting)
            {
                error = AppendErrorMessage(error, "Error while waiting for process.");
            }

            return new CommandOutput
            {
                Output = output,
                Error = error
            };
        }

        /// <summary>
        /// Appends an error message to the current error string.
        /// </summary>
        /// <param name="currentError">The current error string.</param>
        /// <param name="newMessage">The new error message to append.</param>
        /// <returns>The updated error string.</returns>
        private static string AppendErrorMessage(string currentError, string newMessage)
        {
            if (!string.IsNullOrEmpty(currentError))
            {
                currentError += "\n";
            }

            currentError += newMessage;
            return currentError;
        }

        /// <summary>
        /// Waits for a single object asynchronously.
        /// </summary>
        /// <param name="handle">The wait handle.</param>
        /// <param name="timeoutMilliseconds">The timeout in milliseconds.</param>
        /// <returns>The wait result.</returns>
        private static async Task<uint> WaitForSingleObjectAsync(WaitHandle handle, int timeoutMilliseconds)
        {
            var tcs = new TaskCompletionSource<uint>();
            RegisteredWaitHandle? registeredHandle = null;

            // Register a wait operation on the handle
            registeredHandle = ThreadPool.RegisterWaitForSingleObject(
                handle,
                (state, timedOut) =>
                {
                    if (timedOut)
                    {
                        tcs.TrySetException(new TimeoutException("Wait operation timed out."));
                    }
                    else
                    {
                        tcs.TrySetResult(WAIT_OBJECT_0);
                    }

                    // Unregister once the operation is complete
                    registeredHandle?.Unregister(null);
                },
                null,
                timeoutMilliseconds,
                true
            );

            return await tcs.Task;
        }

        // Nested Classes
        /// <summary>
        /// Represents a process wait handle.
        /// </summary>
        public class ProcessWaitHandle : WaitHandle
        {
            public ProcessWaitHandle(IntPtr hProcess)
            {
                this.SafeWaitHandle = new SafeWaitHandle(hProcess, false);
            }
        }
    }
}
