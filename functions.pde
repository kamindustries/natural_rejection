///////////////////////////////////////////////////////////////////////
// Return ray
///////////////////////////////////////////////////////////////////////
// Ray3D PickRay(float[] _cam_pos){

//   PMatrix3D proj = p3d.projection.get();
//   PMatrix3D modvw = p3d.modelview.get();
//   PVector cam = new PVector(_cam_pos[0],_cam_pos[1],_cam_pos[2]);

//   // GluLookAt  ...
//   float x = 2* ((float)mouseX) / (float)width - 1;
//   float y = 2* ((float)height - (float)mouseY) / (float)height - 1;
//   float z = 1.0;
//   PVector vect = new PVector(x, y, z);
  
//   PVector transformVect = new PVector();
 
//   proj.apply(modvw);
//   proj.invert();
//   proj.mult(vect, transformVect);

//   stroke(200);

//   Ray3D ray = new Ray3D(new Vec3D(cam.x, cam.y, cam.z), 
//                         new Vec3D(transformVect.x,transformVect.y,transformVect.z));

//   return ray;
// }

///////////////////////////////////////////////////////////////////////
// Picking sphere
///////////////////////////////////////////////////////////////////////
// float IntersectSphere(Ray3D _r, PVector _cen, float _radius){

//   Vec3D _d = _r.getDirection();
//   PVector d = new PVector(_d.x, _d.y, _d.z);
//   PVector o = new PVector(_r.x, _r.y, _r.z);

//   PVector o_c = PVector.sub(o, _cen);
//   float a = d.dot(d);
//   float b = 2. * (d.dot(o_c));
//   float c = (o_c.dot(o_c)) - _radius * _radius;
//   float detect = b*b - 4*a*c;

//   if(detect > 0.0) {
//     float t1 = (-b - sqrt(detect)) / (2.0 * a);
//     if(t1 > 0.0) return t1;
//     float t2 = (-b + sqrt(detect)) / (2.0 * a);
//     if (t2 > 0.0) return t2;
//   }
//   else if (detect == 0.0) {
//     float t = -b / (2.0 * a);
//     if (t > 0.0) return t;
//   }

//   return 0.; //we ignore negative intersections, -1 qualifies as a miss
// }

// float LerpVal(float _value, float _dur){
//   int start = frameCount;
//   int finish = start + _dur;
//   float x = finish - 1
// }

// id 0 gives color -2, etc.
color getColor(int id) {
  return -(id + 2);
}
// color -2 gives 0, etc.
int getId(color c) {
  return -(c + 2);
}

///////////////////////////////////////////////////////////////////////
// K E Y B O A R D
///////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'h'){
    if (show_hud==true) show_hud=false;
    else if (show_hud==false) show_hud=true;
  }
  if (key == 'H'){
    if (show_fps==true) show_fps=false;
    else if (show_fps==false) show_fps=true;
  }
  if (key == ' '){
    camera_pos = cam.getPosition();
    camera_lookAt = cam.getLookAt();
    float cam_zoom = (float)cam.getDistance();
  
    PVector fix_zoom = new PVector(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
    PVector cam_pv = new PVector(camera_pos[0],camera_pos[1],camera_pos[2]);
  
    println("**************");
    println("cam pos: "+camera_pos[0]+", "+camera_pos[1]+", "+camera_pos[2]);
    println("lookat: "+camera_lookAt[0]+", "+camera_lookAt[1]+", "+camera_lookAt[2]);
    println("zoom: "+cam_zoom);
    println("");
  }
}

void mouseMoved() {
  // draw the scene in the buffer
  if (frameCount%1==0){
    buffer.beginDraw();
    buffer.background(getColor(-1)); // since background is not an object, its id is -1
    buffer.noFill();
    buffer.strokeWeight(10);
    buffer.setMatrix(p3d.camera);
    for (int i = 0; i < cubes.length; i++) {
      cubes[i].drawBuffer(buffer);
    }
    buffer.endDraw();
    // get the pixel color under the mouse
    color pick = buffer.get(mouseX, mouseY);
    // get object id
    int id = getId(pick);
    // if id > 0 (background id = -1)
    if (id >= 0) {
      Branch p = extinct_branches.get(id);
      display_name = p.name;
      extinct_picked[id] = 1;
      if (cubes[id].update == true) {
        println("got " + id);
        cubes[id].changeColor();
        update_cubes = true;
      }

    } else if (update_cubes == true) {
      for (int j = 0; j < cubes.length; j++) {
        if(cubes[j].update == true){ 
          cubes[j].resetColor();
          extinct_picked[j] = 0;
        }
        update_cubes = false;
      }
    }
  }
}

float LerpVal(){
  float x = 255 * random(0,frameCount)/(float)frameCount;
  return x;
}