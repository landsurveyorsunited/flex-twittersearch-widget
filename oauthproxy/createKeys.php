<?php
  session_start();
  require_once('config.php');
  require_once('Encrypt.php');
  header('Content-Type: application/json');

  $test = new Encrypt(null,null,DEFAULT_TIME_ZONE);
  echo "\n\n---------\n\nGenerate Key (Base64): " . $test->get_RandomKey();
  echo "\n\n---------\n\nGenerate IV (Base 64): " . $test->get_IV();

?>