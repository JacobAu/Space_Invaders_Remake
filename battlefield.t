unit
class battlefield
    import squid in "squid.t", bug in "bug.t", ghost in "ghost.t"
    export setCentre, drawAlien,getAlienType,getAlienStatus,switchAlienStatus
    var squid1 : ^squid
    new squid1
    var bug1 : ^bug
    new bug1
    var ghost1 : ^ghost
    new ghost1
    var alienType := 0 
    var alienStatus : boolean := true 
    
    function getAlienStatus :boolean 
	result alienStatus 
    end getAlienStatus 
    proc switchAlienStatus
	alienStatus := false 
    end switchAlienStatus 
    
    proc setCentre (x, y, t : int)
	^squid1.centrePos (x, y)
	^bug1.centrePos (x, y)
	^ghost1.centrePos (x, y)
	alienType := t
    end setCentre

    function getAlienType :int 
	result alienType 
    end getAlienType
    
    proc drawAlien
	if alienType = 1 then
	    ^ghost1.draw
	elsif alienType = 2 then
	    ^bug1.draw
	elsif alienType = 3 then
	    ^squid1.draw
	end if
    end drawAlien
    
    
end battlefield
