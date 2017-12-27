--TEST--
Check for chASM presence
--SKIPIF--
<?php if (!extension_loaded('chasm')) print 'skip'; ?>
--FILE--
<?php
/**
 * No matter what stage the extension is in, after a successful build some version of the module should always be available
 */

echo "chASM extension is available";
?>
--EXPECT--
chASM extension is available
