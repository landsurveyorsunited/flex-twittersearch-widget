package widgets.twittersearch.components
{
    import com.esri.ags.geometry.MapPoint;
    
    import flash.geom.Point;
    
    import mx.collections.ArrayCollection;

    public class Cube extends MapPoint
    {
        public var count:int;
        public var point:Point;
        public var attributes:Object;
        public var tweets:ArrayCollection = new ArrayCollection();

        public function Cube(x:Number, y:Number, point:Point, attributes:Object)
        {
            super(x, y);
            this.point = point;
            this.count = 1;
            this.attributes = attributes; //store twitter attributes info in Graphic associated w/ Cube
            this.tweets = tweets;         //store info about all tweets at this location  
        }

    }
}