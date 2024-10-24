# ECSC 2024 - Jeopardy

## [misc] Trust Issues (21 solves)

As part of this year's "Hack & Snack" event, we (Pizza Overflow) have been working closely with Spaghetti Fork Bomb - so closely, in fact, that we decided to establish a trust between our two Active Directory forests. However, Spaghetti Fork Bomb, being a bit paranoid (maybe they've watched *The Godfather* too many times?), insisted on a one-way trust. In this setup, Pizza Overflow's forest trusts Spaghetti Fork Bomb's forest, but not the other way around. This means they can simply walk into our forest, grab a slice of pizza, and critique our sauce, while we can't even get a taste of their marinara recipe. Suspicious, right? What's so secretive about spaghetti anyway?

One of our clever employees, while waiting for the dough to rise, pointed out that a one-way trust might not be as secure as Spaghetti Fork Bomb thinks. So, we hinted that we might still be able to access their forest if we tried. They took the bait, and in true CTF-style, they've placed a flag on their domain controller at `\\dc.spaghetti.local\flag\flag.txt`, accessible to all their domain users, daring us to capture it.

And now, dear hacker, the kitchen is yours. We're giving you full administrative access to Pizza Overflow's forest. Your mission: Prove us right - break into Spaghetti Fork Bomb's forest and grab that flag like it's the last slice of pizza.

Author: Oliver Lyak <@ly4k>

## Overview

This challenge was centered around an Active Directory (AD) setup involving two separate forests, `pizza.local` and `spaghetti.local`. A forest in AD is a collection of domains that share a common configuration, schema, and global catalog, and forests can establish trust relationships with one another to enable resource sharing. In this challenge, a one-way trust is established between the forests where `pizza.local` trusts `spaghetti.local`. This means that `spaghetti.local`'s users can authenticate to `pizza.local`, but not the other way around.

The goal of the challenge is to exploit this trust relationship by reversing the usual trust direction. Rather than escalating from `spaghetti.local` to `pizza.local`, participants start with access to `pizza.local` as a domain administrator and need to compromise `spaghetti.local` by obtaining a domain user account. The flag is stored on the domain controller of `spaghetti.local`, accessible to any domain user.

![Diagram showing the AD setup with two forests: `pizza.local` (trusting) and `spaghetti.local` (trusted), and the one-way trust relationship](./writeup/trust.png)

Each participant had their own isolated environment to work in.

## Solution

### Understanding the Trust Account

When a one-way trust is created between two forests, a trust account is automatically created in the trusted forest (`spaghetti.local`). This account has a special password known as the "trust password," which is used for authentication between the forests. The corresponding relationship is represented as a Trusted Domain Object (TDO) in the trusting forest (`pizza.local`). Since the trust account is essentially a domain user account in `spaghetti.local`, and both forests need to share the password, administrators in `pizza.local` can access this password.

![Screenshot of the TDO in `pizza.local`'s AD configuration, highlighting the relationship to `spaghetti.local`](./writeup/tdo.png)

The trick is that the trust account password stored in `pizza.local` can be extracted and used to authenticate as the trust account in `spaghetti.local`. This allows participants to break the one-way trust by accessing `spaghetti.local` from `pizza.local`.

### Extracting the Trust Password

The key step is extracting the trust account password from the TDO in `pizza.local`. This can be done using a tool like Mimikatz (a powerful post-exploitation tool for Windows). The command to extract the trust password using Mimikatz is:

```text
mimikatz # lsadump::trust
```

![Screenshot showing the Mimikatz command being executed on `pizza.local` and successfully extracting the trust password](./writeup/mimikatz.png)

The clear text password of the trust account (`pizza$`) is output as UTF-16 hex-encoded text. We can simply use cyberchef or any other tool to decode it.

![Screenshot showing the converted trust password from hex to clear text](./writeup/cyberchef.png)

Once the trust password is extracted, participants have a valid set of credentials for `spaghetti.local`.

A Python script to solve the challenge is provided at [./checker/__main__.py](./checker/__main__.py). This script extracts the trust password from the TDO in `pizza.local` and uses it to authenticate to `spaghetti.local` to access the flag. The script was automatically run frequently on all participants' live lab environments to ensure that the challenge was solvable for each participant.

### Using the Trust Account to Access `spaghetti.local`

With the password in hand, the next step is to authenticate to `spaghetti.local` as the trust account. Because this account is a regular domain user in `spaghetti.local`, it can be used to access any resources available to domain users — including the SMB share where the flag is stored.

We can use the built-in Explorer to connect to the SMB share on the domain controller of `spaghetti.local` by typing the following in the address bar:

```text
\\dc.spaghetti.local.local\flag
```

It will then try to access the SMB share on `dc.spaghetti.local.local` with our current credentials. Since we are not authenticated as a user in `spaghetti.local`, this will fail.

It will then prompt us for credentials, where we can use the trust account credentials obtained earlier. The format is `spaghetti.local\pizza$` and the password extracted from the TDO.

![Screenshot showing prompt for credentials to access the SMB share on `dc.spaghetti.local.local`](./writeup/auth.png)

Once authenticated, the participant can retrieve the flag and complete the challenge.

![Screenshot showing the flag file being accessed on `dc.spaghetti.local.local`](./writeup/flag.png)

## References and Learning Resources

This challenge is based on a relatively uncommon technique that leverages trust account manipulation to access resources across AD forests. For more information on this attack, you can refer to:

- [Abusing Trust Account$: Accessing Resources on a Trusted Domain from a Trusting Domain](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/abusing-trust-accountusd-accessing-resources-on-a-trusted-domain-from-a-trusting-domain) by ired.team
- [External Forest Domain One-Way Outbound](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology/external-forest-domain-one-way-outbound) from hacktricks

These resources cover the underlying concepts and attack vectors in detail, providing step-by-step instructions on how to exploit forest trust relationships. Keep in mind that not all the steps described in these posts are necessary to solve this specific challenge, but they provide useful background information for understanding the broader context of forest trusts.

## Conclusion

This challenge was aimed as a gentle introduction to the concept of forest trusts in Active Directory and how they can be exploited to reverse the direction of trust relationships. I hoped that many participants would find it engaging and educational, as it required a mix of AD knowledge, trust relationship understanding, and practical exploitation techniques. I wanted to ensure that the challenge was solvable within a reasonable time frame and provided a clear path to the solution for those who were unfamiliar with the topic. In real-world scenarios, this type of attack is not too common, but I thought it would be a fun and interesting challenge for participants to explore, both experienced and new to the topic.

If you have any questions or feedback, feel free to reach out to me on X/Twitter ([@ly4k_](https://twitter.com/ly4k_)) or Discord.
