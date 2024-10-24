I was walking through the local mercato, chatting with my coworker about a simple web shell I had made for remote administration on Windows. The air was filled with the delicious scents of fresh tomatoes and basil. Out of nowhere, a vendor shouted, "Patate locali!" I stopped, wondering if they were talking to me or just selling their [local potatoes](https://decoder.cloud/2023/02/13/localpotato-when-swapping-the-context-leads-you-to-system/).

The flag is located at `C:\flag\flag.txt` and is only accessible by `NT AUTHORITY\SYSTEM`.

The challenge runs on a fully patched Windows Server 2022. You will have access to a development machine with an identical setup to the target machine, with the following differences:

1. The development machine has Visual Studio installed for building and testing exploits.
2. The flag on the development machine is a placeholder dummy flag.
3. The administrator user on the development machine does not exist on the target machine.
4. The development machine is accessible via RDP and SMB, while the target machine is not.

Both machines have no internet access but can connect to your local machine.

#### Target
- **Site**: [http://jaws.challs.jeopardy.ecsc2024.it](http://jaws.challs.jeopardy.ecsc2024.it)
- **Login**: `User` / `Passw0rd!`
- **Access**: HTTP (port 80)

#### Development
- **Site**: [http://dev.jaws.challs.jeopardy.ecsc2024.it](http://dev.jaws.challs.jeopardy.ecsc2024.it)
- **Administrator login**: `Admin` / `Passw0rd!`
- **User login**: `User` / `Passw0rd!`
- **Access**: RDP (port 3389), SMB (port 445), HTTP (port 80)
