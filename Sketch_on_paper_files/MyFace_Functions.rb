#Copyright and Developed by P. Modely dp.model100.com 2016
 #Permission to use, copy, modify, and distribute this software for 
 #any purpose and without fee is hereby granted, provided that the above
 #copyright notice appear in all copies, and modified copies that work  are posted to the #SketchUp® Forum.
 #Creates CNC cutting for all the face in model to html pages.
#THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY WARRANTIES
#NO WARRANTY MEANS NO WARRANTY

require_relative './Point2d.rb'
require_relative './Math_Functions.rb'

class MyFace 
   def initialize
   @min_x=0
   @min_y=0
   end

  def PointsFace(face)
  points=Array.new
  for loop in face.loops
    for ver in loop.vertices
	    points.push(ver.position)
	end
	points.push(" ")
  end
  return points
  end
  
  def PrintShape(face,id)
    points=PointsFace(face)
  math=Math_Functions.new
  points2d=math.From_3d_To_2d(points)
  points2d=MoveFace(points2d,100)
  str=''
  color='lightgray'
  pointsLoop=Array.new
  for point in points2d
  if (point!=" ")
  pointsLoop.push(point)
  else 
  str=str+'\n'+ PointsToStr(pointsLoop,color)
  color='white'
  pointsLoop.clear
  end 
  end
  return str
  end

  def PointsToStr(points,color)
  str_points=''  
  for point in points
  str_points=str_points+point.x.to_s+','+point.y.to_s+' '
  end
  str_points='<polygon points="'+ str_points+ '" style="fill:' +color+ ';stroke:black;stroke-width:2" />'
 
  return str_points
  end 
  def CenterPoint(points)
  count=points.count
  x=(points[0].x+points[count/2].x)/2
  y=(points[0].y+points[count/2].y)/2
  point2d=Point2d.new(x,y)
  
  return point2d
  end 
  def PointsToStrText(points,color,id)
  str_points='<g>' 
  for point in points
  str_points=str_points+point.x.to_s+','+point.y.to_s+' '
  end
  center=CenterPoint(points)
  str_points='<polygon points="'+ str_points+ '" style="fill:' +color+ ';stroke:black;stroke-width:2" />'
  return str_points
  end 

  def MoveFace(points2d,number) 
  if(@min_x=0)
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
  
  end
