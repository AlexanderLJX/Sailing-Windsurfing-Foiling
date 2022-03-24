using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetMapSizeMenuDelegate extends Ui.MenuInputDelegate
{

	function initialize() 
    {
    	MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetMapSize(20);
    	}  
    	else if (item == :id2)
    	{
    		Settings.SetMapSize(50);
    	}
    	else if (item == :id3)
    	{
    		Settings.SetMapSize(100);
    	}
    	else if (item == :id4)
    	{
    		Settings.SetMapSize(150);
    	}
    	else if (item == :id5)
    	{
    		Settings.SetMapSize(200);
    	}    	
        else if (item == :id10)
        {
            Settings.SetMapSize(300);
        }    
        else if (item == :id20)
        {
            Settings.SetMapSize(500);
        }    
        else if (item == :id30)
        {
            Settings.SetMapSize(1000);
        }else if (item == :id40)
        {
            Settings.SetMapSize(2000);
        }else if (item == :id50)
        {
            Settings.SetMapSize(5000);
        }
        popView(WatchUi.SLIDE_IMMEDIATE);
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
}