package widgets.twittersearch.controllers
{
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Extent;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.layers.GraphicsLayer;
    import com.esri.ags.symbols.InfoSymbol;
    import com.esri.ags.symbols.Symbol;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.utils.ObjectProxy;
    
    import widgets.twittersearch.components.CompoGraphic;
    import widgets.twittersearch.components.CompoSymbol;
    import widgets.twittersearch.components.Cube;
    import widgets.twittersearch.components.TweetInfoSymbolGraphic;
    import widgets.twittersearch.model.LatLonProcessor;
    import widgets.twittersearch.model.MercatorConverter;
    
    //This purpose of this class is to provide clustering
    //It's derived from the work of Mansour Raad, with one signicant difference.
    //This class is intended for clustering where there may be multiple points clustered
    //at the closest in zoom-level. In its current configuration, it may exhibit
    //unexpected behavior when you are at maximum zoom levels, where some of the 
    //cluster icons may overlap. Not a serious problem but something to be aware of.
    //http://thunderheadxpler.blogspot.com/2009/05/map-points-cubic-clustering.html
	
	//NOTE: This assumes that the point is in Mercator. For details see checkValues() method
    
    public class PointManager
    {
        public function PointManager()
        {            
			_mercatorConverter = new MercatorConverter();
        }
        
        private var _symbol:Symbol;
        private var _infoSymbol:InfoSymbol;
        private var _infoSymbol2:InfoSymbol;
        private var _graphicsLayer:GraphicsLayer;           
        private var m_map:Map; 
        private var m_sink:ArrayCollection;
        private var _graphicsArray:ArrayCollection; //used for the datagrid repeater when user hovers over a row item
        private var _clickLocation:Object;       
		private var _mercatorConverter:MercatorConverter;
        [Bindable]
        private var _lastInfoSymbolGraphic:TweetInfoSymbolGraphic = new TweetInfoSymbolGraphic();          
        
		public function set map(value:Map):void
        {
            m_map = value;
        }
        
        [Bindable]
        public function get map():Map
        {
            return m_map;
        }                
        
        public function get graphicsArray():ArrayCollection
        {
            return _graphicsArray;
        }
       
        public function set clickLocation(value:Object):void
        {
            _clickLocation = value;
        }
        
        public function set symbol(value:Symbol):void
        {
            _symbol = value;
        }
        
        public function set graphicsLayer(value:GraphicsLayer):void
        {
            _graphicsLayer = value;
        }
        
        public function set infoSymbol(value:InfoSymbol):void
        {
            _infoSymbol = value;
        }
        
        public function set infoSymbol2(value:InfoSymbol):void
        {
            _infoSymbol2 = value;
        }
        
        public function set sink(value:ArrayCollection):void
        {
            if (value !== m_sink)
            {
                m_sink = value;
            }
        }        
        
        public function updateManager():ArrayCollection
        {
            //This provides the input for a GraphicsLayer graphicProvider
            var source:ArrayCollection = new ArrayCollection();
            
            var m_extent:Extent;
            var m_filter:Extent;   
            var m_cubeSize:int = 70; // Pixels                 
            
            _graphicsArray = new ArrayCollection();                        
          
            if (m_map === null)
            {                
                return null;
            }
            if (m_extent === null)
            {
                m_extent = m_map.extent;
                m_filter = m_extent.expand(3.0);
            }
            const xmin:Number = m_extent.xmin;
            const ymin:Number = m_extent.ymin;
            const width:Number = m_extent.width;
            const height:Number = m_extent.height;
            const cellWidth:Number = width * m_cubeSize / map.width;
            const cellHeight:Number = height * m_cubeSize / map.height;
            const dict:Dictionary = new Dictionary();   //stores Cubes

            //for each (var point:Point in m_sink)
            for each(var obj:Object in m_sink)
            {                       
                //var point:Point = obj.geomPoint;
                var point:Point = checkValues(obj);
                
                if (m_filter.containsXY(point.x, point.y) === false)
                {
                    //continue;
                }
                
                var cx:int = Math.floor((point.x - xmin) / cellWidth);
                var cy:int = Math.floor((point.y - ymin) / cellHeight);                      
                var key:int = (cx << 16) | cy;                                

                var cube1:Cube = dict[key] as Cube;
                
                if(cube1)
                { 
                    cube1.count++;
                    var ac1:ArrayCollection = cube1.tweets;
                    ac1.addItem(obj);
                    cube1.tweets = ac1;
                    _graphicsArray.addItem({
                        attributes:obj,
                        geomPt:point
                    });                                          
                }   
                else
                {   
                    dict[key] = new Cube(point.x,point.y,point,obj);
                    //Add value to the dictionary at location zero [0]
                    var ac2: ArrayCollection = new ArrayCollection();
                    ac2.addItem(obj);                    
                    dict[key].tweets = ac2;
                    _graphicsArray.addItem({
                        attributes:obj,
                        geomPt:point
                    });                     
                }                                         
            }

            source.removeAll();  
                    
            //I've modified this from Mansour's version. This now handles the condition
            //were multiple points can still remain clustered at the closest zoom level.
            //And, points clusters are centered.
            for each (var cube2:Cube in dict)
            {
                if (cube2.count == 1)
                {   
                    var mapPoint:MapPoint = new MapPoint(cube2.point.x, cube2.point.y);
                    var cubeGraphic1:TweetInfoSymbolGraphic = new TweetInfoSymbolGraphic(mapPoint);
                    cubeGraphic1.attributes =cube2.attributes;
                    cubeGraphic1.symbol = _symbol;
                    //cubeGraphic1.toolTip = cube2.point.y.toFixed(6) + "\n" + cube2.point.x.toFixed(6);

                    //assign listeners for controlling events relating to individual graphics
                    cubeGraphic1.addEventListener(MouseEvent.MOUSE_OVER,graphicMouseOverEventHandler);
                    cubeGraphic1.addEventListener(MouseEvent.MOUSE_OUT,removeInfoSymbol);                  

                    source.addItem(cubeGraphic1);
                }
                else
                {
                    cube2.attributes.count = cube2.count;
                    var cubeGraphic2:CompoGraphic = new CompoGraphic(cube2, null);
                    cubeGraphic2.attributes = cube2.attributes;
                    var mapPoint2:MapPoint = new MapPoint(cube2.point.x, cube2.point.y);
                    cubeGraphic2.tweets = cube2.tweets;
                    var sym:CompoSymbol = new CompoSymbol();
                    cubeGraphic2.symbol = sym;
                    cubeGraphic2.toolTip = "Click once on marker to keep popup open."
                    //cubeGraphic2.autoMoveToTop = false;                    
                                          
                    //assign listeners for controlling events relating to individual graphics
                    cubeGraphic2.addEventListener(MouseEvent.MOUSE_OVER,complexGraphicMouseOverEventHandler);
                    cubeGraphic2.addEventListener(MouseEvent.MOUSE_OUT,removeInfoSymbol); 
                    cubeGraphic2.addEventListener(MouseEvent.CLICK,complexGraphicMouseOverEventHandler);    

                    source.addItem(cubeGraphic2);                                              
                }
            }            
            
            return source;
        }
                
        public function graphicMouseOverEventHandler(event:MouseEvent):void
        {
            try
            {
                var eventObj:Object = event.currentTarget.attributes;
                var tempGraphic:TweetInfoSymbolGraphic = new TweetInfoSymbolGraphic();                    
                //NOTE: _infoSymbol : <twitcomp:TweetsInfoSymbol tweetObject="{data}" />
                
				tempGraphic.symbol = _infoSymbol;           
                tempGraphic.twitterID = eventObj.twitterID; //used to removed Graphic
                var tweetLocation:MapPoint = event.currentTarget.geometry;
                tempGraphic.geometry = tweetLocation;
                //tempGraphic.autoMoveToTop = true;                     
                                
                //NOTE: have to use ObjectProxy to avoid IEventDispatcher Warnings                    
                tempGraphic.attributes = new ObjectProxy({
                    name: eventObj.name,
                    twitterID: eventObj.twitterID + "<temp>",
                    imageURL: eventObj.imageURL,
                    title: eventObj.title,
                    geometry: eventObj.geometry
                });
                
                _lastInfoSymbolGraphic = tempGraphic;
                _graphicsLayer.add(tempGraphic);                               
            }
            catch(err:Error)
            {
                //There may be null attributes
                trace("graphicMouseOverEventHandler: " + err.getStackTrace());
            }                  
        }                   

        protected function complexGraphicMouseOverEventHandler(event:MouseEvent):void
        {
            try
            {
                var eventObj:Object = event.currentTarget.attributes;
                var tweets:ArrayCollection = event.currentTarget.tweets;
                var tempGraphic:TweetInfoSymbolGraphic = new TweetInfoSymbolGraphic();                    
                //For reference:
                //This graphic symbol is using: <twitcomp:TweetsInfoSymbolComplexVBox tweetObject="{data}" />
                tempGraphic.symbol = _infoSymbol2;                 
                tempGraphic.twitterID = eventObj.twitterID  + "<temp>"; //used to remove Graphic
                var tweetLocation:MapPoint = event.currentTarget.geometry;
                tempGraphic.geometry = tweetLocation;
                //tempGraphic.autoMoveToTop = true;                             
                tempGraphic.attributes = tweets;

                _lastInfoSymbolGraphic = tempGraphic;                
                _graphicsLayer.add(tempGraphic); 
                tempGraphic.addEventListener(MouseEvent.ROLL_OUT,mouseOutHandler);                

                //close InfoSymbol (not the Graphic!) when mouse is removed 
                function mouseOutHandler(event:MouseEvent):void
                {   
                    _graphicsLayer.remove(tempGraphic);
                }                            
            }
            catch(err:Error)
            {
                //There may be null attributes
                trace("complexGraphicMouseOverEventHandler: " + err.getStackTrace());
            }                              
        }

        protected function removeInfoSymbol(event:MouseEvent):void
        {
            _graphicsLayer.remove(_lastInfoSymbolGraphic);
            _lastInfoSymbolGraphic = null;
        }  
        
        /**
		 * IMPORTANT: Be careful with projections here. This sets the point location from the tweet object properies.
		 */
		protected function checkValues(obj:Object):Point
        {
            var tempPt:Point = new Point();
            var testResults:LatLonProcessor = new LatLonProcessor();
			var lon:Number = 0;
			var lat:Number = 0;
			var pt:Point;
            
			if(obj.geometry != null)
			{
				var locationArr:Array = obj.geometry.split(',');
				pt = new Point(locationArr[1],locationArr[0]);
				
				return _mercatorConverter.convertToPoint(pt.x,pt.y,true);					
			}
			
            //Check for special values in the tweet location fields
			else if(testResults.detectTagInfo(obj) == true)
            {   
                lon = parseFloat(testResults.lon);
                lat = parseFloat(testResults.lat);
                pt = new Point(lon,lat);

                tempPt = pt;

				return _mercatorConverter.convertToPoint(tempPt.x,tempPt.y,true);				
            } 
            
            //If no special values are detected then use the clickLocation
            //to set the lat/lon for the graphic.
			//This is the section of code where tweets with no location set
			//will be dumped and stacked on the middle of the search location circle.
            else
            {                           
                lon = parseFloat(_clickLocation.lon);
                lat = parseFloat(_clickLocation.lat);
                pt = new Point(lon,lat);                                        

                tempPt = pt;
            }
            
			//var mc:MercatorConverter = new MercatorConverter();	
			
			//return mc.convertToPoint(tempPt.x,tempPt.y,true);
			
			return tempPt;
        }          
                     
    }
}