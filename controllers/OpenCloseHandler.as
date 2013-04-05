package widgets.twittersearch.controllers
{
    import flash.display.BlendMode;
    
    import mx.containers.VBox;
    import mx.events.FlexEvent;
    
    [Bindable]
    public class OpenCloseHandler
    {
        //This class is for dynamically modifying height values of 
        //children components in a FlexViewer Widget.
         
        private var _displayTweetsHolder:VBox;
        private var _wTemplateHolder:VBox;        
        private var _newTweet1Holder:VBox; //deprecated v.2.3.1
        private var _unameFormHolder:VBox; //deprecated v.2.3.1
        private var _searchBox1Holder:VBox;
        private var _setupHolder:VBox;             
        
        public function OpenCloseHandler(displayTweets:VBox,wTemplateVBox:VBox,searchBox1:VBox,setup:VBox)
        {
            _displayTweetsHolder = displayTweets;
            _wTemplateHolder = wTemplateVBox;
            _searchBox1Holder = searchBox1;
            _setupHolder = setup;  
            const _ht:Number = _wTemplateHolder.height - 12;
			
            _searchBox1Holder.addEventListener(FlexEvent.HIDE, function(event:FlexEvent):void
			{
                calculateValues(_ht);                
            });
            _searchBox1Holder.addEventListener(FlexEvent.SHOW, function(event:FlexEvent):void
			{
                calculateValues(_ht);                
            });
            _setupHolder.addEventListener(FlexEvent.HIDE, function(event:FlexEvent):void
			{
                calculateValues(_ht);                
            });
            _setupHolder.addEventListener(FlexEvent.SHOW, function(event:FlexEvent):void
			{
                calculateValues(_ht);                
            });                           
           
        }
        
        private function calculateValues(ht:Number):void
        {
            var _ht:Number = ht;

            if(_searchBox1Holder.visible)
            {
                _ht = _ht - _searchBox1Holder.height; 
            }

            if(_setupHolder.visible)
            {
                _ht = _ht - _setupHolder.height; 
            }
          
            _displayTweetsHolder.height =  _ht;   
        }
    }
}