using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetDisplaySettingsMenuDelegate extends Ui.MenuInputDelegate
{

	function initialize() 
    {
    	MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		
    		Ui.pushView(new Rez.Menus.SetShowHide(), new SetShowHideMenuDelegate(), Ui.SLIDE_LEFT);
    		return;
    	}  
    	else if (item == :id5)
    	{
    		
    		Ui.pushView(new Rez.Menus.SetRightSide(), new SetRightSideMenuDelegate(), Ui.SLIDE_LEFT);
    		return;
    	}
        popView(WatchUi.SLIDE_IMMEDIATE);
    }
}