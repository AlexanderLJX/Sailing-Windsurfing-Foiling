using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// setting menu handler
//
class SettingMenuDelegate extends Ui.MenuInputDelegate 
{
    var model;
	var sailingView;
    
    function initialize(Model) 
    {
        MenuInputDelegate.initialize();
        model = Model;
        sailingView = Application.getApp().sailingView;
    }

    function onMenuItem(item) 
    {
        if (item == :minSpeed)
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
        	if(Settings.alerts){
        		Settings.alerts = false;
        	}else{
        		Settings.alerts = true;
        	}
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
        else if (item == :autoCalibrateWindDirection)
        {
        	if(Settings.autoCalibrateWindDirection){
        		Settings.autoCalibrateWindDirection = false;
        	}else{
        		Settings.autoCalibrateWindDirection = true;
        	}
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
    }
}

