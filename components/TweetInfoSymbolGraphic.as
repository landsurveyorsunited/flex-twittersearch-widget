package widgets.twittersearch.components
{
    import com.esri.ags.Graphic;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.symbols.Symbol;
    
    public class TweetInfoSymbolGraphic extends Graphic
    {
        public var twitterID:String;
        
        public function TweetInfoSymbolGraphic(geometry:Geometry = null, symbol:Symbol = null)
        {
            super(geometry, symbol);
            this.twitterID = twitterID;                                    
        }

    }
}