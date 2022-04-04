using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Properties as Pro;
using Toybox.Lang;
using Toybox.System;

// set of permanently stored values
//
class Settings
{
	static var MinSpeedValue = 3.5;
	static var MapSize = 0;
	static var WidthMeterNumber = 100;
	static var WidthMeter = "";
	static var MapTrail = 0;
	static var MarkOne = [0,0];
	static var alerts = true;
	static var autoCalibrateWindDirection = false;
	static var showLeftSide = true;
	static var showMinSpeed = true;
	static var showUnderOverlay = true;
	static var showHeading = true;
	static var showRightSide = true;
	static var rightSideInfo = [0,1,2];

	static function LoadSettings()
	{
//		SetMapSize(Pro.getValue("WidthMeterNumber"));
//		SetMinSpeedValue(App.Properties.getValue("MinSpeedValue" as Lang.String) as Lang.Number);
//		SetMapTrail(App.Properties.getValue("MapTrail" as Lang.String) as Lang.Number);
//		SetMarkOne(App.Properties.getValue("MarkOneLat" as Lang.String) as Lang.Numeric, getValue("MarkOneLong" as Lang.String) as Lang.Numeric);
//		SetAlerts(App.Properties.getValue("Alerts" as Lang.String) as Lang.Boolean);
//		SetAutoCalibrateWindDirection(App.Properties.getValue("autoCalibrateWindDirection" as Lang.String) as Lang.Boolean);
//		SetShowLeftSide(App.Properties.getValue("ShowLeftSide" as Lang.String) as Lang.Boolean);
//		SetShowMinSpeed(App.Properties.getValue("ShowMinSpeed" as Lang.String) as Lang.Boolean);
//		SetShowUnderOverlay(App.Properties.getValue("ShowUnderOverlay" as Lang.String) as Lang.Boolean);
//		SetShowHeading(App.Properties.getValue("ShowHeading" as Lang.String) as Lang.Boolean);
//		SetShowRightSide(App.Properties.getValue("ShowRightSide" as Lang.String) as Lang.Boolean);
		
		SetMapSize(App.getApp().getProperty("WidthMeterNumber"));
		SetMinSpeedValue(App.getApp().getProperty("MinSpeedValue"));
		SetMapTrail(App.getApp().getProperty("MapTrail"));
		SetMarkOne(App.getApp().getProperty("MarkOneLat"),App.getApp().getProperty("MarkOneLong"));
		alerts = App.getApp().getProperty("MapTrail");
		autoCalibrateWindDirection = App.getApp().getProperty("autoCalibrateWindDirection");
		showLeftSide = App.getApp().getProperty("ShowLeftSide");
		showMinSpeed = App.getApp().getProperty("ShowMinSpeed");
		showUnderOverlay = App.getApp().getProperty("ShowUnderOverlay");
		showHeading = App.getApp().getProperty("ShowHeading");
		showRightSide = App.getApp().getProperty("ShowRightSide");
	}

//	static function SaveSettings()
//	{
//		App.getApp().setProperty("WidthMeterNumber", WidthMeter);
//		App.getApp().setProperty("MinSpeedValue", MinSpeedValue);
//		App.getApp().setProperty("MapTrail", MapTrail);
//		App.getApp().setProperty("MarkOneLat", MarkOne[0]);
//		App.getApp().setProperty("MarkOneLong", MarkOne[1]);
//		App.getApp().setProperty("Alerts", alerts);
//		App.getApp().setProperty("AutoCalibrateWindDirection", autoCalibrateWindDirection);
//		App.getApp().setProperty("ShowLeftSide", showLeftSide);
//		App.getApp().setProperty("ShowMinSpeed", showMinSpeed);
//		App.getApp().setProperty("ShowUnderOverlay", showUnderOverlay);
//		
//		
////		App.getApp().setProperty("WidthMeterNumber", WidthMeter);
////		App.getApp().setProperty("MinSpeedValue", MinSpeedValue);
////		App.getApp().setProperty("MapTrail", MapTrail);
////		App.getApp().setProperty("MarkOneLat", MarkOne[0]);
////		App.getApp().setProperty("MarkOneLong", MarkOne[1]);
////		App.getApp().setProperty("Alerts", alerts);
////		App.getApp().setProperty("AutoCalibrateWindDirection", autoCalibrateWindDirection);
////		App.getApp().setProperty("ShowLeftSide", showLeftSide);
////		App.getApp().setProperty("ShowMinSpeed", showMinSpeed);
////		App.getApp().setProperty("ShowUnderOverlay", showUnderOverlay);
//	}
	
	static function SetMarkOne(lat,long){
		lat = lat.toFloat();
		long = long.toFloat();
		MarkOne[0] = lat;
		MarkOne[1] = long;
		App.getApp().setProperty("MarkOneLat", MarkOne[0]);
		App.getApp().setProperty("MarkOneLong", MarkOne[1]);
	}
	
	static function SetMinSpeedValue(value)
	{
		MinSpeedValue = (value == null) ? 3.5 : value;
		App.getApp().setProperty("MinSpeedValue", MinSpeedValue);
	}
	

	static function SetMapSize(mapSize)
	{
		// screenWidth * pixel / MapSize = mapSize
		// pixel = 1000m
		// MapSize = screenWidth * 1000 / mapSize
		mapSize = mapSize.toNumber();
		MapSize = System.getDeviceSettings().screenWidth * 1000 / mapSize;
		WidthMeter = Lang.format("$1$m",[mapSize]);
		App.getApp().setProperty("WidthMeterNumber", WidthMeter);
	}
	
	static function SetMapTrail(option)
	{
		option = option.toNumber();
		MapTrail = option;
		App.getApp().setProperty("MapTrail", MapTrail);
	}
	
	static function SetShowLeftSide(){
		showLeftSide = !showLeftSide;
		App.getApp().setProperty("ShowLeftSide", showLeftSide);
	}
	
	static function SetAlerts(){
		alerts = !alerts;
		App.getApp().setProperty("Alerts", alerts);
	}
	
	static function SetAutoCalibrateWindDirection(){
		autoCalibrateWindDirection = !autoCalibrateWindDirection;
		App.getApp().setProperty("AutoCalibrateWindDirection", autoCalibrateWindDirection);
	}
	
	static function SetShowMinSpeed(){
		showMinSpeed = !showMinSpeed;
		App.getApp().setProperty("ShowMinSpeed", showMinSpeed);
	}
	
	static function SetShowUnderOverlay(){
		showUnderOverlay = !showUnderOverlay;
		App.getApp().setProperty("ShowUnderOverlay", showUnderOverlay);
	}
	
	static function SetShowHeading(){
		showHeading = !showHeading;
		App.getApp().setProperty("ShowHeading", showHeading);
	}
	
	static function SetShowRightSide(){
		showRightSide = !showRightSide;
		App.getApp().setProperty("ShowRightSide", showRightSide);
	}
	
	static function SetRightSideInfo(infoNumber, infoType){
		rightSideInfo[infoNumber] = infoType;
		App.getApp().setProperty("RightSideInfo0", rightSideInfo[0]);
		App.getApp().setProperty("RightSideInfo1", rightSideInfo[1]);
		App.getApp().setProperty("RightSideInfo2", rightSideInfo[2]);
	}
	
}