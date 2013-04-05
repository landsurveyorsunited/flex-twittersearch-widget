package widgets.twittersearch.components
{
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbols.Symbol;
    
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class CompoSymbol extends Symbol
    {
        public var cubeSize:int = 10;        
        private var m_textFormat:TextFormat;
                
        public function CompoSymbol()
        {
            m_textFormat = new TextFormat();
            m_textFormat.align = TextFormatAlign.CENTER;
            m_textFormat.color = 0xFFFFFF;
            m_textFormat.font = "Arial";
            m_textFormat.size = 18;
            m_textFormat.bold = true;
            m_textFormat.leftMargin = 1;
            m_textFormat.rightMargin = 1;            
        }
        
        override public function clear(sprite:Sprite):void
        {
            sprite.graphics.clear();
        }        
        
        override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
        {
            
            if(geometry is Cube)
            {
                const cube:Cube = Cube(geometry);
                if(cube.count < 10) cubeSize = 10;
                if(cube.count >= 10 && cube.count < 100) cubeSize = 15;
                if(cube.count == 100) cubeSize = 20;
                var X:Number = toScreenX(map, cube.x);
                var Y:Number = toScreenY(map, cube.y);
                
                sprite.graphics.beginFill(0xFF3366,0.5);
                sprite.graphics.drawCircle( X , Y ,cubeSize);
                sprite.graphics.endFill();
                
                const textFormat:TextFormat = new TextFormat();
                textFormat.align = TextFormatAlign.CENTER;
                
                const textField:TextField = sprite.getChildByName("textField") as TextField;
                textField.defaultTextFormat = textFormat;
                textField.text = cube.count.toString();
                textField.setTextFormat(m_textFormat);
                textField.width = cubeSize * 2;
                
                if(cube.count >= 10)
                {
                    textField.x = X - cubeSize + 2;
                    textField.y = Y - cubeSize + 2;
                }
                if(cube.count < 10)
                {
                    textField.x = X - cubeSize + 2;
                    textField.y = Y - cubeSize - 2;
                }                               
            }   
        }
    }
}