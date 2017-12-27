--TEST--
Check parameter count feature
--SKIPIF--
<?php if(!extension_loaded('chasm')||count(get_extension_funcs('chasm'))<=1) print 'skip'; ?>
--FILE--
<?php
/**
 * Tests the chasm_partest() function: it's a vararg function that counts and returns the number of parameters passed.
 */

$x=['a',NULL,2];
printf("once: %s\n",var_export(chasm_partest($x),true));
printf("twice: %s\n",var_export(chasm_partest($x,$x),true));
printf("unpacked: %s\n",var_export(chasm_partest(...$x),true));
printf("unpacked twice: %s\n",var_export(chasm_partest(...$x,...$x),true));
?>
--EXPECT--
once: 1
twice: 2
unpacked: 3
unpacked twice: 6
