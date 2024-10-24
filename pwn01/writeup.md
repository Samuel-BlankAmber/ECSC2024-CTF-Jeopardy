# ECSC 2024 - Jeopardy

## [pwn] Yap (7 solves)

The yaml parser of pyyaml is soooooo slow, try out my new implementation!
It lacks some core functionality, but it is really fast.

`nc yap.challs.jeopardy.ecsc2024.it 47015`

Author: Fabio Zoratti <@orsobruno96>

## Overview

This challenge aims to pwn a python extension written in C. In the attached files there are all the ingredients to build a shared object that will be loaded by the python interpreter at runtime. This is exposed to the end user via a `chall.py` wrapper python script.

The chall source defines a yaml parser that builds a python object that can be later printed by the wrapper script.

## Solution path

There are two vulnerabilities that need to be exploited to solve this challenge. The first one is a pretty blatant stack buffer overflow in `yap_load`

```c

  char buf[BUFSIZE];

  ...

  if (fread(buf, BUFSIZE + 0x100, 1, fp) < 0) {
    PyErr_SetFromErrno(PyExc_RuntimeError);
    fclose(fp);
    return NULL;
  }

```

Having this overflow is useless without breaking ASLR. To do so, we can notice that enabling the debug mode of the library, a lot of addresses are being printed if the yaml is malformed. However, there seems not to be an intended way to do it using the program normally

```py
    dbg = environ.get("DEBUG", False) == "True"

...

            fname = validate_filename(input("File name? ").strip())
            try:
                values[fname] = load(fname, debug=dbg)
            except InvalidYamlError as exc:
                print(f"Parsing failed, sry: '{exc}'")


```

and obviously the variable is set to False. However, if we are careful enough, we can see that there is an off by one in the `match_level` function

```c

  if (ctx->cur_level >= STACKSIZE) {
    format_exception(ctx, "Exceeded stack size at line %d", ctx->cur_line);
    return -1;
  }
```

The correct check is `ctx->cur_level >= STACKSIZE - 1`. In this case, overflowing cur_level we can overwrite something really useful

```c
struct IndentationLevel {
  enum YamlTypes type;
  unsigned int level;
  PyObject* object;
  PyObject* last_key;
};

struct YapCtx {
  uint32_t cur_level;
  uint32_t cur_line;
  struct IndentationLevel indent_stack[STACKSIZE];
  int debug_mode;
  char parsed_fname[0x200];
};
```

So, `&ctx->indent_stack[STACKSIZE].type == &ctx->debug_mode`. If we create an object of type 1 (= Mapping), debug mode is enabled for the current parsing. Then, we need only to create a malformed object to print the context and get all what we need.
To do so, we can create a nested dictionary object

```py
from yaml import dump

def leak_aslr(io):
    key = "a"
    for layer in range(130):
        cur[key] = {}
        cur = cur[key]

    cur[key] = None
    fname = write_yaml(io, obj)
    load_yaml(io, fname)
    io.recvuntil(b"last_key = ")

```

With this leak we can obtain several addresses:

- several addresses of python objects in the heap, mostrly PyString
- the address of some PyModule objects
- the address of the shared object `yap`

Actually, having the last one allows us to know the address of all the shared objects that are loaded in memory, with the exception of the dynamic loader.
Now, with this leak we can obtain also the address of the libc, and with this leak the game is over. We can create a small rop that populates rdi with a pointer to a string that we control on the stack and then jump to system. This address can be obtained by difference from all the addresses that are printed by the debug mode. We can create a payload like `echo works; cat flag*` and obtain our flag.
