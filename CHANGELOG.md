# flex-twittersearch-widget - Changelog

Changes in v4:

- Added support for Twitter OAuth which is required as of May 2013.
- Deprecated capabilities for non-authenticated search requests.
- Added a PHP-only OAuth proxy.
- Deprecated .NET and .JSP non-authenticated proxies. 
- Fixed bug that was preventing some geocoded tweets from displaying properly.
- Updated widget to work with ArcGIS API for Flex v3.2 and FlexViewer v3.2.

Changes in v3.1.1:
- Fixed minor bug that occured when reading Twitter geo property, caused message [Object, object] display

Changes in v3.1:
- Replaced XML tweet parser with a JSON tweet parser. Around late August Twitter modified their XML
  that caused parsing errors.
- Changed popup text color to white. Apparently this broke when upgrading to Flex 4.6
- Deprecated the need the xmlsyndication.swc.

Changes in v3:
- Upgraded widget to work with ArcGIS API for Flex v3
- Refactored many of the libraries to comply more with MVC pattern
- Commented out deprecated Graphic.autoMoveToTop property where appropriate as it has been deprecated.

Changes in v2.3.1:
- Upgraded widget to work with ArcGIs API for Flex 2.3.1.
- REMOVED ability for the widget to send tweets, now it can only search for tweets. All this code has been pulled. 
  The reason is related to changes that Twitter made to OAuth and the relative difficulty and time involved to
  implement those changes and ensure security. Also, very few people used or took advantage of this functionality. So,
  I apologize if you were using this code, but most likely your code wasn't working. 
  If you figure it out please send me a tweet using @agup.
- Tweaked the custom clustering algorythm so that now any tweet that does not have a geographic location is snapped
  to the middle of the search area. In prior versions the tweet simply did not show up on the map.
- Default timer now sets to 30 seconds instead of 1 minute. 

v2.1.2b known issues:
- Geolocated tweets pop up in an infowindow that corresponds to the actual tweet location rather than snapping to a
  cluster.
- Occasionally an avatar image will not display.
- Minor: When opening and closing the tweet login panel, it does not fully close.
- Very Minor: The oauth login verification landing page could be improved. It's very lightweight.

Changes in v2.1.2b:
- Upgraded to use production ArcGIS API for Flex v2.1, and the new production version of the Viewer v2.1.
- Organized the various files of the widget into logical directories.
- Updated many parts of the code to allow for easier testing and scalability.
- Removed alot of un-unused code that was taking up space.
- Fixed a bug that was preventing twitter geo-coded tweets from showing up on the map.
- Including an FXP in the download for those who simply want to import the project.
- Including an .NET/ashx version of the twitter proxy in the download.
- In the "settings" window you can now download a .CSV version of the tweets.

Changes in v2.0.1b:
- Upgraded widget to work with ArcGIS API for Flex v2, the new ArcGIS Viewer for Flex 2, Flex 4.x and Oauth 1.0a.
- Now includes an ashx proxy along with PHP and JSP.
- Removed the integrated Flash local store that held the twitter username and password. This is now handled directly
  through twitter because of the Oauth 1.0a requirements.

v1.0.1b Known issues:
- Occasionally a tweet will appear to successfully send from the widget, but the tweet didn't really get sent.
  Most often this is a problem with the twitter api. This is a documented problem where Twitter returns an HTTP 200
  status and they also send back an HTML page containing an error message. A future version of widget could be built to
  accommodate this, but we are hoping that twitter fixes their system to return a proper HTTP error code.
- Some Twitter avatars aren't displaying even though a valid image url was returned from Twitter.
- When scrolling through a popup window both a open hand cursor and pointer finger hand cursor display on top of each other.
- The reply symbol, which shows up when you hover over an avatar, isn't very visible against dark avatar images.
- There isn't any built-in help page or FAQ.
- There isn't an ashx proxy that works with the widget, there's only PHP and JSP.

Changes in v1.0.1b
 - Enabled the automatic zoom-in feature when user executes a new search.  
   It is controlled in TwitterSearchWidget.xml using the <zoomonresults> tag. Valid settings
   are true or false. Default is false which means don't zoom in.
 - Fixed: Search area circle was not projected correctly. Changed calculation to use 270 or 90 degrees.
 - Fixed: Widget not minimizing properly and still maintained GUI space. Moved messageBox into WidgetTemplate.
 - Fixed Login button enabled when browser cookies deleted and no username or password was visible.
 - Minor changes to OpenCloseHandler.as to tweak the UI handling.
 - Modified endpoint.php to lock it down so it only works with certain hostnames.
 - Changes to twittersearch.css.
 - Installation instructions rewritten and condensed into one section of the README.