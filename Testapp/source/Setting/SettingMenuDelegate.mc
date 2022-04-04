using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// setting menu handler
//
class SettingMenuDelegate extends Ui.MenuInputDelegate 
{
	var sailingView;
    
    function initialize() 
    {
        MenuInputDelegate.initialize();
        sailingView = Application.getApp().sailingView;
    }

    function onMenuItem(item) 
    {
    	
        if (item == :displaySettings)
        {
        	popView(WatchUi.SLIDE_IMMEDIATE);
            Ui.pushView(new Rez.Menus.SetDisplaySettings(), new SetDisplaySettingsMenuDelegate(), Ui.SLIDE_LEFT);
        }
        else if (item == :minSpeed)
        {
            Ui.pushView(new Rez.Menus.SetMinSpeed(), new SetMinSpeedMenuDelegate(), Ui.SLIDE_LEFT);
        } 
        else if (item == :mapSize)
        {
        	Ui.pushView(new Rez.Menus.SetMapSize(), new SetMapSizeMenuDelegate(), Ui.SLIDE_LEFT);
        }  
        else if (item == :mapTrail)
        {
            Ui.pushView(new Rez.Menus.SetMapTrail(), new SetMapTrailMenuDelegate(), Ui.SLIDE_LEFT);
        }
        else if (item == :alerts)
        {
        	Settings.SetAlerts();
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
        else if (item == :autoCalibrateWindDirection)
        {
        	Settings.SetAutoCalibrateWindDirection();
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
    }
}

