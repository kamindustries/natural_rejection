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
  if (key == '1'){
    if (DRAW_MAIN==true) DRAW_MAIN=false;
    else if (DRAW_MAIN==false) DRAW_MAIN=true;
  }
  if (key == '2'){
    if (DRAW_HALO==true) DRAW_HALO=false;
    else if (DRAW_HALO==false) DRAW_HALO=true;
  }
  if (key == '3'){
    if (DRAW_SKELETON==true) DRAW_SKELETON=false;
    else if (DRAW_SKELETON==false) DRAW_SKELETON=true;
  }
  if (key == 'H'){
    if (show_hud==true) show_hud=false;
    else if (show_hud==false) show_hud=true;
  }
  if (key == 'h'){
    if (show_text==true) {
      show_text=false;
    }
    else if (show_text==false) {
      show_text=true;
    }
  }
  if (key == ' '){
    GROW();
  }
  if (key == 't'){
    if (display_title==true) {
      title_display_time = 0;
      display_title = false;
      println("display title true, display text=0");
      println(title_fade);
    }
    else if (display_title==false){
      title_display_time = 1000000000;
      display_title = true;
      println("display title true, display text=100000000");
      println(title_fade);
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      text_list_size += 1;
      if (text_list_size >= 20) text_list_size = 20;
      update_text = true;
    } 
    if (keyCode == DOWN) {
      text_list_size -= 1;
      if (text_list_size <= 1) text_list_size = 1;
      update_text = true;
    } 
  }
}

void mouseMoved() {
  ///////////////////////////////////////////////////////////////////////
  // P I C K I N G
  ///////////////////////////////////////////////////////////////////////
  // draw the scene in the buffer

  PVector cam_mouse = new PVector(cam.getPosition()[0],cam.getPosition()[1],cam.getPosition()[2]);
  buffer.beginDraw();
  buffer.background(getColor(-1)); // since background is not an object, its id is -1
  // buffer.noFill();
  buffer.stroke(0,0,255);
  buffer.setMatrix(p3d.camera);
  for (int i = 0; i < cubes.length; i++) {
    PVector pos = new PVector(cubes[i].x, cubes[i].y, cubes[i].z);
    pos.sub(cam_mouse);
    float cam_stroke =  (1./pos.mag());
    cam_stroke *= 10000.;
    buffer.strokeWeight(cam_stroke);
    cubes[i].drawBuffer(buffer);
  }

  buffer.endDraw();
  // get the pixel color under the mouse
  color pick = buffer.get(mouseX, mouseY);
  // get object id
  hover_id = getId(pick);
  // if id > 0 (background id = -1)
  if (hover_id >= 0 && lock_selection==false) {
    selected_branch = extinct_branches.get(hover_id);
    extinct_picked[hover_id] = 1; //main control for hover

    if (cubes[hover_id].update == true) {
      // println("got " + hover_id);
      cubes[hover_id].changeColor();
      update_cubes = true;
    }
  } else if (update_cubes == true && lock_selection==false) {
    for (int j = 0; j < cubes.length; j++) {
      if(cubes[j].update == true){ 
        cubes[j].resetColor();
        extinct_picked[j] = 0; //main control for hover
      }
      update_cubes = false;
    }
  }
}
void mousePressed(MouseEvent e) {
  if (e.getClickCount()==1 && hover_id >= 0){
    if (lock_selection==true) lock_selection=false;
    else if (lock_selection==false) lock_selection=true;
  }
  if (e.getClickCount()==2){
    Branch b = selected_branch;
    cam.lookAt(b.position.x,b.position.y,b.position.z);
    cam.setDistance(100);
    if (lock_selection==true) lock_selection=false;
    else if (lock_selection==false) lock_selection=true;
  }

}
void mouseDragged(){
  mouse_drag = true;
}
void mouseReleased(){
  if (mouse_drag==false && hover_id==-1){
    lock_selection=false;
  }
  mouse_drag = false;
}
// float LerpVal(){
//   float x = 255 * random(0,frameCount)/(float)frameCount;
//   return x;
// }

float EaseIn(float _value, float _target, float _speed){
  float x = _value;
  float d = _target - _value;
  x = d * _speed;
  return x;
}
float EaseIn2(float _value, float _target, float _speed){
  float x = _value;
  float d = abs(_target - _value);
  x = d * _speed;
  return x;
}