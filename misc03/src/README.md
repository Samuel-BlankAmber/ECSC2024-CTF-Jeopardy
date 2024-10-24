[MISC] Jailguesser
==================

A system programming challenge disguised as a "guessing" game where the user
must submit a program that can correctly guess (detect) and output the
randomized [NsJail](https://github.com/google/nsjail) configuration under which
it is being run.


Building
--------

The challenge itself is source-only and no build step is necessary.

Run `make` to build the solver program [`solve.c`](./solve.c).

Run `make archive` to generate the final archive to distribute to players
directly inside [`../attachments`](../attachments).
