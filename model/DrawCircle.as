package widgets.twittersearch.model
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.utils.WebMercatorUtil;
	
	/**
	 * This class shows how to draw a circle around a point on the map.
	 * It also returns a geometry property for use as input into a QueryTask.
	 */			
	public class DrawCircle
	{
		private var _circle:Polygon;
		private const _nodes:Number = 100; //number of nodes drawn in the circle
		
		/**
		 * Draws a circle on the given map. 
		 */
		public function DrawCircle(
			centerPt:MapPoint, 
			graphicsLayer:GraphicsLayer,
			drawRadius:int,
			map:Map,
			simpleFillSymbol1:SimpleFillSymbol,
			simpleLineSymbol1:SimpleLineSymbol)
		{
			graphicsLayer.clear();			
			
			//Determine how to proceed based on spatialreference
			var test:String = map.spatialReference.wkid.toString();

			switch(test)
			{	
				case "102100" :
					MERCATOR();
					break;
				case "4326" :
					WGS84();
					break; 
			}
			
			function MERCATOR():void
			{
				var new_centerPt:MapPoint = WebMercatorUtil.webMercatorToGeographic(centerPt) as MapPoint;				
				var R_MI:Number = drawRadius/6371; //angular distance on earth's surface																	
		
				//Create a Graphic using the polygon as the geometry
				var circle:Graphic = createMercatorBasedCircle(drawRadius,new_centerPt,simpleFillSymbol1);
				//Calculate radius in map units
				//var m_radius:Number = calculateRadius(new_centerPt,user_radius,map).radiusDegrees;				
				
				//var circle:Graphic = createCircleGraphic(_nodes,m_radius,new_centerPt,map,simpleFillSymbol1);
				//circle.autoMoveToTop = false;
				
				//Add circle Graphic to map
				graphicsLayer.add(circle);							
			}
			
			function WGS84():void
			{	
				//Calculate radius in map units
				var m_radius:Number = calculateRadius(centerPt,drawRadius,map).radiusDegrees;																	
				
				//Create a Graphic using the polygon as the geometry
				var circle:Graphic = createCircleGraphic(_nodes,m_radius,centerPt,map,simpleFillSymbol1);
				//circle.autoMoveToTop = false;
							
				//Add circle Graphic to map
				graphicsLayer.add(circle);							
			}
			
		}
		
		/**
		 * Expose a geometry property that can be used as input into QueryTask
		 */
		public function get geometry():Polygon
		{
			if(_circle != null)
			{
				return _circle;	
			}
			
			return null;
		}
		 
		/**
		 * Create a circle for Mercator maps such as Bing and Google 
		 */
		public function createMercatorBasedCircle(fixedRadius:Number,center:MapPoint,simpleFillSymbol:SimpleFillSymbol):Graphic
		{	
			var lon1:Number = degToRad(center.x);  
			var lat1:Number = degToRad(center.y);  
			var R_KM:Number = 6371; //radius km
			var R_MI:Number = 3963;
			//var d:Number = fixedRadius/R_KM;  	//angular distance on earth's surface
			var d:Number = fixedRadius/R_MI;  	//angular distance on earth's surface

			var nodes:Number = 100; //number of nodes in circle
			var step:Number = 360/nodes||10;
			var n:Number = 0;
			var arrayOfPoints:Array = new Array();	
			var m_circleGeometry:Polygon = new Polygon(null,new SpatialReference(102100));				
			
			//for(var x:int = 0; x <= 360; Math.round(x+=step))
			for(var x:int = 0; x <= 360; x++)
			{	
				var z:int = Math.round(n+=step);
				var bearing:Number = degToRad(x);
				
				var lat2:Number = Math.asin(
					Math.sin(lat1) * Math.cos(d) +
					Math.cos(lat1) * Math.sin(d) * Math.cos(bearing)
				);           
				
				var lon2:Number = lon1 + Math.atan2(
					Math.sin(bearing) * Math.sin(d) * Math.cos(lat1),
					Math.cos(d) - Math.sin(lat1) * Math.sin(lat2) 
				);				
								
				arrayOfPoints[x] = WebMercatorUtil.geographicToWebMercator( new MapPoint(radToDeg(lon2),radToDeg(lat2)));
			
			}						

			//add the first point at the end of the array to close the polygon
			arrayOfPoints.push(arrayOfPoints[0]);    
			
			//Add the array of points as a ring to the circle polygon   
			m_circleGeometry.addRing(arrayOfPoints);
			
			//Create a return value for the Polygon as input into a QueryTask			
			_circle = m_circleGeometry;			
			
			//Create a new Graphic using the point array
			var circle:Graphic = new Graphic(m_circleGeometry,simpleFillSymbol);			
			
			return circle			
			
		}						
		
		/**
		 * Calculate radius in map units
		 */
		public function calculateRadius(centerPt:MapPoint,radius:Number,map:Map):Object
		{
			const mapPoint:MapPoint = pointFromBearingAndDistance(radius,centerPt,map);
			
			//find the horizontal offset from the center in map units
			const dx : Number = mapPoint.x - centerPt.x; 
			
			//find the vertical offset from the center in map units
			const dy : Number = mapPoint.y - centerPt.y;
			
			//convert radius in degrees to miles
			const rm : Number = degreesToMiles(centerPt.x, mapPoint.x, centerPt.y, mapPoint.y);
			
			const obj:Object = new Object();
			obj.radiusMiles = rm;
			obj.radiusDegrees = Math.sqrt( dx * dx + dy * dy ); //Pythagoras 
			
			return obj; 				
		}
		
		/**
		 * Convert degrees to miles | this function is courtesy of Gregory Gunther
		 */
		public static function degreesToMiles(x1:Number, x2:Number, y1:Number, y2:Number):Number 
		{				
			//Convert Everything to radians
			var x1Radians:Number = x1 * Math.PI/180;
			var x2Radians:Number = x2 * Math.PI/180;
			var y1Radians:Number = y1 * Math.PI/180
			var y2Radians:Number = y2 * Math.PI/180
			return 3963.0 * Math.acos(
				Math.sin(y1Radians) *  
				Math.sin(y2Radians) + 
				Math.cos(y1Radians) * 
				Math.cos(y2Radians) * 
				Math.cos(x2Radians - x1Radians)
			);	
		} 			
		
		/**
		 * For use with WGS84 to calculate a new point given a bearing and distance.
		 * Allows you to create a new point that determines the radius of a circle.
		 */
		public function pointFromBearingAndDistance(fixedRadius:Number,center:MapPoint,map:Map):MapPoint
		{	
			var lon1:Number = degToRad(center.x);  
			var lat1:Number = degToRad(center.y);  
			var R_KM:Number = 6371; //radius km
			var R_MI:Number = 3963;
			var bearing:Number = degToRad(270); //use 270 or 90 for proper projection
			var d:Number = fixedRadius/R_MI; 	//angular distance on earth's surface
			
			var lat2:Number = Math.asin(
				Math.sin(lat1) * Math.cos(d) +
				Math.cos(lat1) * Math.sin(d) * Math.cos(bearing)
			);           
			
			var lon2:Number = lon1 + Math.atan2(
				Math.sin(bearing) * Math.sin(d) * Math.cos(lat1),
				Math.cos(d) - Math.sin(lat1) * Math.sin(lat2)
			);
			
			lon2 = (lon2 + 3 * Math.PI) % (2 * Math.PI) - Math.PI; //normalize
			
			if(isNaN(lat2) || isNaN(lon2)) 
			{
				return null;
			}
			
			return new MapPoint(radToDeg(lon2),radToDeg(lat2), map.spatialReference);
		}			
		
		/**
		 * Convert radians to degrees
		 */
		public static function radToDeg(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Convert degrees to radians
		 */
		public static function degToRad(degrees:Number):Number 
		{
			
			return degrees * Math.PI / 180;
		}			
		
		/**
		 * Create the circle polygon
		 */
		public function createCircleGraphic(
			numPts:Number,
			radius:Number,
			centerPt:MapPoint,
			map:Map,
			simpleFillSymbol:SimpleFillSymbol):Graphic 
		{                       

			var m_circleGeometry:Polygon = new Polygon(null,map.spatialReference);				
						
			var cosinus:Number;
			var sinus:Number;
			var x:Number;
			var y:Number;
			var arrayOfPoints:Array = new Array();
			
			//create the array of points which will compose the circle
			for (var i:int = 0; i < numPts; i++) 
			{
				sinus = Math.sin((Math.PI*2.0)*(i/numPts));
				cosinus = Math.cos((Math.PI*2.0)*(i/numPts));
				x = centerPt.x + radius*cosinus;
				y = centerPt.y + radius*sinus;  
				arrayOfPoints[i] = new MapPoint(x, y);            	        
			}
			
			//add the first point at the end of the array to close the polygon
			arrayOfPoints.push(arrayOfPoints[0]);    
			
			//Add the array of points as a ring to the circle polygon   
			m_circleGeometry.addRing(arrayOfPoints);
			
			//Create a return value for the Polygon as input into a QueryTask			
			_circle = m_circleGeometry;			
			
			//Create a new Graphic using the point array
			var circle:Graphic = new Graphic(m_circleGeometry,simpleFillSymbol);			
			
			return circle;			
		} 					
	}
}