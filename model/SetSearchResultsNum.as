package widgets.twittersearch.model
{
    [Bindable]
    public class SetSearchResultsNum
    {
        //This class sets the number of results that will be returned
        //in a twitter search query.
        
        private var _index:uint;
        
        public function SetSearchResultsNum(resultsNumber:String)
        {   
            switch(resultsNumber)
            {
                case "20": 
                    _index = 0;
                    break;
                case "40": 
                    _index = 1;
                    break;
                case "60": 
                    _index = 2;
                    break;
                case "80": 
                    _index = 3;
                    break;
                case "100": 
                    _index = 4;
                    break;
            }             
        }
        
        public function get index():uint
        {   
            return _index;
        }
    }
}