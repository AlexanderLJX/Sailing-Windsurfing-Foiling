using Toybox.WatchUi;
using Toybox.System;

class SailingView extends WatchUi.View{
	var info;
	var _timer;
	var model;
	var leftSlotOne; 	
	var leftSlotTwo; 	
	var leftSlotThree; 
	var leftSlotFour;
	var leftSlotFive;
	
	var rightSlotOne; 	
	var rightSlotTwo;
	var rightSlotThree;
	var rightSlotFour; 
	var rightSlotFive;
	var slotArrayRight;
	var slotArrayLeft;
	var gpsPos;
	var recPos;
	var vmgPosOne;
	var vmgPosTwo;
	var mapLengthPos;
	var halfDC;
	var sinWind;
	var cosWind;
	const LAYLINE_DISTANCE = 1000;
	const MPS_TO_KNOT = 1.944;
	hidden var _gpsColorsArray = [Graphics.COLOR_RED, Graphics.COLOR_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN];
	hidden var trailColorArray = [Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLUE,Graphics.COLOR_DK_GREEN, Graphics.COLOR_GREEN,Graphics.COLOR_YELLOW,Graphics.COLOR_ORANGE,Graphics.COLOR_RED,Graphics.COLOR_PINK,Graphics.COLOR_PURPLE];
	hidden var moreTrailColorArray = [
									0x0000ff,
									0x0040ff,
									0x0080ff,
									0x00bfff,
									0x00ffff,
									0x00ffbf,
									0x00ff80,
									0x00ff40,
									0x00ff00,
									0x40ff00,
									0x80ff00,
									0xbfff00,
									0xffff00,
									0xffbf00,
									0xff8000,
									0xff4000,
									0xff0000,
									0xff0040,
									0xff0080,
									0xff00bf,
									0xff00ff,
									0xbf00ff,
									0x8000ff,
									0x4000ff
								];	
	const R = 6378;
//	const windArrow = [[0,0],[16,0],[8,30]];
	const windArrow = [[-8,-20],[8,-20],[0,20]];
	const windArrowDistance = (System.getDeviceSettings().screenHeight/2)-20;
	const sailBoat = [[0,-12],[10,12],[0,0],[-10,12]];
	var laylineOne = new [2];
	var laylineTwo = new [2];
	function initialize (){
		var width = System.getDeviceSettings().screenWidth;
		var height = System.getDeviceSettings().screenHeight;
		halfDC = width/2;
		View.initialize();
		model = Application.getApp().model;
		// Create slots
		slotArrayLeft = new [13];
		slotArrayRight = new [6];
		for(var i = 0; i<slotArrayLeft.size();i++){
//			if(i==0){
//				slotArrayLeft[i] = [0,10];
//				continue;
//			}
			slotArrayLeft[i] = calcSlotCoordinates(i%slotArrayLeft.size(), false, slotArrayLeft.size());
		}
		
		for(var i = 0; i<slotArrayRight.size();i++){
//			if(i==0){
//				slotArrayRight[i] = [0,10];
//				continue;
//			}
			slotArrayRight[i] = calcSlotCoordinates(i%slotArrayRight.size(), true, slotArrayRight.size());
		}
		for(var i = 0; i<windArrow.size();i++){
			windArrow[i][0] += halfDC;
		}
		
		gpsPos = [(width/2)-(width/20),(height/50)];
		recPos = [(width/2)+(width/20),(height/50)];
		vmgPosOne = [(width/2),(height/2)+(height/20)];
		vmgPosTwo = [(width/2),(height/2)+(height/8)];
		mapLengthPos = [(width/2),(height)-(height/10)];
		
	}
	// Calculate the position of information text on the screen
	function calcSlotCoordinates (yNumber,side, SlotsPerSide){
		var height = System.getDeviceSettings().screenHeight*8.7/10;
		var width = System.getDeviceSettings().screenWidth;
		var y = ((height/SlotsPerSide)*yNumber)+(height*0.65/8.7);
		
		// Pythagorean theorem
		var x = (Math.sqrt(Math.pow(width/2,2)-Math.pow(((height/2)-y).abs()+10, 2))).toNumber();
		if(side){
			x = (width/2)+x;
		}else{
			x = (width/2)-x;
		}
		return [x,y+(height*0.65/8.7)];
	}
	
//	function calcWindArrow (){
//		// Rotate arrow
//    	var angle = Math.toRadians(model.windDirection);
//    	var cos = Math.cos(angle);
//		var sin = Math.sin(angle);
//		
//		// Rotate the coordinates
//		for (var i = 0; i < windArrow.size(); i++) {
//    		var x = (windArrow[i][0] * cos) - (windArrow[i][1] * sin);
//    		var y = (windArrow[i][0] * sin) + (windArrow[i][1] * cos);
//
//    		result[i] = [x +(halfDC), y + (halfDC)];
//		}
//		// Transform the coordinates
//		for(var i = 0;i<windArrow.size();i++){
//			result[i][0] = result[i][0]+(sin*windArrowDistance);
//			result[i][1] = result[i][1]-(cos*windArrowDistance);
//		}
//	}
	
