--TEST--
Check for asm presence
--SKIPIF--
<?php if (!extension_loaded("chasm")) print "skip"; ?>
--FILE--
<?php
echo "chASM extension is available";
?>
--EXPECT--
chASM extension is available
