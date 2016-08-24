#Copyright and Developed by P. Modely dp.model100.com 2016
 #Permission to use, copy, modify, and distribute this software for 
 #any purpose and without fee is hereby granted, provided that the above
 #copyright notice appear in all copies, and modified copies that work  are posted to the #SketchUp® Forum.
 #Creates CNC cutting for all the face in model to html pages.
#THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY WARRANTIES
#NO WARRANTY MEANS NO WARRANTY

require_relative './Point2d.rb'
require_relative './Math_Functions.rb'
require_relative './MyFace_Functions.rb'

class EveryFace
def initialize(face,id)
@Face=face
@Id=id
@IsPrint=false
@face_functions=MyFace.new
@Points3d=@face_functions.PointsFace(@Face)
@math=Math_Functions.new
@Points2d=@math.From_3d_To_2d(@Points3d)
@edges=face.edges
@EdgesPrint=Array.new
for edge in @edges
@EdgesPrint.push(0)
end
@min_x=0
@min_y=0
end

def EdgesPrintAdd(index,num)
@EdgesPrint[index]=num
end
def EdgesPrintGetItem(index)
return @EdgesPrint[index]
end

def Face
return @Face
end
def Id
return @Id
end
def IsPrint
return @IsPrint
end
def Points3d
return @Points3d
end
def Points3d=(values)
@Points3d=values
end
def Points2d
return @Points2d
end
def Points2d=(values)
@Points2d=values
end
def IsPrint=(bool)
@IsPrint=bool
end
def math
return @math
end
def face_functions
return @face_functions
end
def edges
return @edges
end
def trapeze(edge,status)
original_point1=edge.start.position
original_point2=edge.end.position
original_point1=math.ConvertPointTransformation(original_point1)
original_point2=math.ConvertPointTransformation(original_point2)
original_point1=MovePoint(original_point1,10)
original_point2=MovePoint(original_point2,10)
x=(original_point1.x*0.8+original_point2.x*0.2)
y=(original_point1.y*0.8+original_point2.y*0.2)
point1=Point2d.new(x,y)
x=(original_point1.x*0.2+original_point2.x*0.8)
y=(original_point1.y*0.2+original_point2.y*0.8)
point2=Point2d.new(x,y)
number=10
if(point1.x==point2.x)

point3=Point2d.new(point1.x+number,point1.y)
point4=Point2d.new(point2.x+number,point2.y)

point5=Point2d.new(point1.x-number,point1.y)
point6=Point2d.new(point2.x-number,point2.y)

elsif(point1.y==point2.y)
point3=Point2d.new(point1.x,point1.y+number)
point4=Point2d.new(point2.x,point2.y+number)
point5=Point2d.new(point1.x,point1.y-number)
point6=Point2d.new(point2.x,point2.y-number) 
 
else
a1=(point2.y-point1.y)/(point2.x-point1.x) 
b1=point1.y-(a1*point1.x)
point3=CaculationPoint(point1,a1,b1,number,1)
point4=CaculationPoint(point2,a1,b1,number,1)
point5=CaculationPoint(point1,a1,b1,number,2)
point6=CaculationPoint(point2,a1,b1,number,2)
end

points=Array.new
points.push(original_point2)
points.push(original_point1)
point3_3d=point3.ConvertPoint3d
points_polygon=Array.new

for point in @Points2d
if(point==" ")
break
else
points_polygon.push(point.ConvertPoint3d)
end

end
inside = Geom.point_in_polygon_2D(point3_3d, points_polygon,true)

if(inside==status)
points.push(point3)
points.push(point4)
else
points.push(point5)
points.push(point6)
end

return points
end

def CaculationPoint(point,a,b,number,status)

if(a==0)
a2=0
else
a2=-1/a
end
b2=point.y-(a2*point.x)
if(a!=0)
   if(status==1)
      x=(Math.sqrt(a*a+1)*number+b2-b)/(a-a2)
	else
	  x=(Math.sqrt(a*a+1)*number-b2+b)/(a2-a)
    end
y=a2*x+b2
else
x=0
y=0
end
point2d=Point2d.new(x,y)
return point2d
end
def PointsFace
  points=Array.new
  for loop in @Face.loops
    for ver in loop.vertices
	    points.push(ver.position)
	end
	points.push(" ")
  end
  return points
end
def PointsToStr(points,color)
  str_points=''  
  for point in points
  str_points=str_points+point.x.to_s+','+point.y.to_s+' '
  end
  str_points='<polygon points="'+ str_points+ '" style="fill:' +color+ ';stroke:black;stroke-width:0.5"  transform="scale(2.87, 2.87)" />'
 
  return str_points
end 
def MoveFace(points2d,number) 
  if(@min_x==0&&@min_y==0)
  points_x=Array.new
  points_y=Array.new
  for point in points2d.select{|item|" "!=item}
  points_x.push(point.x)
  points_y.push(point.y)
  end  
  @min_x=points_x.min
  @min_y=points_y.min
end  
 for point in points2d.select{|item|" "!=item}
 point.x=point.x+@min_x.abs+number
 point.y=point.y+@min_y.abs+number
 end
  return points2d
end
def MovePoint(point,number) 
 
 point.x=point.x+@min_x.abs+number
 point.y=point.y+@min_y.abs+number

  return point
end
def PrintShape(facescolor,holescolor)
  points_2d=MoveFace(@Points2d,10)
  str=''
  color=facescolor
  pointsLoop=Array.new
 for point in points_2d
  if (point!=" ")
  pointsLoop.push(point)
  else 
  str=str+'\n'+ PointsToStr(pointsLoop,color)
  color=holescolor
  pointsLoop.clear
  end 
 end

  return str
end
def PrintShapePoints(points,id)
  points_2d=MoveFace(points,10)
  str=''
  color=facescolor
  pointsLoop=Array.new
 for point in points
  if (point!=" ")
  pointsLoop.push(point)
  else 
  str=str+'\n'+ PointsToStr(pointsLoop,color)
  color=holescolor
  pointsLoop.clear
  end 
 end

  return str
end
def CenterPoint(points)
x=0
y=0
for point in points
x+=point.x
y+=point.y
end
x=x/points.count
y=y/points.count
center=Point2d.new(x,y)
return center
end
def PointsToStrText(points,color,id) 
  center=CenterPoint(points)
  str_points=''
  for point in points
  str_points=str_points+point.x.to_s+','+point.y.to_s+' '
  end
  colortext='black'
  if(color=='black')
  colortext='white'
  end
  str_points='<g transform="scale(2.87, 2.87)" > <polygon points="'+ str_points+ '" style="fill:' +color+ ';stroke:black;stroke-width:0.5">  </polygon>'
   str_points=str_points+'<text x="'+ center.x.to_s+'" y="'+ center.y.to_s+'" font-family="Arial" font-size="5" fill="'+colortext+'">'
  
  str_points+=id.to_s

  str_points+='</text> </g>'
  return str_points
end 
end
