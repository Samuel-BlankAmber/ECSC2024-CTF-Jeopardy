using Microsoft.Win32.SafeHandles;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace Web
{
    public class Native
    {
        // Constants
        public const short SW_HIDE = 0;
        public const int STARTF_USESHOWWINDOW = 0x00000001;
        public const int STARTF_USESTDHANDLES = 0x00000100;
        public const int CREATE_UNICODE_ENVIRONMENT = 0x00000400;
        public const int CREATE_NO_WINDOW = 0x08000000;
        private const int BUFFER_SIZE_PIPE = 1048576;
        public const uint WAIT_TIMEOUT = 0x00000102;
        public const uint WAIT_OBJECT_0 = 0x00000000;

        // Enums
        [Flags]
        private enum ACCESS_MASK : uint
        {
            DELETE = 0x00010000,
            READ_CONTROL = 0x00020000,
            WRITE_DAC = 0x00040000,
            WRITE_OWNER = 0x00080000,
            SYNCHRONIZE = 0x00100000,
            STANDARD_RIGHTS_REQUIRED = 0x000F0000,
            STANDARD_RIGHTS_READ = 0x00020000,
            STANDARD_RIGHTS_WRITE = 0x00020000,
            STANDARD_RIGHTS_EXECUTE = 0x00020000,
            STANDARD_RIGHTS_ALL = 0x001F0000,
            SPECIFIC_RIGHTS_ALL = 0x0000FFFF,
            ACCESS_SYSTEM_SECURITY = 0x01000000,
            MAXIMUM_ALLOWED = 0x02000000,
            GENERIC_READ = 0x80000000,
            GENERIC_WRITE = 0x40000000,
            GENERIC_EXECUTE = 0x20000000,
            GENERIC_ALL = 0x10000000,
            GENERIC_ACCESS = GENERIC_READ | GENERIC_WRITE | GENERIC_EXECUTE | GENERIC_ALL,
            DESKTOP_READOBJECTS = 0x00000001,
            DESKTOP_CREATEWINDOW = 0x00000002,
            DESKTOP_CREATEMENU = 0x00000004,
            DESKTOP_HOOKCONTROL = 0x00000008,
            DESKTOP_JOURNALRECORD = 0x00000010,
            DESKTOP_JOURNALPLAYBACK = 0x00000020,
            DESKTOP_ENUMERATE = 0x00000040,
            DESKTOP_WRITEOBJECTS = 0x00000080,
            DESKTOP_SWITCHDESKTOP = 0x00000100,
            DESKTOP_ALL = DESKTOP_READOBJECTS | DESKTOP_CREATEWINDOW | DESKTOP_CREATEMENU |
                          DESKTOP_HOOKCONTROL | DESKTOP_JOURNALRECORD | DESKTOP_JOURNALPLAYBACK |
                          DESKTOP_ENUMERATE | DESKTOP_WRITEOBJECTS | DESKTOP_SWITCHDESKTOP |
                          STANDARD_RIGHTS_REQUIRED,
            WINSTA_ENUMDESKTOPS = 0x00000001,
            WINSTA_READATTRIBUTES = 0x00000002,
            WINSTA_ACCESSCLIPBOARD = 0x00000004,
            WINSTA_CREATEDESKTOP = 0x00000008,
            WINSTA_WRITEATTRIBUTES = 0x00000010,
            WINSTA_ACCESSGLOBALATOMS = 0x00000020,
            WINSTA_EXITWINDOWS = 0x00000040,
            WINSTA_ENUMERATE = 0x00000100,
            WINSTA_READSCREEN = 0x00000200,
            WINSTA_ALL = WINSTA_ACCESSCLIPBOARD | WINSTA_ACCESSGLOBALATOMS |
                         WINSTA_CREATEDESKTOP | WINSTA_ENUMDESKTOPS |
                         WINSTA_ENUMERATE | WINSTA_EXITWINDOWS |
                         WINSTA_READATTRIBUTES | WINSTA_READSCREEN |
                         WINSTA_WRITEATTRIBUTES | DELETE |
                         READ_CONTROL | WRITE_DAC |
                         WRITE_OWNER
        }

        // Structs
        [StructLayout(LayoutKind.Sequential)]
        public struct SECURITY_ATTRIBUTES
        {
            public int nLength;
            public IntPtr lpSecurityDescriptor;
            public bool bInheritHandle;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct STARTUPINFO
        {
            public int cb;
            public string lpReserved;
            public string lpDesktop;
            public string lpTitle;
            public int dwX;
            public int dwY;
            public int dwXSize;
            public int dwYSize;
            public int dwXCountChars;
            public int dwYCountChars;
            public int dwFillAttribute;
            public int dwFlags;
            public short wShowWindow;
            public short cbReserved2;
            public IntPtr lpReserved2;
            public SafeFileHandle hStdInput;
            public SafeFileHandle hStdOutput;
            public SafeFileHandle hStdError;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct PROCESS_INFORMATION
        {
            public IntPtr hProcess;
            public IntPtr hThread;
            public int dwProcessId;
            public int dwThreadId;
        }

        // P/Invoke Declarations
        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool CreatePipe(
            out SafeFileHandle hReadPipe,
            out SafeFileHandle hWritePipe,
            ref SECURITY_ATTRIBUTES lpPipeAttributes,
            int nSize);

        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern bool CreateProcessWithToken(
            IntPtr hToken,
            int dwLogonFlags,
            string? lpApplicationName,
            string lpCommandLine,
            int dwCreationFlags,
            IntPtr lpEnvironment,
            string lpCurrentDirectory,
            ref STARTUPINFO lpStartupInfo,
            out PROCESS_INFORMATION lpProcessInformation);

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool TerminateProcess(IntPtr hProcess, uint uExitCode);

        [DllImport("Kernel32.dll", SetLastError = true)]
        public static extern bool CloseHandle(IntPtr handle);

        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern IntPtr CreateWindowStation(
            string lpwinsta,
            int dwFlags,
            ACCESS_MASK dwDesiredAccess,
            IntPtr lpsa
        );

        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern IntPtr CreateDesktop(
            string lpszDesktop,
            IntPtr lpszDevice,
            IntPtr pDevmode,
            int dwFlags,
            ACCESS_MASK dwDesiredAccess,
            IntPtr lpsa
        );

        [DllImport("user32", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern IntPtr GetProcessWindowStation();

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SetProcessWindowStation(IntPtr hWinSta);


        // Methods
        /// <summary>
        /// Creates an anonymous pipe with everyone access.
        /// </summary>
        /// <param name="hReadPipe">The read handle of the pipe.</param>
        /// <param name="hWritePipe">The write handle of the pipe.</param>
        public static void CreateAnonymousPipeEveryoneAccess(out SafeFileHandle hReadPipe, out SafeFileHandle hWritePipe)
        {
            SECURITY_ATTRIBUTES sa = new SECURITY_ATTRIBUTES
            {
                nLength = Marshal.SizeOf<SECURITY_ATTRIBUTES>(),
                bInheritHandle = true,
                lpSecurityDescriptor = IntPtr.Zero
            };

            if (!CreatePipe(out hReadPipe, out hWritePipe, ref sa, BUFFER_SIZE_PIPE))
                throw new Win32Exception(Marshal.GetLastWin32Error());
        }

        /// <summary>
        /// Creates a hidden desktop with the specified window station and desktop names.
        /// </summary>
        /// <param name="winStaName">The name of the window station.</param>
        /// <param name="desktopName">The name of the desktop.</param>
        public static void CreateHiddenDesktop(string winStaName, string desktopName)
        {
            IntPtr hWinstaSave = GetProcessWindowStation();
            if (hWinstaSave == IntPtr.Zero)
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            IntPtr winSta = CreateWindowStation(winStaName, 0, ACCESS_MASK.WINSTA_ALL, IntPtr.Zero);
            if (winSta == IntPtr.Zero)
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            if (!SetProcessWindowStation(winSta))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            IntPtr desktop = CreateDesktop(desktopName, IntPtr.Zero, IntPtr.Zero, 0, ACCESS_MASK.DESKTOP_ALL, IntPtr.Zero);
            if (desktop == IntPtr.Zero)
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            if (!SetProcessWindowStation(hWinstaSave))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }
        }
    }
}
