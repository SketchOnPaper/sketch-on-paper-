#Copyright and Developed by P. Modely dp.model100.com 2016
 #Permission to use, copy, modify, and distribute this software for 
 #any purpose and without fee is hereby granted, provided that the above
 #copyright notice appear in all copies, and modified copies that work  are posted to the #SketchUp® Forum.
 #Creates CNC cutting for all the face in model to html pages.
#THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY WARRANTIES
#NO WARRANTY MEANS NO WARRANTY

require_relative './Sketch_on_paper_files/MyFace_Functions.rb'
require_relative './Sketch_on_paper_files/Math_Functions.rb'
require_relative './Sketch_on_paper_files/EveryFace.rb'


tool_menu = UI.menu("File")
tool_menu.add_item("Sketch on paper"){ 
 prompts = ["Folder Name", "Faces Color", "Holes Color"]
 defaults = ["sketch on paper1", "lightgray", "white"]
 list = ["", "brown|yellow|green|blue|pink|red|white|black|lightblue|gray|violet|wheat", "white|black|lightblue|gray"]
 results = UI.inputbox(prompts, defaults, list, "Select your preferences")
   FolderName, FacesColor, HolesColor = results
 
 directory_name = FolderName
 Dir.mkdir(directory_name) unless File.exists?(directory_name)
    model = Sketchup.active_model
    entities = model.active_entities    
    faces=entities.select{|item|"Face"==item.typename}
	  i=1
   allfaces=Array.new

   for face in faces
   f=EveryFace.new(face,i)
   allfaces.push(f)
    i=i+1
   end
   
   countnum=faces.count

 i=1 
 m=1
  
 for face in allfaces 
 
  str='<HTML><body  onload="print();">'
   str=str+'<svg height="3000" width="3000" >' 
   out_file = File.new("#{directory_name}/Face#{i}.html", "w")
   str_face=face.PrintShape(FacesColor,HolesColor)
   for edge in face.edges
	  for near_face in edge.faces
	   if(near_face!=face.Face)
	       for j in 0..allfaces.count
             if(near_face==allfaces[j].Face)
              break
              end
           end
		   face2=allfaces[j]
		    for c1 in 0..face.edges.count-1
			if(edge==face.edges[c1])
			  break
			end
			end		
	        for c2 in 0..face2.edges.count-1
			if(edge==face2.edges[c2])
			
              break
			end
			end
		   if(face.EdgesPrintGetItem(c1)==0)
			  state=false
			 else state=true
            end
			if(face.EdgesPrintGetItem(c1)==0)
			    face.EdgesPrintAdd(c1,m)
				face2.EdgesPrintAdd(c2,m)
			end
			m=m+1
	        points=face.trapeze(edge,state)
			str_t=face.PointsToStrText(points,FacesColor,face.EdgesPrintGetItem(c1)) 
            str_face=str_face+str_t
	
		end    
   	  end

   end
    str=str+str_face+'</svg>'+'</body></html>'
  out_file.puts(str) 
  out_file.close
  i=i+1
  end
  
    index_file = File.new("#{directory_name}/index.html", "w")

strindex=''
strindex='<!DOCTYPE html>'

strindex=strindex+'<html xmlns="http://www.w3.org/1999/xhtml">'

strindex=strindex+'<head>'
strindex=strindex+'    <title></title>'

strindex=strindex+'    <script type="text/javascript">'

strindex=strindex+'        function printA(num) {'

strindex=strindex+'            for (i=1;i<=num;i++)'
strindex=strindex+'            {'

strindex=strindex+'                var a = "<p><a href=''''face" + i + ".html'''' target=''''iframe_a''''>face" + i + "</a></p>";'

strindex=strindex+'                document.getElementById("myFaces").innerHTML += a;'
strindex=strindex+'            }'
strindex=strindex+'        }'
strindex=strindex+'    </script>'
strindex=strindex+'</head>'
strindex=strindex+'<body dir="rtl" onload="printA('+countnum.to_s+')">'
strindex=strindex+'    <header><img src="C:\Users\User\AppData\Roaming\SketchUp\SketchUp%202015\SketchUp\Plugins\Sketch_on_paper_files\logo.png" style="width: 200px; height: 300px; float: left" />'
strindex=strindex+'    <h1 style=" text-align: center;font-style:italic; font-size:500%">'+FolderName+'</h1>'
strindex=strindex+'    </header>'
strindex=strindex+'    <div style="clear:both"></div>'
strindex=strindex+'    <div id="myFaces" style="width: 20%; float: right;left:30px;text-align:center"></div>'
strindex=strindex+'    <iframe src="" name="iframe_a" style="width:900px;height:600px;float:right;stroke:blue;" ></iframe>'
strindex=strindex+'    <div style="width:60%;float:right"></div>'
strindex=strindex+'</body>'
strindex=strindex+'</html>'
 index_file.puts(strindex) 
  index_file.close
  UI.messagebox(" Your model is ready !")	
  UI.openURL("file:///C:/Users/User/Documents/"+FolderName+"/index.html")
}

     