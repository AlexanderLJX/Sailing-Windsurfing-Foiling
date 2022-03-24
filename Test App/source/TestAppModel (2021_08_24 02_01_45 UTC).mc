using Toybox.Math;
using Toybox.Position;
using Toybox.Timer;
using Toybox.Attention;

class TestAppModel{
	// Timer for handling the accelerometer
//    hidden var mTimer;
    // Time elapsed
    var mSeconds;
    var isRecording;
    var isFoiling;
	var startFoiling;
	var stoppedFoiling;
	var headingArray;
	var currentHeading;
	var speedArray;
	var currentSpeed;
	var maxSpeed;
	var recentSpeed;
	var recentSpeedExpiry;
	var positionInfo;
	var historySize;
	var maxVariance;
	var calibrateWindDirection;
	var calibrateWindDirectionOne;
	var calibrateWindDirectionTwo;
	var calibrateWindDirectionTicker;
	var windDirection;
	var angleToWind;
	var currentAngleToWind;
	var vibeObj;
	var stopFoilingVibeObj = [
        new Attention.VibeProfile(100,800),
        new Attention.VibeProfile(50,800)
	];
    var startFoilingVibeObj = [
        new Attention.VibeProfile(50,800),
        new Attention.VibeProfile(100,800)
    ];
    var OverlayVibeObj = [
        new Attention.VibeProfile(20,800),
        new Attention.VibeProfile(100,800)
    ];
    var UnderlayVibeObj = [
         
        new Attention.VibeProfile(100,800),
        new Attention.VibeProfile(50,800)
    ];
	var newAngle;
	var newAngleTwo;
	var running;
	var angleToWindArray;
	var maneuverFlag;
	var _accuracy;
	var currentVMG;
	var maxVMG;
	var minVMG;
	var recentVMG;
	var recentVMGExpiry;
	var gpsSeconds;
	var mSession;
	var VMGarray;
	var angleOfBestVMG;
	hidden var mVMGField;
	hidden var mAngleToWindField;
	hidden var mTotalManeuverField;
	hidden var mManeuverTimeField;
	hidden var VMGATWField;
	hidden var mWindDirection;
	var totalManeuverTime;
	var maneuverCounter;
	var maneuverTimer;
	var mapCoordinates;
	
	var bearingToMarkOne;
	var bearingToMarkOneExpiry;
	var laylineFlag;
	
	var trailColorArray;
	var starboardPortFlag;
	
	var windDirectionChange;
	var upwindDownwindFlag;
	var upwindDownwindFlagExpiry;
	var angleFlag;
	const colorsAvailable = 23;
	var upwindTicker;
//	var testLatitude = 50.0000000;
//	var testLongitude = 50.0000000;
	var starboardAngle;
	var portAngle;
	var starboardPortArray;
	        	
