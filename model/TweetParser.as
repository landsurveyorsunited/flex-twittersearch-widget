package widgets.twittersearch.model
{
	import com.esri.ags.utils.JSONUtil;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectProxy;
	import mx.utils.URLUtil;
	
	import widgets.twittersearch.controllers.MasterMsgEvent;
	import widgets.twittersearch.controllers.TweetDataManager;

	/**
	 * A class for parsing XML tweet results
	 */
	public class TweetParser
	{
		private var _tdm:TweetDataManager;
		private var _csvHolder:String = null;				
		
		/**
		 * A class for parsing XML tweet results
		 * 
		 * @param singleton An instance of the TweetDataManager.
		 */
		public function TweetParser(singleton:TweetDataManager)
		{
			_tdm = singleton;
		}
		
		/**
		 * Parse the results from the twitter SEARCH API.
		 */
		public function parseJSON(data:Object):ArrayCollection
		{
			var tempArray:ArrayCollection = new ArrayCollection(); 
			
			//XMLSyndicationLibrary does not validate that the data contains valid
			//XML, so you need to validate that the data is valid XML.
			//Use the XMLUtil.isValidXML API from the corelib library.
/*			
			if(!XMLUtil.isValidXML(data))
			{
				_tdm.dispatch(new MasterMsgEvent(MasterMsgEvent.GENERIC_MESSAGE,"Status: Invalid XML error."));						
				return null;
			}   
*/			
			//create Atom1.0 instance and parse it using XMLSyndicationLibrary
			//var t:Object = com.adobe.serialization.json.JSONEncoder(data);
			//var recordset:ArrayCollection = data as ArrayCollection;
			//var row:Object = recordset.getItemAt( 1 );
			try
			{
				var json:Object = JSONUtil.decode(data.toString());
				var test:String = json.signedout;
			}
			catch(error:Error)
			{
				trace("TweetParser.parseJson: " + error.getStackTrace());
			}

			//var atom:Atom10 = new Atom10();
			//atom.parse(data);
			
			if(test != null)
			{
				tempArray.addItem(new ObjectProxy({
					loggedin: false
				}));
			}
			else
			{
				//trap errors               
				try 
				{                
					if (json == null)
					{
						_tdm.dispatch(new MasterMsgEvent(MasterMsgEvent.SHOW_ERROR,"Error: There was a problem retrieving the tweets. "));		
						return null;
					}
						
					else
					{                                                                                                       						
						for each(var element:Object in json.statuses)
						{                                      
	
							var geometry:String  = "";
							var geoLocation:String = null;
							var id:String = element.id;  //at some future date this may need better resolution
							var title:String = element.text;
							var imageURL:String = element.user.profile_image_url;
							var name:String = element.user.screen_name;             
							var published:String = publishedDateFormatter(element.user.created_at);
							var googleLocation:String = null;
							var twitterLocation:String = ""; 
							var bitmapDetector:String =  imageURL.slice(-3,imageURL.length).toLowerCase();
							var geoLocationEnabled:String = "Transparent.png"; //Blank place holder - used to display icon on repeater grid
							
							//Occasionally Twitter serves some of its own images. These can trigger a 
							//Security Sandbox Violation. E.G. http://static.twitter.com/images/default_profile_normal.png
							//Since Twitter doesn't allow direct connections from Web applications you have send this
							//image request through a proxy. The proxy must be equipped to handle binary images otherwise
							//it will just return garbage.                           
							if(URLUtil.getServerName(imageURL) == "static.twitter.com")
							{
								imageURL = _tdm.proxyURL + "?uri=" + imageURL;
							}
							
							//Flash Player does not properly handle .bmp file format. I took the easy way out 
							//and just decided to replace any .bmp with a default image.
							if(bitmapDetector == "bmp")
							{
								//example: "http://s.twimg.com/a/1261519751/images/default_profile_0_bigger.png";
								imageURL = _tdm.internalIconDirectory + "i_empty_twittericon.png";                              
							}
							
							if(element.user != null)
							{
								twitterLocation = element.user.location;
							}
							
							if(element.geo != null)
							{
								geoLocation = element.geo.coordinates[0].toString() + ", " + element.geo.coordinates[1].toString();
							}
							
							if(element.place != null)
							{
								googleLocation = element.place.full_name;
							}
							
							if(geoLocation != null)
							{
								geometry = geoLocation;
								geoLocationEnabled = "YellowStickpin.png";
							}
							else
							{
								geometry = googleLocation;
							}
							
							//Make hyperlinks active and set to open in a new window
							title = title.replace(/((https?|ftp|telnet|file):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)/g,
								"<u><a href='$1' target='_blank'>$1</a></u>");
							
							//NOTE: have to use ObjectProxy to avoid IEventDispatcher Warnings
							tempArray.addItem(new ObjectProxy(
								{
									googleLocation:googleLocation,
									twitterLocation:twitterLocation,
									twitterID:id,
									title:title,
									imageURL:imageURL,
									name:name,
									published:"<br/>"+published,
									geometry:geometry,
									geoenabled:geoLocationEnabled,
									loggedin:true
								}
							));						   
						} 
						
						createCSV(tempArray);
					}
				} 
				catch (error:Error)
				{
					_tdm.dispatch(new MasterMsgEvent(MasterMsgEvent.SHOW_ERROR,"Error: There was a problem retrieving the tweets. "));		
					trace("parseAtom: " + error.getStackTrace());                   
					return null;    
				}
			}
			
			return tempArray;
		}
		
		private function createCSV(array:ArrayCollection):void
		{
			_csvHolder = null;
			
			//Set the title row for the CSV file
			_csvHolder = "Name,Time,Title,Google location,Twitter location,Image URL," + "\r\n";
			
			for each(var obj:Object in array)
			{
				_csvHolder = _csvHolder + 
					replaceCharacters(obj.name) + "," +
					replaceCharacters(obj.published) + "," +
					replaceCharacters(obj.title) + "," +
					replaceCharacters(obj.googleLocation) + "," +
					replaceCharacters(obj.twitterLocation) + "," +
					obj.imageURL + "," + "\r\n";
			} 
		}
		
		/**
		 * Provides a <code>String</code> represention of the last retrieved tweets. 
		 * This string is provided in a CSV usable format. 
		 */
		public function get tweetsCSV():String
		{
			return _csvHolder;
		}				
		
		/**
		 * The data from twitter needs special filtering applied before it's useful in a spreadsheet.
		 * This function applies various regex patterns to filter the data.
		 */
		private function replaceCharacters(string:String):String
		{
			
			if(string != null)
			{
				//For ease of modification these various regex's are listed out seperately
				//You'll need to tune these as you see fit. Just a reminder that /g is a 
				//pattern-match modifier for doing a global match.
				//If you don't set that the app will only pick the first occurrence.
				var pattern1:RegExp = /#/g;
				string = string.replace(pattern1,"&#35");	//replace hashtags #			
				var pattern2:RegExp = /,/g;		
				string = string.replace(pattern2," "); 	//replace commas
				var pattern3:RegExp = /\u00DC/g;
				string = string.replace(pattern3,"U");	//replace umlauts
				var pattern4:RegExp = /\n/g;
				string = string.replace(pattern4,"");	//replace carriage returns
			}
			
			return string;
		}
					
		private function publishedDateFormatter(date:Object):String
		{
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "MMM, DD YY @ J:NN:SS";
			return dateFormatter.format(date);
		}
		
		/**
		 * Examine the twitter error message. The documentation claims twitter throws a 503 error
		 * but in testing we only saw HTTP 200.
		 * 
		 * DEPRECATED @ v4
		 */
//		private function retrieveAtomError(atom:Atom10):ArrayCollection         
//		{
//			var arr:ArrayCollection = new ArrayCollection();                    
//			
//			try
//			{                                                       
//				var list:XMLList = atom.feedData.xml;
//				
//				for each(var item:XML in list)
//				{
//					arr.addItem(item.child("error")[0].toString()); 
//					_tdm.dispatch(new MasterMsgEvent(MasterMsgEvent.GENERIC_MESSAGE,"Status: Problem loading feed."));													
//				} 
//			}
//			catch(err:Error)
//			{
//				trace("Trapping errors in atom.entries: " + err.getStackTrace());
//			}
//			
//			//return value - currently not using the return data for anything
//			return arr;             
//		}		
	}		
}