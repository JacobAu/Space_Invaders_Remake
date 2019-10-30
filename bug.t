unit 
class bug 
inherit superClass in "superClass.t"

var pic1 : int := Pic.FileNew("villain_2.bmp")

body proc draw 
    Pic.Draw(pic1, centreX,centreY, picCopy)
end draw

end bug
