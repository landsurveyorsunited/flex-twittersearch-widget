package widgets.twittersearch.model
{
    [Bindable]
    public class LatLonProcessor
    {
        /*
        * This is a class for processing Strings containing location data
		* NOTE: This class only returns data that was retrieving via a twitter API request.
		* There is no client side geo-coding provided. Therefore, if a tweet doesn't match
		* the criteria below, then it will not show up on the map.
        */
        
        private var _lat:String = new String();
        private var _lon:String = new String();    
        private var _decimalPlaces:Number = 6; //default number of decimal places on returned value    
                
        public function LatLonProcessor()
        {
        }

        public function detectTagInfo(obj:Object):Boolean
        {
            try
            {
                var detect_iPhone:Boolean = countOf(obj.googleLocation,'iPhone',true);
                var detect_UT:Boolean = countOf(obj.googleLocation,'ÜT',true);   
                var detect_geoTag:Boolean = isEmpty(obj.twitterLocation);
                var detect_iPhoneIsEmpty:Boolean = isEmpty(obj.googleLocation);
            }
            
            catch(err:Error)
            {
                //Protect against null values by trapping errors
                trace("LatLonProcessor: " + err.getStackTrace());
                return false;
            }                
            
            if(detect_geoTag == false || detect_iPhoneIsEmpty == false)
            {
                var googleLocation:String = obj.googleLocation;  
                var twitterLocation:String = obj.twitterLocation;
                var arr:Array = []; 
         
                if(detect_iPhone == true)
                {
                    arr = googleLocation.substr(8).split(',');
                    _lat = fixed(arr[0]);
                    _lon = fixed(arr[1]); 
                    return true;
                }
                else if(detect_UT == true)
                {
                    arr = googleLocation.substr(3).split(',');
                    _lat = fixed(arr[0]);
                    _lon = fixed(arr[1]);                 
                    return true;
                }
                else if(detect_geoTag == false)
                {
                    //Example: <georss:point>37.7178 -121.9059</georss:point> with a result of '37.7178 -121.9059'
					arr = twitterLocation.split(' ');
                    _lat = fixed(arr[0]);
                    _lon = fixed(arr[1]);                 
                    return true;                
                }
            }
            
            return false;
        }
        
        //Set the number of decimal places allowed on each return value
        private function fixed(_number:Number):String
        {
            var string:String = _number.toFixed(_decimalPlaces);
            return string;    
        }

        //trim whitespace from both sides of string since ActionScript doesn't currently
        //provide a native function for this.
        public static function trim(_string:String):String 
        {
            if (_string == null) { return ''; }
            return _string.replace(/^\s+|\s+$/g, '');
        }

        //find the number of times a character or sub-string appears in the string
        public function countOf(string:String, character:String, caseSensitive:Boolean = false):Boolean 
        {
            if (string == null) { return false; }
            var char:String = escapePattern(character);
            var flags:String = (!caseSensitive) ? 'gi' : 'g';
            var match:int = string.match(new RegExp(char, flags)).length;
            
            if(match == 0) return false;
            else return true;
        }
        
        //helper method
        private static function escapePattern(_pattern:String):String {
            return _pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/gi, '\\$1');
        }  
        
        //determine if string is empty or not
        //See article for reference: 
        //http://maohao.wordpress.com/2009/02/26/actionscript-101-null-vs-undefined/
        public function isEmpty(string:String):Boolean 
        {
            if (string == "null" || string == "" || string == "undefined") 
			{ 
				return true; 
			}
            return false;
        } 
        
        public function get lat():String
        {
            return _lat;
        }
        
        public function get lon():String
        {
            return _lon;
        }
        
        public function set decimalPlaces(_number:Number):void
        {
            _decimalPlaces = _number; 
        }
        
        public function get decimalPlaces():Number
        {
            return _decimalPlaces;
        }        
               
    }
}