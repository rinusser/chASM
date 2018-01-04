# Installation

This code can currently only be built as a static extension: building a shared extension would require major changes to
the Assembly code.

The build process used to be more complicated, it included a "C bootstrap" stage. The C code for that is still there as
might help people debugging their setups. It shouldn't currently be required to build this extension though.

### Prerequisites

You'll need to extract the PHP sources, set up your build environment and follow the PHP build instructions. To make
debugging build issues easier please build your PHP sources once, e.g. `./configure && make`, before attempting to
include the new module.

After that you'll need to create a new directory, `ext/chasm/`, relative to your PHP sources and copy this extension
there.

All the following paths are relative to where you extracted the PHP sources, e.g. `/usr/src/php7/`.

### Configuration

First you'll need to tell PHP's build system to update the list of extensions so the new chASM extension will be found:

    $ ./buildconf --force

Then you'll need to configure PHP to include the new extension. Pass any other arguments to `configure` as required.

    $ ./configure --enable-chasm && ext/chasm/update-static-makefile.sh

### Building

Now, build PHP:

    $ make

This should build PHP with the new extension.

### Verification

Once the build is complete, you can check whether the module is included by running `php -i`, e.g.:

    $ sapi/cli/php -i | grep -C3 -i chasm

This should output something like this:

    Configuration

    chASM

    source language active => NASM

If the output is empty or the "source language active" entry says "C" something went wrong.

There are tests you can run:

    $ make test TESTS=ext/chasm

The "10\_c\_bootstrap.phpt" test should be skipped, every other test should pass. As of writing this the test runner
should have found 6, skipped 1 and passed 5 tests.

There's also a short demonstration script you can run:

    $ sapi/cli/php -f ext/chasm/chasm.php

The script should currently start with a list of chasm\_\*() functions, end with a builtin/addf timing comparison and
most important of all, not crash horribly.
