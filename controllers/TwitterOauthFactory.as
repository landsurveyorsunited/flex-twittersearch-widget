package widgets.twittersearch.controllers
{	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import widgets.twittersearch.events.TwitterOauthEvent;

	/**
	 * Handles OAuth-based Twitter requests. Requires the PHP OAuth proxy included with download.
	 * Added @ v4.0.
	 */
	public class TwitterOauthFactory extends EventDispatcher
	{
		private var PROXY_SERVER:String = null;
		private var IMAGE_PROXY:String = null;
		
		public function TwitterOauthFactory(proxyServer:String)
		{
			PROXY_SERVER = proxyServer;
		}
		
		public function loginOauthRequest():void
		{
			externalInterfaceLogin();
		}
		
		public function logoutOauth():void
		{
			var reqURI:String = PROXY_SERVER + "?d="; 
			
			var req:URLRequest = new URLRequest( reqURI );
			req.method = "GET";
			
			var httpService:HTTPService = new HTTPService;
			httpService.url = reqURI;
			httpService.requestTimeout = 30;                
			httpService.useProxy = false;
			httpService.method = "GET";   
			httpService.resultFormat = "text"; //IMPORTANT: you must use the 'text' value to return the raw payload
			httpService.addEventListener( "result", loggedOutHandler );
			httpService.addEventListener("fault",loggedOutFaultHandler);
			httpService.showBusyCursor = true;
			httpService.send();
		}
		
		private function loggedOutHandler(event:ResultEvent):void
		{
			dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.LOGOUT_SUCCESS,event.result));	
		}
		
		private function loggedOutFaultHandler(event:TwitterOauthEvent):void
		{
			dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.LOGOUT_FAILED,event.data));	
		}
		
		public function validateCredentials():void
		{
			var reqURI:String = PROXY_SERVER + "?validate="; 
			
			var req:URLRequest = new URLRequest( reqURI );
			req.method = "GET";
			
			var httpService:HTTPService = new HTTPService;
			httpService.url = reqURI;
			httpService.requestTimeout = 30;                
			httpService.useProxy = false;
			httpService.method = "GET";   
			httpService.resultFormat = "text"; //IMPORTANT: you must use the 'text' value to return the raw payload
			httpService.addEventListener( "result", oauthTwitterValidationHandler );
			httpService.addEventListener("fault",oauthTwitterValidationFaultHandler);
			httpService.showBusyCursor = true;
			httpService.send();
		}
		
		private function oauthTwitterValidationHandler(event:ResultEvent):void
		{  
			dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.VERIFIED,event.result));
		}
		
		private function oauthTwitterValidationFaultHandler(event:FaultEvent):void
		{
			var rawData:String = String(event.message);		
			dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.NOTVERIFIED,event.message));	
		}
		
		private function externalInterfaceLogin():void
		{
			const reqURI:String = PROXY_SERVER + "sign_in.php"; 
			var req:URLRequest = new URLRequest( reqURI );
			var jsConfirm:String = "getTokens";	
			
			if(ExternalInterface.available)
			{ 
				/*
				There's a three step process to making the retrieval of the tokens work. The idea is to eliminate the need to store
				the tokens as cookies in the browser which is the most insecure method you can use. The tokens are still being transmitted
				openly via HTTP, so to be most secure you should use HTTPS for all your transactions that require authentication.
				1) Set an ActionScript callback handler through ExternalInteface called getTokens.
				2) Create an ActionScript function that registers getTokens with Flash Player via External.Interface.call
				3) Call the getTokens function from callback.php using window.opener.getTokens()
				
				In confirm.php you must have the following code.
				
				echo "if(window.opener && window.opener.getTokens){";
				echo "window.opener.getTokens(\"".$token->oauth_token.",".$token->oauth_token_secret."\");}";     
				//You can also have the app automatically close the window via self.close, as shown below
				//echo "window.opener.getTokens(\"".$token->oauth_token.",".$token->oauth_token_secret."\");self.close();}";
				echo "</script>";							
				*/				
				
				
				ExternalInterface.addCallback(jsConfirm,function processTokens(value:String):void{
					var results:Array = value.split(",");
					trace("Token Value: " + value);
					if(results[0] != "" && results[1] != "")
					{
						dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.LOGIN_SUCCESS,value));
					}
					else
					{
						dispatchEvent(new TwitterOauthEvent(TwitterOauthEvent.LOGIN_FAILED,value));
					}
				});
				
				var id:String = ExternalInterface.objectID;
				var name:String = "confirm";
				var props:String = "width=800,height=600";								
				var js:String = ''
					+ 'if(!window.' + jsConfirm + '){'
					+ '    window.' + jsConfirm + ' = function(tokens){'
					+ '        var flash = document.getElementById("' + id + '");'
					+ '        flash.' + jsConfirm + '(tokens);'
					+ '    }'
					+ '};'
					+ 'window.open("' + reqURI + '", "' + name + '", "' + props + '");'
				
				ExternalInterface.call("function(){" + js + "}");
				
				trace("TwitterSearchWidget: OAuth login started");				
				
			}
				
			else
			{
				Alert.show("Access to External Interface is not available, check Flash Player security settings","Security Alert");
			}					
			
		}
	}
}