package widgets.twittersearch.model
{
	public class MercatorConverter
	{
		import com.esri.ags.geometry.MapPoint;
		import com.esri.ags.utils.WebMercatorUtil;
		
		import flash.geom.Point;
		
		public function MercatorConverter()
		{
			
		}
		
		//Automatically converts from WGS84 -> Mercator or vice-versa
		public function autoConvert(mapPoint:MapPoint):MapPoint
		{
			//Determine how to proceed based on spatialreference
			var test:String = mapPoint.spatialReference.wkid.toString();
			
			switch(test)
			{	
				case "102100" :
					MercatorToGeographic(mapPoint);
					break;
				case "4326" :
					WGS84ToMercator(mapPoint);
					break; 
			}			
			
			function MercatorToGeographic(mapPoint:MapPoint):MapPoint
			{
				return WebMercatorUtil.webMercatorToGeographic(mapPoint) as MapPoint;
			}
			
			function WGS84ToMercator(mapPoint:MapPoint):MapPoint
			{
				return WebMercatorUtil.geographicToWebMercator(mapPoint) as MapPoint;
			}
			
			return null;

		}
		
		//Bool = true means convert from WGS84 -> Mercator.
		public function convert(x:Number, y:Number, bool:Boolean):MapPoint
		{			
			var _pointObject:MapPoint = new MapPoint();
			_pointObject.x = x;
			_pointObject.y = y;
			
			if(bool)
			{
				_pointObject = WebMercatorUtil.geographicToWebMercator(_pointObject) as MapPoint;
			}
			else
			{
				_pointObject = WebMercatorUtil.webMercatorToGeographic(_pointObject) as MapPoint;
			}
			
			return _pointObject;
		}
		
		public function convertToPoint(x:Number, y:Number, bool:Boolean):Point
		{			
			var _pointObject:MapPoint = new MapPoint();
			_pointObject.x = x;
			_pointObject.y = y;
			
			if(bool)
			{
				_pointObject = WebMercatorUtil.geographicToWebMercator(_pointObject) as MapPoint;
			}
			else
			{
				_pointObject = WebMercatorUtil.webMercatorToGeographic(_pointObject) as MapPoint;
			}			
			
			return new Point(_pointObject.x, _pointObject.y);
		}
		
		
	}
}