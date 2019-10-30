unit
    class pellet 
    inherit superClass in "superClass.t"
    centreX := 0
    centreY := 0 
    col := white
    body proc draw
	Draw.FillBox(centreX-1,centreY-5,centreX+1,centreY+5,col)
    end draw
    end pellet 
    
