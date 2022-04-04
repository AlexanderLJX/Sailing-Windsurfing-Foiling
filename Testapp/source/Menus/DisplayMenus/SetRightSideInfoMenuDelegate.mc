using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


class SetRightSideInfoMenuDelegate extends Ui.MenuInputDelegate
{
	var infoNumber;
	function initialize(InfoNumber) 
    {
    	MenuInputDelegate.initialize();
    	infoNumber = InfoNumber;
    	System.println("initialized");
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetRightSideInfo(infoNumber, 0);
    	}  
    	else if (item == :id2)
    	{
    		Settings.SetRightSideInfo(infoNumber, 1);
    	}
    	else if (item == :id3)
    	{
    		Settings.SetRightSideInfo(infoNumber, 2);
    	}
    	else if (item == :id4)
    	{
    		Settings.SetRightSideInfo(infoNumber, 3);
    	}
		popView(WatchUi.SLIDE_IMMEDIATE);
		popView(WatchUi.SLIDE_IMMEDIATE);
    }
}