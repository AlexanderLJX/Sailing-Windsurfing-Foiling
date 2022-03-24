using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;

class TestAppMenuDelegate extends WatchUi.MenuInputDelegate {
	var model;
	var sailingView;
	var mTimer;
	var switcher;
    function initialize() {
        MenuInputDelegate.initialize();
        model = Application.getApp().model;
        sailingView = Application.getApp().sailingView;
        switcher = false;
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("item 1");
            model.discard();
            if(WatchUi has :ProgressBar){
            	WatchUi.pushView(new WatchUi.ProgressBar("Discarding...", null), new TestAppProgressDelegate(), WatchUi.SLIDE_DOWN);
            }
        	mTimer = new Timer.Timer();
        	mTimer.start(method(:onExit), 3000, false);
        } else if (item == :item_2) {
            System.println("item 2");
            model.save();
            if(WatchUi has :ProgressBar){
            	WatchUi.pushView(new WatchUi.ProgressBar("Saving...", null), new TestAppProgressDelegate(), WatchUi.SLIDE_DOWN);
            }
        	mTimer = new Timer.Timer();
        	mTimer.start(method(:onExit), 3000, false);
        }else if (item == :item_3) {
            System.println("item 3");
            if(model.mapCoordinates.size()==0){
            	return;
            }
            var currentCoordinates = model.mapCoordinates[model.mapCoordinates.size()-1];
            Settings.MarkOne[0] = currentCoordinates[0];
            Settings.MarkOne[1] = currentCoordinates[1];
			
        }else if (item == :item_4) {
            System.println("item 4");
            if(model._accuracy==null||model._accuracy==0){
            	return;
            }
            model.setCalibrateWindDirection();
            if(WatchUi has :ProgressBar){
            	WatchUi.pushView(new WatchUi.ProgressBar("Calibrating...", null), new TestAppProgressDelegate(), WatchUi.SLIDE_DOWN);
            }
//        	mTimer = new Timer.Timer();
//        	mTimer.start(method(:popview), 8000, false);
            
        }else if (item == :item_5) {
            System.println("item 5");
            WatchUi.pushView(new Rez.Menus.SettingMenu(), new SettingMenuDelegate(model), WatchUi.SLIDE_LEFT);
            
        }
    }
    
//    function popview(){
//    	popView(WatchUi.SLIDE_IMMEDIATE);
//    }
    
//    function onBack(){
//    	popView(WatchUi.SLIDE_IMMEDIATE);
//        return true;
//    }
    
    function onExit(){
    	System.exit();
    }

}