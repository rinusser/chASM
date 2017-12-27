--TEST--
Check adding floats
--SKIPIF--
<?php if(!extension_loaded('chasm')||count(get_extension_funcs('chasm'))<=1) print 'skip'; ?>
--FILE--
<?php
/**
 * Tests the chasm_addf() function: it should add 2 floats and return the result.
 */

$ti=1;
foreach([1,-234.5] as $a)
  foreach([-6,78.901] as $b)
    printf("%d: %0.4f\n",$ti++,chasm_addf($a,$b));

//adding NaN to anything should stay NaN
printf("5: %s\n",var_export(chasm_addf(1,NAN),true));
printf("6: %s\n",var_export(chasm_addf(NAN,1),true));
printf("7: %s\n",var_export(chasm_addf(NAN,NAN),true));

//adding +- infinity to a finite value should remain at infinity
printf("8: %s\n",var_export(chasm_addf(1,INF),true));
printf("9: %s\n",var_export(chasm_addf(-INF,10),true));

//adding -infinity and +infinity should fail gracefully with NaN
printf("10: %s\n",var_export(chasm_addf(-INF,INF),true));
?>
--EXPECT--
1: -5.0000
2: 79.9010
3: -240.5000
4: -155.5990
5: NAN
6: NAN
7: NAN
8: INF
9: -INF
10: NAN
