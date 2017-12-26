<?php
declare(strict_types=1);
/**
 * Demonstration file for chASM extension.
 * Can test both the C bootstrap setup and the final NASM version
 *
 * requires PHP version 7.0+
 * @author Richard Nusser
 * @copyright 2017 Richard Nusser
 * @license GPLv3 (see http://www.gnu.org/licenses/)
 * @link https://github.com/rinusser/chASM
 */

$nl=php_sapi_name()==='cli'?"\n":"<br>\n";
$module='chASM';


function run_asm_tests()
{
  global $nl;

  echo 'cpuid(rax=0) flags: ',implode(', ',array_keys(array_filter(chasm_cpuid()))),$nl;
  echo 'cpuid vendor id: ',chasm_vendorid(),$nl;
  $parts=[];
  foreach([0,1,2,3] as $count)
    $parts[]=$count.'=>'.var_export(chasm_partest(...array_slice(range(0,$count),1)),true);
  echo 'partest arg counts: ',implode(', ',$parts),$nl;
  echo 'adding:',$nl;
  echo '  chasm_addf() = ',var_export(chasm_addf(),true),$nl;
  foreach([1,-234.5/*,NULL*/] as $a)
    foreach([-6,78.901/*,NULL*/] as $b)
      echo sprintf('  chasm_addf(%s,%s) = %s',var_export($a,true),var_export($b,true),var_export(chasm_addf($a,$b),true)),$nl;

  $values=[];
  $max_rand=getrandmax();
  for($tc=0;$tc<100000;$tc++)
    $values[]=(float)(rand(0,1)>0?1:-1)*rand()/$max_rand*pow(10,rand(-20,20));
  $values=array_chunk($values,2);
  $start_builtin=microtime(true);
  foreach($values as $numbers)
    $sum=$numbers[0]+$numbers[1];
  $end_builtin=microtime(true);
  $start_addf=microtime(true);
  foreach($values as $numbers)
    $sum=chasm_addf($numbers[0],$numbers[1]);
  $end_addf=microtime(true);
  echo sprintf("adding by builtin: %0.2f ms\n",($end_builtin-$start_builtin)*1000);
  echo sprintf("adding by addf():  %0.2f ms\n",($end_addf-$start_addf)*1000);
}

function run_c_tests()
{
  global $nl;
  if(confirm_chasm_compiled('asdf')===0x01020304)
    echo 'The C module was compiled and loaded successfully.',$nl;
  else
    echo 'The C module doesn\'t seem to be working properly.',$nl;
}


if(!extension_loaded($module))
  dl('chasm.'.PHP_SHLIB_SUFFIX);

$functions=get_extension_funcs($module);

echo 'Functions available in the test extension:',$nl;
foreach($functions as $func)
  echo ' * ',$func,$nl;
echo $nl;

if(extension_loaded($module))
{
  if(count($functions)==1 && $functions[0]=='confirm_chasm_compiled')
    run_c_tests();
  else
    run_asm_tests();
}
else
  echo "Module $module is not compiled into PHP",$nl;
