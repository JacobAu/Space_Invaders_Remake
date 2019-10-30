unit 
class ghost 
inherit superClass in "superClass.t"

var pic1 : int := Pic.FileNew("villain_3.bmp")

body proc draw 
    Pic.Draw(pic1, centreX,centreY, picCopy)
end draw

end ghost
