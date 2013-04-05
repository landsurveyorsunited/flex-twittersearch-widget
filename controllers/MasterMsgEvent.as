package widgets.twittersearch.controllers
{
	import flash.events.Event;

	/**
	 * Handles widget events that need to have status information displayed to the user.
	 */
	public class MasterMsgEvent extends Event
	{
		public static const ALERT_LOGOUT:String = "LoggedOut";
		public static const ALERT_LOGOUT_FAILURE:String = "LogoutFailure";
		public static const ALERT_LOGIN:String = "LoggedIn";
		public static const ALERT_LOGIN_FAILURE:String = "LoginFailure";
		public static const GENERIC_MESSAGE:String = "GenericMessage";
		public static const SHOW_ERROR:String = "null";
		public static const NEW_GEOTWEET_LOCATION:String = "null";
		
		/**
		 * This Event class provides access to events initiated via the TwitterSearch widget.
		 * @param type The type of Error.
		 * @param data The data you with to send/receive. Takes types Object, String, Array.
		 * 
		 */		
		public function MasterMsgEvent(type:String,data:*)
		{
			this.data = data;
			super(type);  			
		}
		
		/**
		 * Data that you want to send/receive. Takes types Object, String, Array.
		 */
		public var data:* = "";		
		
		public override function clone():Event
		{
			return new MasterMsgEvent(type,data);
		}			
	}
}