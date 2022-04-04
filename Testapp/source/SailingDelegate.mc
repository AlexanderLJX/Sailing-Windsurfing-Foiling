using Toybox.WatchUi;

class SailingDelegate extends WatchUi.BehaviorDelegate {
	var model;
	function initialize (){
		BehaviorDelegate.initialize();	
		model = Application.getApp().model;
	}
	
	function onSelect(){
		return true;
	}
	
	function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TestAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function onBack() {
    	return true;
    }
}