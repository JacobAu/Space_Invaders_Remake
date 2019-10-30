unit
class shooter
    inherit superClass in "superClass.t"

    var pic1 : int := Pic.FileNew ("player.bmp")
    var sprite1 : int := Sprite.New (pic1)
    var centered : boolean := true

    body proc draw
	Sprite.SetPosition (sprite1, centreX, centreY, centered)
	Sprite.SetHeight (sprite1, 2)
	Sprite.Show (sprite1)
    end draw

end shooter
