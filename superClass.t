unit 
    class superClass 
    export getCentreX,getCentreY,centrePos,draw,getSpeed,erase,pelletMove,
    pelletTrue,getPelletStatus,switchPelletBoolean,alienPelletMove,
    resetPelletBoolean,getAlienPelletSpeed, setAlienPelletSpeed 
    
    var centreX,centreY,speed,col  : int
    var alienPelletSpeed : int := 10
    var pelletTrue : boolean := false 
    col := white
    speed := 12
    centreX := 0
    centreY := 0
    
    
    proc switchPelletBoolean 
	if pelletTrue = true then
	    pelletTrue := false 
	else 
	    pelletTrue := true 
	end if 
    end switchPelletBoolean 
    
    proc resetPelletBoolean 
	pelletTrue := false 
    end resetPelletBoolean 
    
    function getPelletStatus : boolean 
	result pelletTrue
    end getPelletStatus 
    
    deferred proc draw
    proc erase 
	col := black
	draw 
	col := white
    end erase 
    function getCentreX : int 
	result centreX
    end getCentreX  
    
    function getCentreY : int
	result centreY 
    end getCentreY 
    
    proc centrePos (x,y :int) 
	centreX := x
	centreY := y 
    end centrePos 
    
    proc pelletMove 
	centreY += speed
    end pelletMove 
    
    
    proc alienPelletMove 
	centreY -= alienPelletSpeed 
    end alienPelletMove
    
    proc setAlienPelletSpeed (s : int)
	alienPelletSpeed := s 
    end setAlienPelletSpeed 
	
    function getAlienPelletSpeed :int 
	result alienPelletSpeed
    end getAlienPelletSpeed 
    function getSpeed : int 
	result speed 
    end getSpeed 
    
end superClass 
    
