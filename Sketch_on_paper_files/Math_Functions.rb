#Copyright and Developed by P. Modely dp.model100.com 2016
 #Permission to use, copy, modify, and distribute this software for 
 #any purpose and without fee is hereby granted, provided that the above
 #copyright notice appear in all copies, and modified copies that work  are posted to the #SketchUp® Forum.
 #Creates CNC cutting for all the face in model to html pages.
#THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY WARRANTIES
#NO WARRANTY MEANS NO WARRANTY

require_relative  './Point2d.rb'
class Math_Functions
def initialize
@e1=0
@e2=0
@Point_transformation=Array.new
end
def e1
return @e1
end
def e1=(value)
 @e1=value
end
def e2
return @e2
end
def e2=(value)
 @e2=value
end
def Point_transformation
return @Point_transformation
end
def Point_transformation=(value)
 for i in 0..value.count-1
  @Point_transformation[i]=value[i]
 end
end                            

def From_3d_To_2d(points3d)
t_points=TransformationToZero(points3d)
plane = Geom.fit_plane_to_points(t_points[0], t_points[1],t_points[2])
plane.pop
normal=plane
u1 = Geom::Point3d.new(t_points[1])
normal_plane = Geom.fit_plane_to_points(u1, Geom::Point3d.new, normal)
normal_plane.pop
u2=normal_plane
@e1=Geom::Point3d.new.vector_to(u1).normalize
@e2=u2.normalize
count=points3d.count
points2d=[]

for i in 0..count-1
points2d[i]=ConvertPoint(t_points[i])
end

return points2d
end

def TransformationToZero(points)
p=[]
for i in 0..2
p[i]=points[0][i]*(-1)
end
@Point_transformation=p
transformation=Geom::Transformation.new(p)
t_points= Array.new
for point in points
if (point!=" ")
 t_points.push(transformation*point)
 else t_points.push(" ")
 end
end
return t_points
end
 
 def Mul_Arrays(point,array)
 sum=0;
 for i in 0..2
   sum+=point[i]*array[i]
 end
return sum;
 end

def ConvertPoint(t_point)
if (t_point==" ")
return " "
else

x=Mul_Arrays(t_point,@e1)  
y=Mul_Arrays(t_point,@e2)
point=Point2d.new(x,y)

return point
end
end
def ConvertPointTransformation(t_point)
if (t_point==" ")
return " "
else
transformation=Geom::Transformation.new(@Point_transformation)
t_point=transformation*t_point
x=Mul_Arrays(t_point,@e1)  
y=Mul_Arrays(t_point,@e2)
point=Point2d.new(x,y)

return point
end
end
end


