using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// timer setup menu handler
//
class SetMinSpeedMenuDelegate extends Ui.MenuInputDelegate
{
	var knotstokm = 1.85;
	function initialize() 
    {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
    	if (item == :id1)
    	{
    		Settings.SetMinSpeedValue(0);
    	}
    	else if (item == :id2)
    	{
    		Settings.SetMinSpeedValue(1);
    	}
    	else if (item == :id3)
    	{
    		Settings.SetMinSpeedValue(1.5);
    	}  
    	else if (item == :id4)
    	{
    		Settings.SetMinSpeedValue(2);
    	}
    	else if (item == :id5)
    	{
    		Settings.SetMinSpeedValue(2.5);
    	}
    	else if (item == :id6)
    	{
    		Settings.SetMinSpeedValue(3);
    	}
    	else if (item == :id7)
    	{
    		Settings.SetMinSpeedValue(3.5);
    	}    	
        else if (item == :id8)
        {
            Settings.SetMinSpeedValue(4);
        }    
        else if (item == :id10)
        {
            Settings.SetMinSpeedValue(5);
        }    
        else if (item == :id12)
        {
            Settings.SetMinSpeedValue(6);
        }    
        else if (item == :id16)
        {
            Settings.SetMinSpeedValue(8);
        }    
        else if (item == :id20)
        {
            Settings.SetMinSpeedValue(10);
        } 
        else if (item == :id24)
        {
            Settings.SetMinSpeedValue(12);
        }
        popView(WatchUi.SLIDE_IMMEDIATE);
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
}