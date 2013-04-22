<?php
session_start();
require_once('config.php');
require_once('Encrypt.php');

$key = base64_decode(ENCRYPTION_KEY);
$iv = base64_decode(IV);
echo "Key: " . $key;
echo "\n\nIV: ". $iv;
$test = new Encrypt($key,$iv,DEFAULT_TIME_ZONE);

if(isset($_COOKIE["twitterapp"]))
{
    header('Content-Type: application/json');

    $retrieved_cookie =  $_COOKIE["twitterapp"];
    echo "\n\nEncrypted value: " . $retrieved_cookie;
    echo "\n\nActual Value: " . "VodG7slxk+w0INvK66gztp4TOLijNzyiWDzI8Z4IU4PTiBJJkRPdkaEbDtXFYUVkCVU=";
    echo "\n\nDecrypted Value: " . $test->decrypt(base64_decode($retrieved_cookie));

}
else
{
    $fake_cookie_string = "VodG7slxk+w0INvK66gztp4TOLijNzyiWDzI8Z4IU4PTiBJJkRPdkaEbDtXFYUVkCVU=";
    $encrypted_cookie = base64_encode($test->encrypt($fake_cookie_string));
    $cookie_life = time()+3600; //one hour
    setcookie("twitterapp", $encrypted_cookie, $cookie_life, '/', OAUTH_COOKIE_DOMAIN);
    header('Location: http://your_domain_name/oauthphp/test.php', true, 302);
    exit;

}
?>