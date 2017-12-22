dnl config.m4 for extension chasm

PHP_ARG_ENABLE(chasm, whether to enable chASM support,
[  --enable-chasm         Enable chASM support])

if test "$PHP_CHASM" != "no"; then
  PHP_NEW_EXTENSION(chasm, chasm.c, $ext_shared,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
fi
