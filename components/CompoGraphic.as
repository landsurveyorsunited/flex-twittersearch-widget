package widgets.twittersearch.components
{
    import com.esri.ags.Graphic;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.symbols.Symbol;
    
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    
    import mx.collections.ArrayCollection;
    
    public class CompoGraphic extends Graphic
    {                
        public var tweets:ArrayCollection;
        
        public function CompoGraphic(geometry:Geometry = null, symbol:Symbol = null)
        {
            super(geometry, symbol);
            //autoMoveToTop = false;
            checkForMouseListeners = false;
            this.tweets = tweets;
        }

        override protected function createChildren():void
        {
            super.createChildren();
            const textField:TextField = new TextField();
            textField.name = "textField";
            textField.mouseEnabled = false;
            textField.mouseWheelEnabled = false;
            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.selectable = false;
            textField.autoSize = TextFieldAutoSize.CENTER;
            addChild(textField);
        }

    }}