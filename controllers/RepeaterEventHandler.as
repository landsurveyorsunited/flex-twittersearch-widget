package widgets.twittersearch.controllers
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.InfoSymbol;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	/**
	 * Class for handling mouse events in a repeater grid.
	 */	
	public class RepeaterEventHandler
	{
		private var _gL1:GraphicsLayer;
		private var _lastInfoSymbolGraphic:Graphic;
		private var _infoSymbol1:InfoSymbol;
		private var _graphicsArray:ArrayCollection;
				
		/**
		 * Class for handling mouse events in a repeater grid.
		 * 
		 * @param event A <code>MouseEvent</code> from a repeater component.
		 * @param graphicLayer The primary graphics layers for this widget
		 * @param infoSymbolGraphic The <code>Graphic</code> that is used to display information on the map.
		 * @param infoSymbol The <code>InfoSymbol</code> that contains the <code>infoSymbolGraphic</code>.
		 * @param graphicsArray An <code>ArrayCollection</code> that contains all the tweets that are to be displayed on the map.
		 */
		public function RepeaterEventHandler(event:MouseEvent,graphicsLayer:GraphicsLayer,infoSymbolGraphic:Graphic,infoSymbol:InfoSymbol,graphicsArray:ArrayCollection)
		{
			_gL1 = graphicsLayer;
			_lastInfoSymbolGraphic = infoSymbolGraphic;
			_infoSymbol1 = infoSymbol;			
			_graphicsArray = graphicsArray;
			
			var obj:Object = event.currentTarget.getRepeaterItem();
			event.currentTarget.setStyle("backgroundAlpha","0.6");
			
			try
			{   
				var tempGraphic:Graphic = new Graphic();
				tempGraphic.symbol = _infoSymbol1;
				var tweetObj:Object = findInGraphic(obj,false);
				var tweetLocation:MapPoint = new MapPoint(tweetObj.geomPt.x,tweetObj.geomPt.y); 
				tempGraphic.geometry = tweetLocation;
				var geometry:String = "";
				
				//Assign an extra tag to the attributes to make the infoWindow
				//graphic have a unique ID that's seperate from the the pushpin.
				//That way we can open/close the infoWindow without deleting
				//the pushpin graphic.
				//NOTE: have to use ObjectProxy to avoid IEventDispatcher Warnings
				tempGraphic.attributes =  new ObjectProxy({
					name: tweetObj.attributes.name,
					twitterID: tweetObj.attributes.twitterID + "<temp>",
					imageURL: tweetObj.attributes.imageURL,
					title: tweetObj.attributes.title,
					geometry: tweetObj.attributes.geometry
				});
				
				_lastInfoSymbolGraphic = tempGraphic; 
				_gL1.add(tempGraphic);
				
			}
			catch(err:Error)
			{
				trace("onRollOverEventHandler: " + err.getStackTrace());
			}          			
		}
		
		/**
		 * This is the <code>Graphic</code> that is displayed when you hover over a repeater grid row.
		 */
		public function get infoSymbolGraphic():Graphic
		{
			return _lastInfoSymbolGraphic;	
		}
		
		private function findInGraphic(obj:Object,bool:Boolean):Object
		{                
			for each(var graphic:Object in _graphicsArray) 
			{
				if(graphic.attributes.twitterID && obj.twitterID)
				{                
					if(bool == false)
					{
						if (graphic.attributes.twitterID === obj.twitterID)
						{   
							return graphic; 
						}
					}
					else
					{
						if (graphic.attributes.twitterID == (obj.twitterID + "<temp>"))
						{
							return graphic;
						}                                
					}
				}                       
			}
			return null;                
		} 		
	}
}