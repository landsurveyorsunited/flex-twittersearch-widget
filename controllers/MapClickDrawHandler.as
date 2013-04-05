package widgets.twittersearch.controllers
{
	import com.esri.ags.Map;
	import com.esri.ags.events.MapMouseEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import mx.controls.ComboBox;
	import mx.rpc.http.HTTPService;
	
	import widgets.twittersearch.model.DrawCircle;

	public class MapClickDrawHandler
	{
		private var _map:Map;
		private var _httpService:HTTPService;
		private var _tdm:TweetDataManager;
		private var _graphicsLayerCircle:GraphicsLayer;
		private var _simpleFillSymbol1:SimpleFillSymbol;
		private var _simpleLineSymbol1:SimpleLineSymbol;
		private var _resultsNumber:String;
		private var _drawCircle:DrawCircle;
		
		/**
		 * Class that handles all the tasks with related to clicking on the map and retrieving tweets.
		 */
		public function MapClickDrawHandler(event:MapMouseEvent,map:Map,
			httpService:HTTPService,
			singleton:TweetDataManager,
			drawRadius:mx.controls.ComboBox,
			graphicsLayerCircle:GraphicsLayer,
			simpleFillSymbol:SimpleFillSymbol,
			simpleLineSymbol:SimpleLineSymbol,
			resultsNumber:String)
		{
			_map = map;
			_httpService = httpService;
			_tdm = singleton;
			_graphicsLayerCircle = graphicsLayerCircle;
			_simpleFillSymbol1 = simpleFillSymbol;
			_simpleLineSymbol1 = simpleLineSymbol;
			_resultsNumber = resultsNumber;
			
			var mapPoint:MapPoint = event.mapPoint;
			var lat:String = null;
			var lon:String = null;                               		
			
			if(mapPoint != null)
			{
				//Draw circle using ArcGIS Online Tiling scheme 
				var radius:Number = parseFloat(drawRadius.text);
				_drawCircle = new DrawCircle(
					mapPoint,
					_graphicsLayerCircle,
					radius,
					_map,
					_simpleFillSymbol1,
					_simpleLineSymbol1);
			}							
			
			var tempMP:MapPoint = WebMercatorUtil.webMercatorToGeographic(mapPoint) as MapPoint;
			
			//var twitterURL:String = _TWITTER_SEARCH_URL + "?geocode=" + lat + "%2C" + lon + "%2C" + circleTool.radiusInMiles + "mi" + "&rpp=" + _resultsNumber;
			//var twitterURL:String = _tdm.twitterSearchURL + "?geocode=" + tempMP.y + "%2C" + tempMP.x + "%2C" + radius + "mi" + "&rpp=" + _resultsNumber;

			//_httpService.url = twitterURL;
			//_httpService.send();				
		}
		
		public function get circle():Polygon
		{
			return _drawCircle.geometry;
		}

	}
}