    // Initialize sensor readings
    function initialize() {
    	starboardPortArray = [];
    	starboardAngle = -25;
    	portAngle = 65;
    	upwindTicker = 0;
        // Time elapsed
        mSeconds = 0;
        isFoiling = false;
        startFoiling = false;
        stoppedFoiling = false;
        headingArray = [];
        speedArray = [];
        currentHeading = 0;
        currentSpeed = 0;
        maxSpeed = 0;
        historySize = 60;
        maxVariance = 10;
        angleToWind = 45;
        // calibrateWindDirection is a flag for direction one or two
        calibrateWindDirection = false;
        calibrateWindDirectionOne = false;
        calibrateWindDirectionTwo = false;
        calibrateWindDirectionTicker = 0;
        windDirection  = 20;
        currentAngleToWind = 0.0;
        vibeObj = [new Attention.VibeProfile(50,1000)];
        
        
        newAngle = -25;
        newAngleTwo = 65.0;
        starboardPortFlag = false;
        running = false;
        angleToWindArray = [];
        
        maneuverFlag = false;
        totalManeuverTime = 0;
        maneuverCounter = 0;
        maneuverTimer = 0;
        currentVMG = 0;
        maxVMG = 0;
        minVMG = 0;
        recentVMG = 0;
        recentVMGExpiry = 0;
        VMGarray = [];
        angleOfBestVMG = 0;
        gpsSeconds = 0;
        mapCoordinates = [];
        
        trailColorArray = [];
        
        recentSpeedExpiry = 0;
        recentSpeed = 0;
        
        bearingToMarkOne = 0;
		bearingToMarkOneExpiry = 0;
		laylineFlag = false;
		
		windDirectionChange = true;
		upwindDownwindFlag = true;
		upwindDownwindFlagExpiry = 0;
		angleFlag = 0;
        
        mSession = ActivityRecording.createSession({:sport=>ActivityRecording.SPORT_GENERIC, :name=>"Windfoiling"});
        mVMGField = mSession.createField("VMG", 1, FitContributor.DATA_TYPE_FLOAT, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mAngleToWindField = mSession.createField("ATW", 2, FitContributor.DATA_TYPE_SINT16, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mTotalManeuverField = mSession.createField("mTotal", 3, FitContributor.DATA_TYPE_UINT16, {:mesgType => FitContributor.MESG_TYPE_SESSION});
        mManeuverTimeField = mSession.createField("mTime", 4, FitContributor.DATA_TYPE_UINT8, {:mesgType => FitContributor.MESG_TYPE_LAP});
        VMGATWField = mSession.createField("VMG_ATW", 5, FitContributor.DATA_TYPE_SINT16, {:mesgType => FitContributor.MESG_TYPE_RECORD});
        mWindDirection = mSession.createField("WindDirection",6,FitContributor.DATA_TYPE_SINT16,{:mesgType => FitContributor.MESG_TYPE_RECORD});
    }
    	

	function getBearing(a,b){
		var y = Math.sin(b[1]-a[1]) * Math.cos(b[0]);
		var x = Math.cos(a[0])*Math.sin(b[0]) - (Math.sin(a[0])*Math.cos(b[0])*Math.cos(b[1]-a[1]));
		var z = Math.atan2(y, x);
		var brng = Math.toDegrees(z); // in degrees
		return brng;
	}
	
	function inbetweenAngle(windDirection,angleToWind,bearingToMark){
		var anglediff = (windDirection.toNumber() - bearingToMark.toNumber() + 180 + 360) % 360 - 180;
		return (anglediff <= angleToWind && anglediff>=-angleToWind);
	}
	//called once maneuver is over
//	function calcManeuverStats(){
//		
//		// return time, time under min speed, sharpness - angle change/time, efficiency- percentage speed decrease
//	}
//	
//	function setWindDirectionATW(angleOne,angleTwo){
//		
//	}

    
    function SetPositionInfo(positionInfo) {
    	_accuracy = (positionInfo != null) ? positionInfo.accuracy : 0;
        if (_accuracy < 1 )
        {
            return;
        }
        // Convert the latitude and longitude to coordinates
        var position = positionInfo.position.toRadians();
    	if(mapCoordinates.size()==historySize){
    		mapCoordinates = mapCoordinates.slice(1,mapCoordinates.size());
    	}
    	mapCoordinates.add([position[0],position[1]]);
    	// simulate test data
//    	mapCoordinates.add([testLatitude,testLongitude]);
//    	if((gpsSeconds/40)%2==0){
//    		testLatitude += 0.00001;
//    		testLongitude += 0.00001;
//    	}else{
//    		testLatitude += 0.00001;
//    		testLongitude -= 0.00001;
//    	}
    	//
        var info = Activity.getActivityInfo();
        if(info!=null){
        	if(speedArray.size()==historySize){
				speedArray = speedArray.slice(1,speedArray.size());
			}
			currentSpeed = info.currentSpeed;
        	speedArray.add(currentSpeed);
        	if(currentSpeed>maxSpeed){
        		maxSpeed = currentSpeed;
        	}
        	if(currentSpeed>recentSpeed){
        		recentSpeedExpiry = 0;
        		recentSpeed = currentSpeed.abs();
        	}
        	recentSpeedExpiry++;
        	if(recentSpeedExpiry>historySize){
        		recentSpeed = 0;
        		for(var i = 0;i<speedArray.size();i++){
        			if(recentSpeed>speedArray[i]){
        				recentSpeed = speedArray[i];
        				recentSpeedExpiry = speedArray.size() - i;
        			}
        		}
        	}
//			if((mSeconds%30<3)||(mSeconds%30>27)){
//				speedArray.add(generateRandomData(1,3));
//			}else{
//				speedArray.add(generateRandomData(4,5));
//			}
        	
        }
		
		if(positionInfo!=null){
			if(headingArray.size()==historySize){
				headingArray = headingArray.slice(1,headingArray.size());
			}
			
        	headingArray.add(Math.toDegrees(positionInfo.heading));
//			if((gpsSeconds/40)%2==0){
//				headingArray.add(generateRandomData(40,49));
//			}else{
//				headingArray.add(generateRandomData(-49,-40));
//			}
			
        	currentHeading = headingArray[headingArray.size()-1];
        	
        	currentAngleToWind = getSmallerAngle(windDirection,currentHeading).toFloat();
        	if(angleToWindArray.size()==historySize){
        		angleToWindArray = angleToWindArray.slice(1,historySize);
        	}
        	angleToWindArray.add(currentAngleToWind);
        	// check Expiry
        	
	        // above or below layline
	        // if below layline, 
	        // starboardAngle will be lower than bearing, bearing higher than starboard
	        // portAngle will be higher than bearing, bearing lower than port
	        bearingToMarkOne = getBearing(mapCoordinates[mapCoordinates.size()-1],Settings.MarkOne);
	        
	        
			if (inbetweenAngle(windDirection,angleToWind,bearingToMarkOne)){
	        	// below layline
	        	// check if laylineFlag changed
	        	if(laylineFlag){
	        		// Enter below the layline
	        		if(bearingToMarkOneExpiry>4){
	        			bearingToMarkOneExpiry= 0;
	        			if(Settings.alerts){
		    				if(Toybox.Attention has :playTone){
		    					Attention.playTone(Attention.TONE_ALERT_LO);
		    					Attention.vibrate(UnderlayVibeObj);
		    				}
		    			}
	        		}
	        	}
	        	laylineFlag=false;
	        	
	        }else{
	        	// above layline
	        	// check if laylineFlag changed
	        	if(!laylineFlag){
	        		// Enter above the layline
	        		if(bearingToMarkOneExpiry>4){
	        			bearingToMarkOneExpiry= 0;
	        			if(Settings.alerts){
	        				if(Toybox.Attention has :playTone){
	        					Attention.playTone(Attention.TONE_ALERT_HI);
	        				}
	        				Attention.vibrate(OverlayVibeObj);
	        			}
	        		}
	        	}
	        	laylineFlag=true;
	        	
	        }
        	bearingToMarkOneExpiry++;
        	//
        	currentVMG = Math.cos(Math.toRadians(currentAngleToWind.abs()))*currentSpeed;
        	if(currentVMG > maxVMG){
        		maxVMG = currentVMG;
        	}else if(currentVMG<minVMG){
        		minVMG = currentVMG;
        	}
        	if(VMGarray.size()==historySize){
        		VMGarray = VMGarray.slice(1,historySize);
        	}
        	VMGarray.add(currentVMG);
        	
        	if(currentVMG>recentVMG){
        		recentVMGExpiry = 0;
        		recentVMG = currentVMG;
        		angleOfBestVMG = currentAngleToWind;
        	}
        	recentVMGExpiry++;
        	// loop through the vmg array to find the best vmg
        	if(recentVMGExpiry>historySize){
        		recentVMG = 0;
        		for(var i = 0; i < VMGarray.size();i++){
        			if(VMGarray[i]>recentVMG){
        				angleOfBestVMG = angleToWindArray[i];
        				recentVMG = VMGarray[i];
        				recentVMGExpiry = VMGarray.size() - i;
        			}
        		}
        	}
        	VMGATWField.setData(angleOfBestVMG);
//        	if(windDirection<0&&currentHeading>0){
//        		if(currentAngleToWind<-180){
//        			currentAngleToWind = -360 - currentAngleToWind;
//        		}
//        	}else if(windDirection>0&&currentHeading<0){
//        		if(currentAngleToWind<180){
//        			currentAngleToWind = 360 - currentAngleToWind;
//        		}
//        	}
//        	System.println(currentAngleToWind);
        	
			
        }
//        if(isFoilingArray.size()==historySize){
//        	isFoilingArray = isFoilingArray.slice(1,isFoilingArray.size());
//        }
		maneuverTimer++;
        if(currentSpeed>Settings.MinSpeedValue){
        	if(!isFoiling){
        		// Started foiling
        		isFoiling = true;
        		if(Settings.alerts){
        			Attention.vibrate(startFoilingVibeObj);
        		}
        	}
        	// Check for change in angle upwind / downwind
	        if(inbetweenAngle(windDirection,70,currentHeading)){
	        	if(angleFlag!=0){
	        		// to upwind
	        		angleFlag = 0;
	        		// if was sailing downwind the last 10 seconds
	        		if(upwindDownwindFlagExpiry<=10){
	        			// round leeward mark
	        			if(isFoiling){
	        				mSession.addLap();
	        			}
	        		}
	        	}
	        	if(Settings.autoCalibrateWindDirection){
	        		if(upwindTicker>=24){
		        		upwindTicker = 0;
		        		if(starboardPortFlag){
		        			// Port
		        			portAngle = getBearing(mapCoordinates[mapCoordinates.size()-16],mapCoordinates[mapCoordinates.size()-8]);
		        		}else{
		        			// Starboard
		        			starboardAngle = getBearing(mapCoordinates[mapCoordinates.size()-16],mapCoordinates[mapCoordinates.size()-8]);
		        		}
		        		windDirectionChange = true;
	        		}
	        	}
	        	upwindDownwindFlagExpiry = 0;
	        	upwindTicker++;
	        }else if(inbetweenAngle(windDirection,120,currentHeading)){
	        	if(angleFlag!=1){
	        		// to reach
	        		angleFlag = 1;
	        	}
	        	upwindDownwindFlagExpiry++;
	        	upwindTicker = 0;
	        }else{
	        	if(angleFlag!=2){
	        		// to downwind
	        		angleFlag = 2;
	        		
	        		// if was sailing upwind at most 10 seconds ago
	        		if(upwindDownwindFlagExpiry<=10){
	        			// round windward mark
	        			if(isFoiling){
	        				mSession.addLap();
	        			}
	        		}
	        	}
	        	upwindDownwindFlagExpiry = 0;
	        	upwindTicker = 0;
	        }
        }else{
        	if(isFoiling){
        		upwindTicker = 0;
        		// Stopped foiling
        		isFoiling = false;
        		if(Settings.alerts){
        			Attention.vibrate(stopFoilingVibeObj);
        		}
        	}
//        	isFoilingArray.add(false);
        }
        
        // Get Avg Heading
//        var averageHeading = getMeanAngle(headingArray);
        
        // If calibrate wind direction, 
        // find the 5 seconds with the least variance in heading
        
        if(calibrateWindDirectionOne){
//			System.println("calibrateWindDirectionOne"+currentHeading);
			calibrateWindDirectionTicker++;
        	if(calibrateWindDirectionTicker>6){
        		newAngle = getBearing(mapCoordinates[mapCoordinates.size()-5],mapCoordinates[mapCoordinates.size()-1]);
       			
        		Attention.vibrate(vibeObj);
        		
        		// Reset
        		calibrateWindDirectionOne = false;
        		calibrateWindDirectionTicker = 0;
        		// prep for two
        		calibrateWindDirection = true;
        		if(WatchUi has :ProgressBar){
        			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        		}
        	}
        	
        }else if(calibrateWindDirectionTwo){
//       		System.println("calibrateWindDirectionTwo"+currentHeading);
        	calibrateWindDirectionTicker++;
        	if(calibrateWindDirectionTicker>6){
        		newAngleTwo = getBearing(mapCoordinates[mapCoordinates.size()-5],mapCoordinates[mapCoordinates.size()-1]);
       			
        		// Calculate the wind direction based on these two angles
        		windDirection = getMeanAngle([newAngle,newAngleTwo]);
//       			System.println(windDirection+" "+newAngleTwo);
        		angleToWind = getSmallerAngle(windDirection,newAngleTwo);
        		if(angleToWind<0){
        			starboardAngle = newAngleTwo;
        			portAngle = newAngle;
        		}else{
        			starboardAngle = newAngle;
        			portAngle = newAngleTwo;
        		}
        		newAngle = null;
        		newAngleTwo = null;
        		Attention.vibrate(vibeObj);
        		
        		calibrateWindDirectionTwo = false;
        		calibrateWindDirectionTicker = 0;
        		calibrateWindDirection = false;
        		windDirectionChange = true;
        		
        		if(WatchUi has :ProgressBar){
        			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        		}
        	}
        	
        }
        // set wind direction and angle to wind
        if(windDirectionChange){
			windDirection = getMeanAngle([starboardAngle,portAngle]);
			angleToWind = getSmallerAngle(windDirection,portAngle);
		}
        
        // Starboard Port Array
        starboardPortFlag = (angleToWindArray[angleToWindArray.size()-1]>=0);
        if(starboardPortArray.size()==historySize){
        	starboardPortArray = starboardPortArray.slice(1, historySize);
        }
        starboardPortArray.add(starboardPortFlag);
        
        if(angleToWindArray.size()>10){
        	
        	// 5 out of 10 must belong to one tack
	        var counter = 0;
	        for(var i = 0; i<10;i++){
	        	if(starboardPortArray[starboardPortArray.size()-10+i]){
	        		counter++;
	        	}
	        }
	        if(counter==5&&maneuverTimer>=5){
		    	maneuverTimer = 0;
		    	maneuverFlag = true;
		    	upwindTicker = 0;
		    }
        	// add lap
        	if(maneuverFlag&&isFoiling){
        		maneuverCounter++;
	       		maneuverFlag = false;
	       		totalManeuverTime = 0;
	       		// Check if vmg was taken in the last 20 seconds
	       		if(recentVMGExpiry<=20){
	       			// Set last 20 seconds of the vmg array to zero
	       			VMGarray = VMGarray.slice(0,VMGarray.size()-20);
	       			for(var i = 0; i<20;i++){
	       				VMGarray.add(0);
	       			}
	       			// Get new recent vmg
	       			recentVMG = 0;
        			for(var i = 0; i < VMGarray.size();i++){
        				if(VMGarray[i]>recentVMG){
        					angleOfBestVMG = angleToWindArray[i];
        					recentVMG = VMGarray[i];
        					recentVMGExpiry = VMGarray.size() - i;
        				}
        			}
        		}
        		// count the number of isFoiling false in the past 20 seconds
	       		var countArray = speedArray.slice(speedArray.size()-20, speedArray.size());
	       		for(var i = 0;i<countArray.size();i++){
	       			if(countArray[i]<Settings.MinSpeedValue){
	       				totalManeuverTime++;
	       			}
	       		}
	       		// FIT session lap when complete maneuver
	       		mManeuverTimeField.setData(totalManeuverTime);
	       		mSession.addLap();
        	}
        }
        // Set Color Array
        if(trailColorArray.size()==historySize){
        	trailColorArray = trailColorArray.slice(1, historySize);
        }
        var color = 16;
        if(Settings.MapTrail==1){
        	// Calculate the color for the speed range
        	// Find the max speed
        	// Find the mean speed
        	var difference = (maxSpeed - Settings.MinSpeedValue)/colorsAvailable;
        	var currentDifference = currentSpeed - Settings.MinSpeedValue;
        	if(currentDifference<=0){
        		color = 0;
        	}else{
        		color = (currentDifference/difference).toNumber();
        	}
        }else if(Settings.MapTrail==2){
        	// Calculate the color for the vmg range
        	// How the find the min and max vmg?
        	// Find the mean vmg
        	var difference = (maxVMG-minVMG)/colorsAvailable;
        	var a = (currentVMG-minVMG)==0 ? 0.1 : (currentVMG-minVMG);
        	color = (a/difference).toNumber();
//        	System.println("currentVMG: " + currentVMG);
//        	System.println("maxVMG: " + maxVMG);
        }
        trailColorArray.add(color);
        // Set FITcontributor recording data
        mVMGField.setData(currentVMG);
        mAngleToWindField.setData(currentAngleToWind);
        mWindDirection.setData(windDirection);
        
        if(running){
        	mSeconds++;
        }
        
        gpsSeconds++;
    }
    
    function startStop(){
    	if(Settings.alerts){
    		Attention.vibrate(vibeObj);
    		if(Toybox.Attention has :playTone){
	    	    Attention.playTone(Attention.TONE_LOUD_BEEP);
	    	}
    	}
    	if(running){
    		running = false;
    		mSession.stop();
    	}else{
    		running = true;
    		mSession.start();
    	}
    }

    // Save the current session
    function save() {
    	mTotalManeuverField.setData(maneuverCounter);
    	running = false;
    	mSession.save();
    	Application.getApp().onExit();
    	
    }

    // Discard the current session
    function discard() {
    	running = false;
    	mSession.discard();
    	Application.getApp().onExit();
    }
    // The first angle is a, then it turns towards b
    function getSmallerAngle(a,b){
    	var c = a - b;
    	c = (c>180) ? 360-c : (c<-180) ? -360-c : -c;
    	return c;
    }
    // a is less than b
    function generateRandomData(a,b){
    	var rand = Math.rand()%(b-a);
    	rand = a + rand;
    	return rand;
    }

//	function velocity() {
////		System.println(getSmallerAngle(160,-160));
////		System.println(getSmallerAngle(-160,160));
////		System.println(getSmallerAngle(-170,-160));
////		System.println(getSmallerAngle(170,160));
////		System.println("");
//
////		headingArray = headingArray.slice(0, -1);
////        mAngleToWindField.setData(currentAngleToWind);
//        mSeconds++;
//    }
    
    function setCalibrateWindDirection(){
    	if(!calibrateWindDirection){
    		me.calibrateWindDirectionOne = true;
    	}else if(calibrateWindDirection){
    		calibrateWindDirectionTwo = true;
    	}
    }
    

    
    function getMeanAngle(anglesDeg){
    	var x = 0.0;
        var y = 0.0;
 
        for (var i = 0; i<anglesDeg.size();i++) {
            var angleR = Math.toRadians(anglesDeg[i]);
            x += Math.cos(angleR);
            y += Math.sin(angleR);
        }
        var avgR = Math.atan2(y / anglesDeg.size(), x / anglesDeg.size());
        return Math.toDegrees(avgR);
    }
	
}