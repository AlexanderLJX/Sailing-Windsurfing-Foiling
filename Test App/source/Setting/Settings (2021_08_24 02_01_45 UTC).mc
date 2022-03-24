using Toybox.Graphics as Gfx;
using Toybox.Application as App;
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

	static function LoadSettings()
	{
		
		SetMapSize(App.getApp().getProperty("WidthMeterNumber"));
		SetMinSpeedValue(App.getApp().getProperty("MinSpeedValue"));
		SetMapTrail(App.getApp().getProperty("MapTrail"));
		SetMarkOne(App.getApp().getProperty("MarkOneLat"),App.getApp().getProperty("MarkOneLong"));
		alerts = App.getApp().getProperty("Alerts");
		autoCalibrateWindDirection = App.getApp().getProperty("AutoCalibrateWindDirection");
	}

	static function SaveSettings()
	{
		App.getApp().setProperty("WidthMeterNumber", WidthMeter);
		App.getApp().setProperty("MinSpeedValue", MinSpeedValue);
		App.getApp().setProperty("MapTrail", MapTrail);
		App.getApp().setProperty("MarkOneLat", MarkOne[0]);
		App.getApp().setProperty("MarkOneLong", MarkOne[1]);
		App.getApp().setProperty("Alerts", alerts);
		App.getApp().setProperty("AutoCalibrateWindDirection", autoCalibrateWindDirection);
	}
	
	static function SetMarkOne(lat,long){
		lat = lat.toFloat();
		long = long.toFloat();
		MarkOne[0] = lat;
		MarkOne[1] = long;
	}
	
	static function SetMinSpeedValue(value)
	{
		MinSpeedValue = (value == null) ? 3.5 : value;
	}
	

	static function SetMapSize(mapSize)
	{
		// screenWidth * pixel / MapSize = mapSize
		// pixel = 1000m
		// MapSize = screenWidth * 1000 / mapSize
		mapSize = mapSize.toNumber();
		MapSize = System.getDeviceSettings().screenWidth * 1000 / mapSize;
		WidthMeter = Lang.format("$1$m",[mapSize]);
	}
	
	static function SetMapTrail(option)
	{
		option = option.toNumber();
		MapTrail = option;
	}
}