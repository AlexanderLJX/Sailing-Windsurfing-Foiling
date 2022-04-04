using Toybox.Application;
using Toybox.WatchUi;

class TestAppApp extends Application.AppBase {
	var model;
	var controller;
	var sailingView;

    function initialize() {
        AppBase.initialize();
        model = new TestAppModel();
        sailingView = new SailingView();
        Settings.LoadSettings();
//        controller = new TestAppController();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method(:onPosition) );
    }
    
    function onPosition(info) { 
        model.SetPositionInfo(info);
    }
    
    function onExit(){
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ sailingView, new SailingDelegate() ];
    }

}
