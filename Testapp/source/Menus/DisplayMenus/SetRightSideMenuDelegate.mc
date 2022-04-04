using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetRightSideMenuDelegate extends Ui.MenuInputDelegate
{

	function initialize() 
    {
    	MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id2)
    	{
    		popView(WatchUi.SLIDE_IMMEDIATE);
    		System.println("Pushing view");
    		Ui.pushView(new Rez.Menus.SetRightSideInfo(), new SetRightSideInfoMenuDelegate(0), Ui.SLIDE_LEFT);
    		return;
    	}
    	else if (item == :id3)
    	{
    		popView(WatchUi.SLIDE_IMMEDIATE);
    		Ui.pushView(new Rez.Menus.SetRightSideInfo(), new SetRightSideInfoMenuDelegate(2), Ui.SLIDE_LEFT);
    		return;
    	}
    	else if (item == :id4)
    	{
    		popView(WatchUi.SLIDE_IMMEDIATE);
    		Ui.pushView(new Rez.Menus.SetRightSideInfo(), new SetRightSideInfoMenuDelegate(3), Ui.SLIDE_LEFT);
    		return;
    	}
    	popView(WatchUi.SLIDE_IMMEDIATE);
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
}