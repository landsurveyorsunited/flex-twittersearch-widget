
////////////////////////////////////////////////////////////////////////////////
//Name:  ProxyHttpService.as
//Source: DEPRECATED @ V4 of TwitterSearch Widget April 2013
////////////////////////////////////////////////////////////////////////////////

package widgets.twittersearch.controllers
{
    import mx.rpc.AsyncToken;
    import mx.rpc.http.mxml.HTTPService;
    import mx.utils.Base64Encoder;

    [Bindable]
    public class ProxyHttpService extends HTTPService 
    {
        private var _proxyUrl:String;
        private var _userName:String;
        private var _passWord:String;      
    
        public function ProxyHttpService()
        {
            super();         
        }
    
        override public function send(parameters:Object=null):AsyncToken 
        {
            var tempUrl:String = url.toLowerCase();
            var tempUrl2:String = url;            
                               
            //check for the type of proxy being used
            var proxyType:String = _proxyUrl.replace(new RegExp("\\?"),"").slice(-3,_proxyUrl.length).toLowerCase();
            
			//This is for use with endpoint.ashx. Remember we are just looking for the last 3 letters
			//of the file extension type.
			if(_proxyUrl != null && proxyType == "shx") 
			{
				url = rootURL = _proxyUrl;
				
				//For .NET use only with twitterproxy.ashx
				//endpoint.ashx is not compatible, at this time, with the proxy.ashx that is
				//included with the FlexViewer.
				//TO-DO: make the proxy code more consistent across php/jsp/ashx
				return super.send({uri:tempUrl2});
			}
			
			
			//This is for use with twitterproxy.php
            if(_proxyUrl != null && proxyType == "php") 
            {
                url = rootURL = _proxyUrl;
                                           
                //For PHP use only with endpoint.php
                //TO-DO: make the proxy code more consistent across php/jsp/ashx
                return super.send({uri:tempUrl2});
            }
			
			//This is for use with twitterproxy.jsp
			else if(_proxyUrl != null && proxyType == "jsp")
			{
				url = _proxyUrl + "?" + url;                
				
				return super.send({
					uri:tempUrl2
				}); 				
			}			
            
            return null;
        }
      
        public function set proxyUrl(proxyUrl:String):void
        {
            _proxyUrl = proxyUrl;
        }
        
        public function set userName(userName:String):void
        {
            _userName = userName;
        }
        
        public function set passWord(passWord:String):void
        {
            _passWord = passWord;
        }
        
        public function get passWord():String
        {
            return _passWord;
        }
        
        public function get userName():String
        {
            return _userName;
        }      
    }
}
