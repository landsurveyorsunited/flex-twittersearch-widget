package widgets.twittersearch.controllers
{	
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.Label;
	
	import spark.components.TextArea;
	
	import widgets.twittersearch.components.MasterMsgHBox;

	[Bindable]
	/**
	 * Singleton class that stores all the TwitterSearchWidget session data so it can be accessed
	 * by the various subcomponents of this widget. 
	 * 
	 * And it also is used to manage global status messages to the user.
	 */
	public class TweetDataManager extends EventDispatcher
	{				
		
		/**
		 * Specifies whether or not user is logged into Twitter.
		 */
		public var isLoggedIn:Boolean;
		
		/**
		 * The URL for the OAuth proxy. In order to use this <code>useOauth</code> must be set.
		 */
		public var oauthProxyUrl:String;
		
		/**
		 * The URL for the twitter request/response proxy. 
		 */
		public var proxyURL:String;
		
		/**
		 * The Twitter Search API URL. For this widget you need to use the one for returning ATOM-based results.
		 */
		public var twitterSearchURL:String;
		
		/**
		 * This is the version number of the widget. 
		 */
		public var version:String;
		
		/**
		 * Determines whether the widget will allow user to attempt login to OAuth.
		 * If set to <code>yes</code> then Login button will be enabled. 
		 * Correct values are <code>yes</code> or <code>no</code>.
		 */
		public var useOauth:String;
		
		/**
		 * Used to store the <code>Polygon</code> of the tweet search radius circle.
		 */
		public var circle:Polygon;
		
		/**
		 * Use this property to store the location where the user clicks on the map.
		 */
		public var clickLocationMapPoint:MapPoint;
		
		/**
		 * DEPRECATED in v2.3.1
		 * TextArea that displays the users Twitter login name.
		 */
		public var twitterUserName:TextArea;		
		
		/**
		 * Use this to hold the tweet results in a CSV format for downloading.
		 */
		public var tweetsCSV:String;
		
		/**
		 * Sets whether or not the Twitter password has been verified via OAuth.
		 */
		public var passwordVerified:Boolean;
		
		/**
		 * Determines whether or not the user has geo-enabled their Twitter account.
		 * This can only be set at twitter.com.
		 */
		public var geoEnabled:Boolean;
		
		/**
		 * The relative icon directory path.
		 */
		public var internalIconDirectory:String;
		
		/**
		 * This dispatcher is used to pass simple text messages back to the User Interface.
		 * 
		 * @param type Must be an accepted event type for the TwitterSearch Widget. 
		 */
		public function dispatch(type:Event):Boolean
		{
			return dispatchEvent(type);
		}				
		
		private static var _classInstance:TweetDataManager = new TweetDataManager();
		
		public function TweetDataManager()
		{
			if(_classInstance)
			{
				throw new Error("TweetDataManager can only be accessed through TweetDataManager.getInstance()");
			}
		}
		
		public static function getInstance():TweetDataManager
		{
			return _classInstance;
		}		
	}
}