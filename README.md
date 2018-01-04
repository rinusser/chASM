# Synopsis

An extension for PHP, written in Assembly.

The sources are hosted on [GitHub](https://github.com/rinusser/chASM).


# Wait, what?

Yes, you read right: this is a PHP extension that's built with NASM.

If you're looking for a sensible rationale as to why this PHP extension exists: don't bother, you won't find any.

The main reason I wrote this was because mixing PHP and Assembly came up in a joke and sounded ridiculously useless.
Then I thought "wait a minute.." and long story short, here it is. If it helps, consider this a proof-of-concept of
writing Assembly code that can be invoked in a PHP script.


# Requirements

* a 64-bit x86 processor (physical or virtual)
* a 64-bit operating system using the System V calling convention, e.g. Linux (tested with Ubuntu 17.04)
* a 64-bit version of PHP 7 (tested with 7.0.18)
* NASM (tested with 2.12.02)
* build tools for PHP


# Installation

see [INSTALL.md](https://github.com/rinusser/chASM/blob/master/INSTALL.md).


# Usage

If the extension is loaded correctly you can call the chasm\_\*() functions in your PHP code, e.g.:

    printf("cpuid vendor id: %s\n",chasm_vendorid());

Currently the most useful examples are in chasm.php.


# Tests

The chasm.php file can show whether the extension is loaded and which module version (C bootstrap or final NASM) is
active. There are also .phpt test cases to verify the module's features automatically.

The installation instructions (INSTALL.md) show how to validate the setup.


# Legal

### Disclaimer

Do not use this PHP extension in production, ever. Seriously, don't. Even the slightest oversight might cause data
corruption, delete your operating system, set fire to your computer and cause bodily harm to your goldfish.

### Copyright

Copyright (C) 2017 Richard Nusser

### License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

