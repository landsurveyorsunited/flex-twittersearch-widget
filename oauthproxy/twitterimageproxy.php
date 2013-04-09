<?php

//Version: 2.0.1b
//Creation Date: August 2010
//This proxy is designed to be used with the TwitterSearch FlexViewer widget
//IMPORTANT NOTICE:  This does NOT include any built-in security. It is strongly advised to lock down your proxy so that
//only authorized clients can use it, and that it only allows content to be referred to a specific destination.

$sURI = strtolower($_SERVER['REQUEST_METHOD']) == 'post' ? $_POST['uri'] : $_GET['uri'];

//$ch = curl_init("http://twitter.com/{$sURI}"); //use something like this to control where proxy can refer traffic
$ch = curl_init();

//Strip additional params off uri so we don't send them in final request stream
$shortURI = strtok($sURI,"&");

if ( strtolower($_SERVER['REQUEST_METHOD']) == 'post' && count($_POST) > 0 )
{
	curl_setopt($ch,CURLOPT_POST,TRUE);

	$aPost = array();
	foreach($_POST as $sIndex => $sValue)
	{
		$aPost[]="{$sIndex}=" . utf8_encode($sValue);
	}
	curl_setopt($ch, CURLOPT_POSTFIELDS,implode("&",$aPost));
}

$header = array(
     "Pragma: no-cache",
     "Cache-Control: max-age=0",
     "Expires: -1"
);

//Check for images. They require a binary stream and must be handled differently than text/html or xml
$ext = substr($sURI, -3);
switch ($ext) {
     case 'jpg': 
          $mime = 'image/jpeg';
          break; 
     case 'gif':
          $mime = 'image/gif'; 
          break; 
     case 'png':
          $mime = 'image/png';
          break; 
     case 'bmp':
          $mime = 'image/bmp';
          break;
     default: $mime = false; 
}

// Make sure the remote file is successfully opened before doing anything else.
// Treat image as binary otherwise you'll just get back garbage.
//To test if your proxy works with remote images try something like this: 
//http://<server path>/endpoint.php?uri=http://static.twitter.com/images/default_profile_normal.png
//If you get a 500 HTTP error make sure fopen() is enabled in php.ini
if ($mime && $file = @fopen($sURI, 'rb')) {
   
   header('Content-type: '.$mime);
   fpassthru($file);
   exit;   
}

curl_setopt($ch,CURLOPT_URL,$shortURI);
curl_setopt($ch,CURLOPT_HTTPHEADER, $header);
curl_setopt($ch,CURLOPT_RETURNTRANSFER, 1);
echo $result = curl_exec($ch);

if($result == false)
{
     error_log("endpoint.php - curl_exec error: ".curl_error($ch));
}

curl_close($ch);
?>