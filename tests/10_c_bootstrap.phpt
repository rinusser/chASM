--TEST--
Check if C bootstrap stage works, if it's loaded
--SKIPIF--
<?php
if(extension_loaded('chasm'))
{
  $functions=get_extension_funcs('chasm');
  if(count($functions)==1 && $functions[0]=='confirm_chasm_compiled')
    return;
}
print 'skip'; ?>
--FILE--
<?php
$result=confirm_chasm_compiled('asdf');
if($result===0x01020304)
  echo 'The C module was compiled and loaded successfully.';
else
  echo 'The C module doesn\'t seem to be working properly!';
?>
--EXPECT--
The C module was compiled and loaded successfully.
