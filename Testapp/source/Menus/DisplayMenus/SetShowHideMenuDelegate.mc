using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


class SetShowHideMenuDelegate extends Ui.MenuInputDelegate
{
	function initialize() 
    {
    	MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetShowLeftSide();
    	}  
    	else if (item == :id2)
    	{
    		Settings.SetShowMinSpeed();
    	}
    	else if (item == :id3)
    	{
    		Settings.SetShowUnderOverlay();
    	}
    	else if (item == :id4)
    	{
    		Settings.SetShowHeading();
    	}
    	else if (item == :id5)
    	{
    		Settings.SetShowRightSide();
    	}
		popView(WatchUi.SLIDE_IMMEDIATE);
		popView(WatchUi.SLIDE_IMMEDIATE);
    }
}