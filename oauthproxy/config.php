<?php

/**
 * @file
 * A single location to store configuration.
 */

define('CONSUMER_KEY', 'See README');
define('CONSUMER_SECRET', 'See README');
define('OAUTH_CALLBACK', 'http://localhost/oauthproxy/callback.php');
define('OAUTH_COOKIE', 'my_twitter_app_oauth');
define('OAUTH_COOKIE_DOMAIN', ''); //Example ".esri.com"

//REQUIRED - Encrypt your cookies
//http://si0.twimg.com/images/dev/oauth_diagram.png
//Create your own unique ENCRYPTION_KEY via Encrypt.get_RandomKey()
define('ENCRYPTION_KEY','use get_RandomKey()'); 
//Create your own unique initialization vector via Encrypt.get_IV()
define('IV','use get_IV()');
define('DEFAULT_TIME_ZONE','America/Los_Angeles');
