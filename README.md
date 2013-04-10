flex-twittersearch-widget
=========================

This widget is for monitoring Tweets within a specific geographic area. It was designed for disaster response efforts. You can combine its capabilities with other FlexViewer widgets. It includes searching Twitter within a geographic area, applying multiple filters against search results, automatic refresh, and clustering of results on map. 

####Main screen

![App](https://raw.github.com/esri/flex-twittersearch-widget/master/main_screen.png)

####Settings screen

![App](https://raw.github.com/esri/flex-twittersearch-widget/master/settings.png)

####Search results

![App](https://raw.github.com/esri/flex-twittersearch-widget/master/search_result.png)


##Installation

###Option 1

1) Copy twittersearch directory from the download into the widgets folder of your ArcGIS Viewer for Flex directory in FlashBuilder. The path should be \widgets\twittersearch. 
   - If you don't do this you will have lots of path errors when you try to run the widget.
   - If you don't have the the Viewer source code it can be downloaded here: 
     [https://github.com/ArcGIS/ArcGISViewerForFlex/tags](https://github.com/ArcGIS/ArcGISViewerForFlex/tags)
   - It's strongly recommended that you compile this widget with at least Adobe Flex SDK v4.6.
	 
2) Be sure to add twittersearch to config.xml and reference twittersearch/widgets/TwitterSearchWidget.swf, for example:

            <widget label="TwitterSearch"  x="850" y="100" preload="open" 
                icon="assets/images/i_twitter.png" 
                config="widgets/twittersearch/widgets/TwitterSearchWidget.xml"
                url="widgets/twittersearch/widgets/TwitterSearchWidget.swf"/>  

3) Configure twittersearch.xml to point to the location of your TwitterSearch ouath proxy. The project won't work without this. These have been included with your download in the /oauthproxy directory. 

4) Install PHP OAuth proxy. As of May 2013, Twitter will require all applications to use OAuth authentication. Versions of the TwitterSearch widget prioer to v4 used un-authenticated GET requests and will stop working as of May 2013. Here's the link to the [Twitter Search API doc](https://dev.twitter.com/docs/api/1.1/get/search/tweets).

**IMPORTANT: ONLY a PHP proxy is available as of v4.**

NOTE: Mac users. You will have to seperately install [Mcrypt](http://php.net/manual/en/book.mcrypt.php) libraries to test the proxy.

NOTE: Windows Users. I believe that the PHP for Windows installs the Mcrypt libraries automaticallyq: [http://windows.php.net/index.php](http://windows.php.net/index.php).

The widget won't work without this and you'll see an error when you try to run the widget. You do not have to recompile if you get the wrong proxy url. Simply change location in the xml, save the file,then restart the browser tab or window and the new proxy location should take effect. Sometimes, a user may have to flush their browser to ensure the changes took effect.
   
IMPORTANT: If you don't add a proxy directory, then when you go to run/debug the project it will throw an error. Once you set up the proxy this error will go away.

5) In FlashBuilder, under Project > Properties > Flex Modules: be sure you add a reference to the TwitterSearch module.This is an easy-to-forget step. But, if you don't do it, then the widget won't launch.

6) Copy as3corelib.swc from the root directory of the zip file into the lib directory of your Viewer project.

###Option #2: Deploy Immediately Option

The precompiled folder of the repo contains a precompiled version of the widget that's ready to be dropped onto a web server. You'll still need to configure twittersearch.xml, FlexViewer's config.xml, and set up the OAuth proxy.

##Configuring and Testing the OAuth Proxy (REQUIRED)

The proxy REQUIRES PHP and the Mcrypt library be installed. Mycrypt is typically installed when you use PHP for Windows. Mac users it might be easier to install PHP for Windows on a Windows Virtual Machine than go through the convolutions of installing Mycrypt on your Mac.

###Setting up Twitter Developer Account
- You WILL need a [Twitter Developer Account](https://dev.twitter.com/).
- Sign into your Twitter Developer Account.
- Hover over your Avatar (upper right hand side of page) and select "My Applications".
- Select Create New Application.
- The Application Website field needs the website of your organization. 
- The callback URL needs to be on a public website. You can still test locally even if you set this to a public website URL.
- Under the "Details" tab, copy the Consumer Key and Consumer Secret and paste those into the config.php file.
- Set the DOMAIN in config.php. Example for esri.com is ".esri.com".

###Configure the proxy

- Edit test.php by commenting out everything but the last two lines of code for generating the Random Key and IV. Run createKey.php to get your Key and IV. 
- Copy the Key and IV into config.php.
- Set the timezone in config.php.
- Run test.php. If everything is setup properly it should run with no errors.
- Sign into OAuth using sign_in.php
- Run the following command in your browser. If it fails to return values then something isn't set up correctly: [http://your_domain_name/oauthproxy/?cmd=search&geocode=34.26847173704432%2C-118.02937514220592%2C40mi&count=40&nocache=Thu%20Apr%204%2018](http://<your domain>/oauthproxy/?cmd=search&geocode=34.26847173704432%2C-118.02937514220592%2C40mi&count=40&nocache=Thu%20Apr%204%2018)
- Once this is configured you should be good to try and run the TwitterSearch widget inside FlexViewer.

If you simply can't get encryption to work then you can do the following (NOT RECOMMENDED and totally unsupported) steps. Most problems with encryption will stem from the Mcrypt library not being loaded.

- index.php comment out lines 15 thru 18 as well as 68, 69 and 70. Uncomment line 73. You might also have to comment out the require_once that points to Encrypt.php.
<code><pre>
	//$oauth_token = $encrypt->decrypt(base64_decode($access_token['oauth_token'])); echo "oauth ". (string)trim($oauth_token);
	//$oauth_token_secret = $encrypt->decrypt(base64_decode($access_token['oauth_token_secret'])); echo "\n\nsecret ". $oauth_token_secret."\n\n";
    //$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, (string)trim($oauth_token), (string)trim($oauth_token_secret));

	// Create a TwitterOauth object with consumer/user tokens.
    $connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $access_token['oauth_token'], $access_token['oauth_token_secret']);
</pre></code>    

- callback.php comment out the require_once pointing to Encrypt.php. Comment out lines 29, 30 and 31. Comment out lines 61 - 66.

##Minimum Requirements

- Adobe Flex 4.6. 

- The ArcGIS Flex API v3.x SDK which includes the swc library. This can be downloaded here: [http://resources.arcgis.com/en/communities/flex-api/](http://resources.arcgis.com/en/communities/flex-api/)

- Internet access to the ArcGIS Online sample servers.

- Web Server to deploy the application either Apache or IIS

- The ArcGIS Flex Viewer: [http://resources.arcgis.com/en/communities/flex-viewer/index.html](http://resources.arcgis.com/en/communities/flex-viewer/index.html)

- Flash Player 11.6 or greater

- oauthphp proxy. As of version 4 there is only one proxy and it runs on PHP.

- as3corelib.swc which is available in the root directory of the project.

- NOTE: The proxy included with this widget is not compatible as replacements for the Flex Viewer's own proxies. 

- Special NOTE: Twitter is subject to rate limiting. More details here [https://dev.twitter.com/docs/api/1.1/get/search/tweets](https://dev.twitter.com/docs/api/1.1/get/search/tweets) 

[](Esri Tags: FlexViewer Flex Widget Twitter OAuth)
[](Esri Language: ActionScript)