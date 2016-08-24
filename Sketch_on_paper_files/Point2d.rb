#Copyright and Developed by P. Modely dp.model100.com 2016
 #Permission to use, copy, modify, and distribute this software for 
 #any purpose and without fee is hereby granted, provided that the above
 #copyright notice appear in all copies, and modified copies that work  are posted to the #SketchUp® Forum.
 #Creates CNC cutting for all the face in model to html pages.
#THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY WARRANTIES
#NO WARRANTY MEANS NO WARRANTY

class Point2d
def initialize(a,b)
@x=a
@y=b
end
def x
  return @x
end
def x=(value)
   @x = value
end
def y
  return @y
end
def y=(value)
   @y = value
end
def ConvertPoint3d
point=Geom::Point3d.new(@x,@y,0)
return point
end

end