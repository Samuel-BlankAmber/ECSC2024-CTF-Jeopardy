You have loads of spare CPUs and want to build up some money? Try this out, you won't regret it.

_The timeout on the remote is 60 seconds._

You will have access to a development machine with an identical setup to the target machine, with the following differences:

1. The development machine has Python, WinDbg and Visual Studio installed for building, testing, debugging, exploiting, etc. Pwntools is also installed for your convenience.
2. The flag on the development machine is a placeholder dummy flag.
3. The development machine is accessible via RDP and SMB, while the target machine is not.

Both machines have no internet access but can connect to your local machine. The development machine can access the challenge port on the target machine.

On the development machine, challenge handouts are available in the `C:\challenge` directory. WinDbg is already configured with debugging symbols necessary for debugging the challenge.

#### Target
- **Site**: [http://topcpu.challs.jeopardy.ecsc2024.it](http://topcpu.challs.jeopardy.ecsc2024.it)
- **Access**: Challenge at TCP port 1107

#### Development
- **Site**: [http://dev.topcpu.challs.jeopardy.ecsc2024.it](http://dev.topcpu.challs.jeopardy.ecsc2024.it)
- **Administrator login**: `Admin` / `Passw0rd!`
- **Access**: RDP (port 3389), SMB (port 445), challenge at TCP port 1107


> Note: we periodically run health-check scripts on the target machine, but *not* on the development one. As such, it is guaranteed that the target machine is exploitable, while the development machine may not be depending on the state it is in and your exploitation path. You are free to restart services, or even reboot it when you need. You may request a reboot of the target machine, if you believe the target machine's current state is not exploitable with your solution. Rate limits for rebooting may be applied to teams repeatedly requesting reboots.
