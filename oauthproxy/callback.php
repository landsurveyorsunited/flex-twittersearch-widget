<?php

//Version 2.0 by AndyG 4/2013
//Changes
//- added try/catch on getAccessToken()

// Start session and load lib
session_start();
require_once('twitteroauth/twitteroauth.php');
require_once('config.php');

$content = null;    //for verification of credentials
$connection = null; //for getting access token

// check if cookie exists
if(isset($_COOKIE[OAUTH_COOKIE])){
    // redirect back to app
    if(isset($_SESSION['oauth_referrer'])){
        header('Location: '.$_SESSION['oauth_referrer']);
        exit;
    }
}
else{
    // if verifier set
    if(isset($_REQUEST['oauth_verifier'])){
        // Create TwitteroAuth object with app key/secret and token key/secret from default phase
        $connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $_SESSION['oauth_token'], $_SESSION['oauth_token_secret']);
        // get access token from twitter
        try{
            $access_token = $connection->getAccessToken($_REQUEST['oauth_verifier']);
        }
        catch(Exception $e){
            header("HTTP/1.0 400 Error");
            echo "Failed retrieving access token: " .$e->getMessage();
            exit;
        }

        //Add a credentials validation request. Added v2.0 by AndyG
        try{
            $content = $connection->get('account/verify_credentials','');
        }
        catch(Exception $e){
            $error = $e->getMessage();
        }
        // save token
        $_SESSION['oauth_access_token'] = $access_token;
        // 1 year
        $cookie_life = time() + 31536000;

        if($content != null && $content->screen_name != ""){
            // set cookie
            setcookie(OAUTH_COOKIE, json_encode($access_token), $cookie_life, '/', OAUTH_COOKIE_DOMAIN);
            //header('Location: ./callback.php');
            echo "<html><head><title>Valid Verification</title><body bgcolor='#C0C0C0'>";
            //echo "Verify access token: ".json_encode($access_token); //for testing
            echo "<style type='text/css'>body{font-family:sans-serif;}</style>";
            echo "<table width='100%'><tr bgcolor='#FFFFFF'><td>";
            echo "<a href='http://www.esri.com'><img src='edn.png' style='border-style:none' alt='ESRI Developer Network' /></a>";
            echo "</td></tr></table>";
            echo "<h2>Welcome:&nbsp;&nbsp;<img src='".$content->profile_image_url."'></img>&nbsp;&nbsp;&nbsp;@".$content->screen_name."</h2>";
            echo "<h4>You have successfully authenticated with Twitter. </h4>" ;
            echo "<h4>It is okay to close this page and return to the application.</h4>";
            echo "<script language=\"JavaScript\">\n";
            echo "if(window.opener && window.opener.getTokens){";
            echo "window.opener.getTokens(\"".$_SESSION['oauth_token'].",".$_SESSION['oauth_token_secret']."\");}";
            //You can also have the app automatically close the window via self.close, as shown below
            //echo "self.close();";
            echo "</script>";
            echo "</body></html>";
        }
        else{
            header("HTTP/1.0 400 Error");
            echo "Failed to validate credentials.";
            exit;
        }
        exit;
    }
    else{
       // redirect
        if(isset($_SESSION['oauth_referrer'])){
            header('Location: '.$_SESSION['oauth_referrer']);
        }
        else{
            header('Location: '.OAUTH_CALLBACK);
        }
        exit;
    }
}
