As part of this year's "Hack & Snack" event, we (Pizza Overflow) have been working closely with Spaghetti Fork Bomb - so closely, in fact, that we decided to establish a trust between our two Active Directory forests. However, Spaghetti Fork Bomb, being a bit paranoid (maybe they've watched *The Godfather* too many times?), insisted on a one-way trust. In this setup, Pizza Overflow's forest trusts Spaghetti Fork Bomb's forest, but not the other way around. This means they can simply walk into our forest, grab a slice of pizza, and critique our sauce, while we can't even get a taste of their marinara recipe. Suspicious, right? What's so secretive about spaghetti anyway?

One of our clever employees, while waiting for the dough to rise, pointed out that a one-way trust might not be as secure as Spaghetti Fork Bomb thinks. So, we hinted that we might still be able to access their forest if we tried. They took the bait, and in true CTF-style, they've placed a flag on their domain controller at `\\dc.spaghetti.local\flag\flag.txt`, accessible to all their domain users, daring us to capture it.

And now, dear hacker, the kitchen is yours. We're giving you full administrative access to Pizza Overflow's forest. Your mission: Prove us right - break into Spaghetti Fork Bomb's forest and grab that flag like it's the last slice of pizza.

#### TL;DR

- The **flag** is located at `\\dc.spaghetti.local\flag\flag.txt`.
- The flag is readable by any **domain user** in the `spaghetti.local` domain.
- A **one-way trust** has been established from `pizza.local` to `spaghetti.local` (`pizza.local` trusts `spaghetti.local`).
- You have full administrative access to the `pizza.local` domain.

Both machines have no internet access but can connect to your local machine.

#### Connection:

- Use **Remote Desktop Protocol (RDP)** to access the machine at `trustissues.challs.jeopardy.ecsc2024.it` (IP: `10.151.2.100`), on port 3389.
- Log in with the following credentials:
  - **Username**: `pizza.local\Administrator`
  - **Password**: `DoughN0tFai1!`
