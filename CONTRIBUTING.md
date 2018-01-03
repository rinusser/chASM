# General

This extension for PHP isn't meant for use in production environments, it's just a demonstration. A lot of features
could conceivably be added, but most of them are safer to implement in other ways. If you can think of an interesting
addition to this module, or a reason to e.g. port the extension to another architecture please let me know.

If you find a bug, or an issue with the documentation feel free to add a ticket.


# Submitting GitHub Issues

### Bugs

If you find a bug please create a ticket with:
* a description of the error, ideally with steps to reproduce
* your OS type and version (e.g. Ubuntu 17.10)
* your CPU model (e.g. Intel Core i7-6850K), or at least its architecture (e.g. Intel Core i7, Broadwell)
* any virtualization you're using (e.g. I'm running this extension in a VirtualBox VM)

### New Features

If you'd like to see a new feature added please create a ticket with:
* a description of the feature
* why it should be done in Assembly instead of using safer ways (like calling system binaries)


# Working on Code

### Scope

The upcoming/planned work is managed in the [Issues list](https://github.com/rinusser/chASM/issues). Each
implemented/fixed GitHub issue corresponds to one commit in `master`, with the issue number (prefixed with `CHA-`) in
the commit message.

### Code Style

There's no automated enforcing of code styling, please just continue the existing style: 2 spaces for indenting.

### Tests

There are .phpt tests to be executed by the PHP build system. Each added function should include such a test that checks
the function as thoroughly as possible.

Bug fixes should include regression tests to confirm that there was a bug, that the change fixed it and that it won't
return in the future.

### Validation

Each new or changed feature commited into the `master` branch should include or update the feature's documentation.
Each commit into master should pass all tests (except 10\_c\_bootstrap.phpt, that should get skipped). Tests are
executed in the PHP sources root with:

    $ make test TESTS=ext/chasm

### Documentation

Features and limitations should be documented. The target audience can be expected to know PHP and x86 Assembly.

### Licensing

Please note that the code is currently licensed under GPLv3 - any contributions are expected to share this license.

I may change the license to a less restrictive open source license at a later date.
