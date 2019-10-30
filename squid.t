unit 
class squid
inherit superClass in "superClass.t"

var pic2 : int := Pic.FileNew ("villain_1.bmp")
var pic3 : int := Pic.FileNew ("villain_1b.bmp")

body proc draw 
    Pic.Draw(pic2, centreX,centreY, picCopy)
end draw

end squid


