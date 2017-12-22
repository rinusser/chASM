/**
 * Placeholder module header to bootstrap the build process
 *
 * \author Richard Nusser
 * \copyright 2017 Richard Nusser
 * \license GPLv3 (see http://www.gnu.org/licenses/)
 * \link https://github.com/rinusser/chASM
 */

#ifndef PHP_CHASM_H
#define PHP_CHASM_H

extern zend_module_entry chasm_module_entry;
#define phpext_chasm_ptr &chasm_module_entry

#define PHP_CHASM_VERSION "0.06"

#ifdef PHP_WIN32
# define PHP_CHASM_API __declspec(dllexport)
#elif defined(__GNUC__) && __GNUC__ >= 4
# define PHP_CHASM_API __attribute__ ((visibility("default")))
#else
# define PHP_CHASM_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif

#define CHASM_G(v) ZEND_MODULE_GLOBALS_ACCESSOR(chasm, v)

#if defined(ZTS) && defined(COMPILE_DL_CHASM)
ZEND_TSRMLS_CACHE_EXTERN()
#endif

#endif
