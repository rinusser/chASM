--TEST--
Check CPUID vendor ID
--SKIPIF--
<?php if(!extension_loaded('chasm')||count(get_extension_funcs('chasm'))<=1) print 'skip'; ?>
--FILE--
<?php
/**
 * Tests the chasm_vendorid() function.
 * The actual string returned depends on the CPU brand (and sometimes type), but we know it must be a 12 character string that looks like text.
 */

$vendor_id=chasm_vendorid();
printf("type: %s\n",gettype($vendor_id));
printf("length: %d\n",strlen($vendor_id)); //mb_strlen() would be safer here, but that would make mbstring support mandatory
printf("charset OK: %s\n",preg_match('/^[a-z0-9_. -]+$/i',$vendor_id)?'yes':'no');
printf("number of whitespaces <7: %s\n",strlen($vendor_id)-strlen(str_replace(' ','',$vendor_id))<7?'yes':'no');
?>
--EXPECT--
type: string
length: 12
charset OK: yes
number of whitespaces <7: yes
