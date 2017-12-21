# Installation

As this extension currently is just a proof of concept there are a few hacky solutions involved here. For starters, you
might have to run a lot of this as user `root`.

### Prerequisites

You'll need to extract the PHP sources, set up your build environment and follow the PHP build instructions. To make
debugging build issues easier please build your PHP sources once, e.g. `./configure && make`, before attempting to
include the new module.

After that you'll need to create a new directory, `ext/chasm/`, relative to your PHP sources and copy this extension
there.

All the following paths are relative to where you extracted the PHP sources, e.g. `/usr/src/php7/`.

### C Bootstrap Setup

First you'll need to tell PHP's build system to update the list of extensions so the new chASM extension will be found:

    $ ./buildconf --force

Then you'll need to configure PHP to include the new extension. Pass any other arguments as required.

    $ ./configure --enable-chasm

Finally, build PHP:

    $ make

At this point the C bootstrapping module should be loaded, e.g. running `sapi/cli/php -f ext/chasm/chasm.php` should
output something like this:

    Functions available in the test extension:
     * confirm_chasm_compiled

    The C module was compiled and loaded successfully.

### Hooking the Assembly Module

Once the C module works you'll need to prepare the linking environment:

    $ cd ext/chasm/
    ext/chasm$ rm .libs/chasm.o
    ext/chasm$ ln -s ../chasm.o .libs/chasm.o

Then you can assemble the new module:

    ext/chasm$ nasm -f elf64 chasm.asm

At this point the new module is ready but not yet linked into the PHP binaries. To add the module, delete the existing
binaries you want it in (e.g. `rm sapi/cli/php` for the console version), then run `make` again. For example:

    ext/chasm$ cd ../../
    $ rm sapi/cli/php
    $ make

This should create a new CLI PHP binary, this time with the new Assembly module. You can verify this by running
`php -i`, e.g.:

    $ sapi/cli/php -i | grep -C3 -i chasm

This should output something like this:

    Configuration

    chASM

    source language active => NASM

If the output is empty or the "source language active" entry says "C" something went wrong.

Once the NASM version is working you can run the chasm.php test script again to confirm the new Assembly functions are
working:

    $ sapi/cli/php -f ext/chasm/chasm.php

The script should currently start with a list of chasm\_\*() functions, end with a builtin/addf timing comparison and
most important of all, not crash horribly.
