# ECSC 2024 - Jeopardy

## [misc] Good old days (9 solves)

Behold our new invention, the phone!
With this service you are now closer than ever to your friends!
Place calls, or place calls, or even place calls to anyone willing to receive them!

We pre-configured a device for you to test prior to our grand release. Please provide a valuable feedback.

_Note: incoming calls are by default blocked to preserve your peace. You may change this setting at any time by calling your system configuration number at 0099. You may see which teams are currently allowing calls at the address: [http://10.250.254.3/](http://10.250.254.3/)._

_Note 2: to solve the challenge you are NOT required to attack the phone on your desk. It is not required to exploit vulnerabilities in the Yealink software. It is also forbidden to physically damage the phone._

_Note 3: the flag's characters are all uppercase._

Author: Alberto Carboneri <@Alberto247>

## Overview

The challenge is implementing a telephone network in the game arena.
Each team is provided a pre-configured phisical phone, connected to their own game instance.
All instances are then connected to a central server, representing the PSTN.
As attachments, the configuration of the team local asterisk instance and the configuration of the PSTN asterisk instance are provided.
Incoming calls are by default blocked.
A special number, 0099, is enabled to enable or disable this block.
Teams can call each other if the recevier has enabled incoming calls. Those calls are recorded.

## Solution

By inspecting the dialplans of the local and PSTN asterisks one can analyze the call routing algorithm.
Specifically, the team dialplan is:

```text
[globals]
CALLS_BLOCKED=1
calls_per_sec=1

[default]
exten => _00.,1,Set(GROUP()=${EPOCH})
 same => n,GotoIf($[${GROUP_COUNT(${EPOCH})}>${calls_per_sec}]?ratelimit,${EXTEN},1)
 same => n,Dial(PJSIP/${EXTEN}@pstn,120)
 same => n,Hangup()
exten => _0099,1,Goto(system-configuration,s,1)

[ratelimit]
exten => _00.,1,Hangup()

[system-configuration]
exten => s,1,Answer()
 same => n(loop),Playback("/sounds/other/system_configuration")
 same => n,WaitExten()

exten => 1,1,Set(GLOBAL(CALLS_BLOCKED)=1)
 same => n,Playback("/sounds/other/incoming_calls_blocked")
 same => n,Hangup()

exten => 2,1,Set(GLOBAL(CALLS_BLOCKED)=0)
 same => n,Playback("/sounds/other/incoming_calls_unblocked")
 same => n,Hangup()

[pstn]
exten => _0000,1,GotoIf($["${CALLS_BLOCKED}" = "1"]?blocked)
 same => n,Dial(PJSIP/localphone,120)
 same => n,Hangup()
 same => n(blocked),Congestion()
```

This allows calls to 0099, forwarding the chall to the "system-configuration" extension, and calls to any number starting by 00, forwarding the call to the pstn asterisk.
Moreover, it accepts calls from the pstn, forwarding it to the team's local phone.

The PSTN dialplan is:

```text
[default]
exten => _00xx,1,Answer()
 same => n,Playback("/sounds/other/call_enter")
 same => n,MixMonitor(/recordings/${CALLERID(num)}-team${EXTEN:2}-${UNIQUEID}.wav,b)
 same => n,Set(CDR(recordingpath)=/recordings/${CALLERID(num)}-team${EXTEN:2}-${UNIQUEID}.wav)
 same => n,Dial(PJSIP/0000@team${EXTEN:2},30)
 same => n,Playback("/sounds/other/call_busy")
 same => n,Hangup()

exten => _9999,1,Answer()
 same => n,Playback("/sounds/other/call_enter")
 same => n,MixMonitor(/recordings/${CALLERID(num)}-9999-${UNIQUEID}.wav,b)
 same => n,Set(CDR(recordingpath)=/recordings/${CALLERID(num)}-9999-${UNIQUEID}.wav)
 same => n,REDACTED
```

This accepts calls to any number starting by 00, forwarding those to the proper team, and implements a hidden number, 9999, whose implementation is redacted.

However, an error was introduced in the team dialplan, allowing for an injection.
The first filter accepts any number starting by 00, without restricting the characters coming after to only numbers.
Since then the call is dialed as `Dial(PJSIP/${EXTEN}@pstn,120)`, an injection into this command is possible.
By calling a number such as `0000&PJSIP/9999` we can trick the instance into calling the number 9999, retrieving the flag.

## Exploit

The exploit is supposed to be run directly from the phone, calling the number `0000&PJSIP/9999` will cause the flag to be spelled out by the remote automated system.

`ECSC{JUS7_D0NT_G0_4ROUND_M3SS1NG_W1TH_P30PLE5_PHON3S_N0W!_C071C556}`
