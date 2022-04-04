using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetMapTrailMenuDelegate extends Ui.MenuInputDelegate
{

	function initialize() 
    {
    	MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetMapTrail(0);
    	}  
    	else if (item == :id2)
    	{
    		Settings.SetMapTrail(1);
    	}
    	else if (item == :id3)
    	{
    		Settings.SetMapTrail(2);
    	}
    	popView(WatchUi.SLIDE_IMMEDIATE);
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
}