	function calculateLayline(){
		var laylineOneHeading = Math.toRadians(model.starboardAngle);
		var laylineTwoHeading = Math.toRadians(model.portAngle);
		laylineOne[0] = -(Math.sin(laylineOneHeading)*LAYLINE_DISTANCE);
		laylineOne[1] = (Math.cos(laylineOneHeading)*LAYLINE_DISTANCE);
		laylineOne = rotateCoordinates(laylineOne[0],laylineOne[1],sinWind,cosWind);
		
		laylineTwo[0] = -(Math.sin(laylineTwoHeading)*LAYLINE_DISTANCE);
		laylineTwo[1] = (Math.cos(laylineTwoHeading)*LAYLINE_DISTANCE);
		laylineTwo = rotateCoordinates(laylineTwo[0],laylineTwo[1],sinWind,cosWind);
	}
	
	function rotateCoordinates(cordX,cordY,sinB,cosB){
		var x = (cordX * cosB) - (cordY * sinB);
    	var y = (cordX * sinB) + (cordY * cosB);
		return [x,y];
	}
	
	function onShow() {
    	_timer = new Toybox.Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    }

    // Stop timer then hide
    //
    function onHide() {
        _timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate() {
        WatchUi.requestUpdate();
    }    

    // Update the view
    //
    function onUpdate(dc) {   
    	dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_WHITE);
    	dc.clear();
    	// update if wind change
    	if(model.windDirectionChange){
    		model.windDirectionChange = false;
//    		calcWindArrow();
    		var windDirection = Math.toRadians((360-model.windDirection));
    		sinWind = Math.sin(windDirection);
    		cosWind = Math.cos(windDirection);
    		calculateLayline();
    	}
    	// Draw track
    	
    	if(model.mapCoordinates.size()>5){
	    	var currentCoordinates = model.mapCoordinates[model.mapCoordinates.size()-1];
	    	var prevX = 0;
	    	var prevY = 0;
	    	var MapR = Settings.MapSize*R;
	    	var aspectRatio = Math.cos(currentCoordinates[0]);
	    	// Draw mark
	    	var markOneYa = ((-Settings.MarkOne[0] + currentCoordinates[0])*MapR);
	    	var markOneXa = ((Settings.MarkOne[1] - currentCoordinates[1])*aspectRatio*MapR);
	    	var markOneCords = rotateCoordinates(markOneXa,markOneYa,sinWind,cosWind);
	    	var markOneY = markOneCords[1]+halfDC;
	    	var markOneX = markOneCords[0]+halfDC;
	    	model.bearingToMarkOne = Math.toDegrees(Math.atan2(markOneXa, -markOneYa));
	    	// draw layline
	    	dc.setPenWidth(2);
	    	dc.drawLine(markOneX, markOneY, markOneX+laylineOne[0],markOneY+laylineOne[1]);
	    	dc.drawLine(markOneX, markOneY, markOneX+laylineTwo[0], markOneY+laylineTwo[1]);
	    	// draw angle guide
//	    	dc.drawLine(halfDC,halfDC,
	    	
	    	// draw line from mark to center
	    	dc.setPenWidth(1);
	    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
	    	dc.drawLine(halfDC, halfDC, markOneX, markOneY);
	    	
	    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
	    	dc.drawCircle(markOneX, markOneY, 8);
	    	dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
	    	dc.fillCircle(markOneX, markOneY, 7);
	    	dc.setPenWidth(3);
	    	// Then draw track
	    	for(var i = 0;i<model.mapCoordinates.size();i++){
	    		var xycords = new [2];
	    		xycords[1] = ((-model.mapCoordinates[i][0] + currentCoordinates[0])*MapR);
	    		xycords[0] = ((model.mapCoordinates[i][1] - currentCoordinates[1])*aspectRatio*MapR);
	    		xycords = rotateCoordinates(xycords[0], xycords[1],sinWind,cosWind);
	    		xycords[0] = xycords[0]+halfDC;
	    		xycords[1] = xycords[1]+halfDC;
	    		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
	    		if(i!=0){
//	    			var index = model.trailColorArray[i]>6 ? 6 : model.trailColorArray[i];
					if(Settings.MapTrail!=0){
						var index = model.trailColorArray[i];
	    				dc.setColor(moreTrailColorArray[index], Graphics.COLOR_TRANSPARENT);
	    			}
	    			// Set pen width for speed?
//	    			dc.setPenWidth(index+1);
	    			dc.drawLine(prevX, prevY, xycords[0], xycords[1]);
	    		}
	    		prevX = xycords[0];
	    		prevY = xycords[1];
    		}
    	}
    	
    	
    	dc.setColor(Graphics.COLOR_DK_BLUE,Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(windArrow);
    	
    	// Draw north
//		dc.drawText(halfDC, -2, Graphics.FONT_MEDIUM, "N", Graphics.TEXT_JUSTIFY_CENTER);
		// Draw boat
		dc.setColor(Graphics.COLOR_DK_GREEN,Graphics.COLOR_TRANSPARENT);
    	// Rotate boat
    	var angleB = Math.toRadians(model.currentHeading-model.windDirection);
    	var cosB = Math.cos(angleB);
		var sinB = Math.sin(angleB);
		var resultB = new [sailBoat.size()];
		// Rotate the coordinates
		for (var i = 0; i < sailBoat.size(); i++) {
    		var cords = rotateCoordinates(sailBoat[i][0],sailBoat[i][1],sinB,cosB);
    		resultB[i] = [cords[0] +(halfDC), cords[1]+ (halfDC)];
		}
		
		dc.fillPolygon(resultB);
    	
    	// Draw information stuff
    	dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    	
    	var angleToWind = model.angleToWind.toNumber();
    	var heading = model.currentHeading;
    	var currentHeading = heading.toNumber();
    	var windDirection = model.windDirection.toNumber();
    	var currentAngleToWind = model.currentAngleToWind.toNumber();
    	var maneuverSeconds = model.totalManeuverTime;
    	var currentSpeed = Lang.format("$1$",[(model.currentSpeed*MPS_TO_KNOT).format("%.1f")]);
//    	var realVSfake = Lang.format("\n$1$ $2$",[model.mSeconds,model.gpsSeconds]);
    	var vmg = Lang.format("$1$",[(model.currentVMG*MPS_TO_KNOT).format("%.1f")]);
		var maxVMG = Lang.format("$1$",[(model.maxVMG*MPS_TO_KNOT).format("%.1f")]);
		var recentVMG = Lang.format("$1$",[(model.recentVMG*MPS_TO_KNOT).format("%.1f")]);
		var recentVMGAngle = Lang.format("$1$",[(model.recentVMG*MPS_TO_KNOT).format("%.1f")]);
		var angleOfBestVMG = Lang.format("$1$",[(model.angleOfBestVMG).format("%.1f")]);
		var recentSpeed = Lang.format("$1$",[(model.recentSpeed*MPS_TO_KNOT).format("%.1f")]);
		var maxSpeed = Lang.format("$1$",[(model.maxSpeed*MPS_TO_KNOT).format("%.1f")]);
		var maneuverCount = model.maneuverCounter;
		var time = System.getClockTime();
		var timeString = Lang.format("$1$:$2$:$3$", [time.hour.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
		
		
    	dc.drawText(mapLengthPos[0],mapLengthPos[1], Graphics.FONT_SYSTEM_TINY, Settings.WidthMeter,Graphics.TEXT_JUSTIFY_CENTER);
		drawInformation (dc,0,Settings.autoCalibrateWindDirection ? "Wind/ATW(auto)" : "Wind/ATW",windDirection+"/ "+angleToWind,false);
		drawInformation (dc,2,"Count/Sec",maneuverCount+" / "+maneuverSeconds,false);
		drawInformation (dc,4,"Time",timeString,false);
		drawInformation (dc,6,"mVmg/mSpd",maxVMG+"/"+maxSpeed,false);
		drawInformation (dc,8,"vmg/ATW",recentVMG+"/"+angleOfBestVMG,false);
		drawInformation (dc,10,"60secSpd",recentSpeed,false);
		
		drawInformation (dc,0,"nATW",currentAngleToWind,true);
		drawInformation (dc,2,"Speed",currentSpeed,true);
		drawInformation (dc,4,"Vmg",vmg,true);
//		drawInformation (dc,8,"VMG",vmg,true);

		// Draw layline flag
		if(model.laylineFlag){
			dc.drawText(halfDC, 40, Graphics.FONT_SYSTEM_XTINY, "Overlay", Graphics.TEXT_JUSTIFY_CENTER);
		}else{
			dc.drawText(halfDC, 40, Graphics.FONT_SYSTEM_XTINY, "Underlay", Graphics.TEXT_JUSTIFY_CENTER);
		}
		if(model.isFoiling){
			dc.drawText(halfDC, 60, Graphics.FONT_SYSTEM_XTINY,"Foiling",Graphics.TEXT_JUSTIFY_CENTER);
		}else{
			dc.drawText(halfDC, 60, Graphics.FONT_SYSTEM_XTINY,"Start",Graphics.TEXT_JUSTIFY_CENTER);
			dc.drawText(halfDC, 75, Graphics.FONT_SYSTEM_XTINY,"Pumping!",Graphics.TEXT_JUSTIFY_CENTER);
		}
		// Draw starboardPortFlag
		if(model.starboardPortFlag){
//			System.println("Port");
		}else{
//			System.println("Starboard");
		}
		// Draw.upwindDownwindFlag
		if(model.angleFlag==0){
//			System.println("Upwind");
		}else if(model.angleFlag==1){
//			System.println("Reaching");
		}else{
//			System.println("Downwind");
		}
		
		dc.drawText(vmgPosOne[0],vmgPosOne[1],Graphics.FONT_SYSTEM_TINY,currentHeading,Graphics.TEXT_JUSTIFY_CENTER);
//		dc.drawText(vmgPosTwo[0],vmgPosTwo[1],Graphics.FONT_SYSTEM_XTINY,currentHeading,Graphics.TEXT_JUSTIFY_CENTER);
		// draw GPS signal
		dc.setColor(_gpsColorsArray[model._accuracy==null ? 0 : model._accuracy], Graphics.COLOR_TRANSPARENT);
        
        dc.drawText(gpsPos[0], gpsPos[1], Graphics.FONT_SYSTEM_XTINY, "GPS", Graphics.TEXT_JUSTIFY_RIGHT);
        // draw Rec
        dc.setColor(_gpsColorsArray[model.running ? 0 : 3], Graphics.COLOR_TRANSPARENT);
        
        dc.drawText(recPos[0], recPos[1], Graphics.FONT_SYSTEM_XTINY, "REC" , Graphics.TEXT_JUSTIFY_LEFT);
    }
    
    function drawInformation (dc,arrayPosition,stringOne,stringTwo,leftOrRight){
    	var justify;
    	var Xoffset;
    	if(leftOrRight){
    		justify = Graphics.TEXT_JUSTIFY_RIGHT;
    		Xoffset = -7;
    		dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);
    		dc.drawText(slotArrayRight[arrayPosition][0], slotArrayRight[arrayPosition][1], Graphics.FONT_SYSTEM_TINY, stringOne, justify | Graphics.TEXT_JUSTIFY_VCENTER);
    		dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    		dc.drawText(slotArrayRight[arrayPosition+1][0]+Xoffset, slotArrayRight[arrayPosition+1][1]-5, Graphics.FONT_NUMBER_MEDIUM, stringTwo, justify | Graphics.TEXT_JUSTIFY_VCENTER);
    	}else{
    		justify = Graphics.TEXT_JUSTIFY_LEFT;
    		Xoffset = 3;
    		dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);
    		dc.drawText(slotArrayLeft[arrayPosition][0], slotArrayLeft[arrayPosition][1], Graphics.FONT_SYSTEM_XTINY, stringOne, justify | Graphics.TEXT_JUSTIFY_VCENTER);
    		dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    		dc.drawText(slotArrayLeft[arrayPosition+1][0]+Xoffset, slotArrayLeft[arrayPosition+1][1], Graphics.FONT_SYSTEM_XTINY, stringTwo, justify | Graphics.TEXT_JUSTIFY_VCENTER);
    	}
    }
}