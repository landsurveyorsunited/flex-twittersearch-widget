package widgets.twittersearch.events
{
	
	import flash.events.Event;

	public class TwitterOauthEvent extends Event
	{
		
		public static const VERIFIED:String = "Credentials verified as valid";		
		public static const NOTVERIFIED:String = "Credential verification failed";
		public static const LOGIN_SUCCESS:String = "Log in was successful";
		public static const LOGIN_FAILED:String = "Log in was not successful";
		public static const LOGOUT_SUCCESS:String = "Log out was successful";
		public static const LOGOUT_FAILED:String = "Log out was not successful";
		
		/**
		 * Data that you want to send/receive. Takes types Object, String, Array.
		 */		
		public var data:* = "";
		
		/**
		 * This Event class provides access to events related to retrieving the configuration file.
		 * @param type The type of Error.
		 * @param data The data you with to send/receive. Takes types Object, String, Array.
		 */		
		public function TwitterOauthEvent(type:String,data:*)
		{
			this.data = data;
			super(type);   
		}
		
		public override function clone():Event
		{
			return new TwitterOauthEvent(type,data);
		}
	}
}