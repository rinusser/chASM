/**
 * Placeholder module file to bootstrap the build process
 *
 * \author Richard Nusser
 * \copyright 2017 Richard Nusser
 * \license GPLv3 (see http://www.gnu.org/licenses/)
 * \link https://github.com/rinusser/chASM
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_chasm.h"


PHP_FUNCTION(confirm_chasm_compiled)
{
	char *arg = NULL;
	size_t arg_len, len;
	zend_string *strg;

	if (zend_parse_parameters(ZEND_NUM_ARGS(), "s", &arg, &arg_len) == FAILURE) {
		return;
	}

  char *strtxt="successfully ran module %s, args %s.";
  char *chasmtxt="chasm";
  asm (
    "mov $0,%%rdi\n"
    "mov %1,%%rsi\n"
    "mov %2,%%rdx\n"
    "mov %3,%%rcx\n"
    "call strpprintf\n"
    "mov %%rax,%0\n"
    :"=r"(strg)
    :"r"(strtxt), "r"(chasmtxt), "r"(arg)
    :"%rax","%rcx","%rdx","%rdi","%rsi"
  );

  RETURN_LONG(0x01020304);
}


/* {{{ PHP_MINIT_FUNCTION
 */
PHP_MINIT_FUNCTION(chasm)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MSHUTDOWN_FUNCTION
 */
PHP_MSHUTDOWN_FUNCTION(chasm)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_RINIT_FUNCTION
 */
PHP_RINIT_FUNCTION(chasm)
{
#if defined(COMPILE_DL_CHASM) && defined(ZTS)
	ZEND_TSRMLS_CACHE_UPDATE();
#endif
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_RSHUTDOWN_FUNCTION
 */
PHP_RSHUTDOWN_FUNCTION(chasm)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MINFO_FUNCTION
 */
PHP_MINFO_FUNCTION(chasm)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "source language active", "C");
	php_info_print_table_end();
}
/* }}} */

/* {{{ chasm_functions[]
 */
const zend_function_entry chasm_functions[] = {
	PHP_FE(confirm_chasm_compiled,NULL)
	PHP_FE_END
};
/* }}} */

/* {{{ chasm_module_entry
 */
zend_module_entry chasm_module_entry = {
	STANDARD_MODULE_HEADER,
	"chASM",
	chasm_functions,
	PHP_MINIT(chasm),
	PHP_MSHUTDOWN(chasm),
	PHP_RINIT(chasm),
	PHP_RSHUTDOWN(chasm),
	PHP_MINFO(chasm),
	PHP_CHASM_VERSION,
	STANDARD_MODULE_PROPERTIES
};
/* }}} */

#ifdef COMPILE_DL_CHASM
#ifdef ZTS
ZEND_TSRMLS_CACHE_DEFINE()
#endif
ZEND_GET_MODULE(chasm)
#endif
