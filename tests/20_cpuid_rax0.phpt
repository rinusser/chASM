--TEST--
Check CPUID rax=0
--SKIPIF--
<?php if(!extension_loaded('chasm')||count(get_extension_funcs('chasm'))<=1) print 'skip'; ?>
--FILE--
<?php
/**
 * Tests the chasm_cpuid() function.
 * The PHP extension requires a 64bit x86 CPU - the x86-64/amd64 architecture requires SSE2, so it's safe to test for that
 */

$flags=chasm_cpuid();
printf("type: %s\n",gettype($flags));
printf("more than 50 entries: %s\n",count($flags)>50?'yes':'no');
$unique_entries=array_unique($flags);
sort($unique_entries);
printf("unique entries: %s\n",implode(', ',array_map(function($x){return var_export($x,true);},$unique_entries)));
printf("SSE2 support: %s\n",$flags['sse2']);
?>
--EXPECT--
type: array
more than 50 entries: yes
unique entries: false, true
SSE2 support: 1
