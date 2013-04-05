package widgets.twittersearch.controllers
{
    import flash.events.Event;
    
    import mx.controls.Image;
    import mx.core.UIComponent;
    
    public class MouseImageHandler
    {
        public function MouseImageHandler(event:Event,visibility:Boolean)
        {
            var obj:UIComponent = event.currentTarget as UIComponent; 
            obj.initialize(); 
            var img:Image = obj.getChildAt(1) as Image;
            if(visibility)
            {
                img.visible = true;
            } 
            else
            {
                img.visible = false;
            }                                                                                                            
        }
    }
}