///////////////////////////////////////////////////////////////////////
// P I C K I N G
///////////////////////////////////////////////////////////////////////
void Picking3D(int _autoMode){
  PVector cam_mouse = new PVector(cam.getPosition()[0],cam.getPosition()[1],cam.getPosition()[2]);
  // draw the scene in the buffer
  buffer.perspective(camera_fov, float(width)/float(height), 1/10.0, 10000.0);
  buffer.beginDraw();
  buffer.background(getColor(-1)); // since background is not an object, its id is -1
  // buffer.noFill();
  buffer.stroke(0,0,255);
  // buffer.pushMatrix();

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
  if (_autoMode == 0) {
    // get the pixel color under the mouse
    color pick = buffer.get(mouseX, mouseY);
    // get object id
    hover_id = getId(pick);
  }
  // if id > 0 (background id = -1)
  if (hover_id >= 0 && lock_selection==false) {
    selected_branch = extinct_branches.get(hover_id);
    extinct_picked[hover_id] = 1; //main control for hover
    update_text = false;

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
      update_text = false;
    }
  }
  if (hover_id == -1){
    update_text = true;
  }
}

///////////////////////////////////////////////////////////////////////
// K E Y B O A R D
///////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == '0'){
    if (DRAW_MAIN==true) DRAW_MAIN=false;
    else if (DRAW_MAIN==false) DRAW_MAIN=true;
  }
  if (key == '1'){
    if (DRAW_HALO==true) DRAW_HALO=false;
    else if (DRAW_HALO==false) DRAW_HALO=true;
  }
  if (key == '2'){
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
  if (key == 'c'){
    if (display_help_mouse==true) display_help_mouse=false;
    else if (display_help_mouse==false) display_help_mouse=true;
  }
  if (key == 'R'){
    GROW();
  }
  if (key == 't'){
    if (display_title==true) {
      title_display_time = 0;
      display_title = false;
    }
    else if (display_title==false){
      title_display_time = 1000000000;
      display_title = true;
    }
  }
  if (key == 'T'){
    if (hide_title==true) hide_title=false;
    else if (hide_title==false) hide_title=true;
  }
  if (key == '.'){
    int y = year();   // 2003, 2004, 2005, etc.
    int m = month();  // Values from 1 - 12
    int d = day();    // Values from 1 - 31
    int h = hour();    // Values from 0 - 23
    int i = minute();  // Values from 0 - 59
    int s = second();  // Values from 0 - 59
    String filename = "images/naturalreject."+y+m+d+"."+h+m+s+".png";
    saveFrame(filename);
  }
  if (key == '?'){
    if (display_help==1) display_help=0;
    else if (display_help==0) display_help=1;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      text_list_size += 1;
      if (text_list_size >= 15) text_list_size = 15;
      update_text = true;
      display_name = "updateme";
    } 
    if (keyCode == DOWN) {
      text_list_size -= 1;
      if (text_list_size <= 1) text_list_size = 1;
      update_text = true;
      display_name = "updateme";
    } 
  }
}

void mouseMoved() {
  camera_animate = 1;

  Picking3D(0);
}
void mousePressed(MouseEvent e) {
  camera_animate = 1;
  camera_autoBranch = null;

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
  camera_animate = 1;

  mouse_drag = true;
}
void mouseReleased(){
  camera_animate = 1;

  if (mouse_drag==false && hover_id==-1){
    lock_selection=false;
  }
  mouse_drag = false;
}


float EaseIn(float _value, float _target, float _speed){
  float x = _value;
  float d = _target - _value;
  x = d * _speed;
  return x;
}
float EaseIn2(float _value, float _target, float _speed){
  float x = _value;
  float d = _target - _value;
  x = d * _speed;
  return x;
}

// id 0 gives color -2, etc.
color getColor(int id) {
  return -(id + 2);
}
// color -2 gives 0, etc.
int getId(color c) {
  return -(c + 2);
}


///////////////////////////////////////////////////////////////////////
// A U T O   C A M E R A
///////////////////////////////////////////////////////////////////////
int camera_autoTimer = 1000; // how long to wait to trigger auto cam
float cam_speed = 0.002; // how fast the camera moves
int camera_autoUpdate = 1600; // how often to switch to a new branch

void AutoCamera(){

  if(camera_animate >= camera_autoTimer){ //timer for triggering auto mode

    float x_new = camera_pos[0];
    float y_new = camera_pos[1];
    float z_new = camera_pos[2];
    float cam_zoom = (float)cam.getDistance();
    float cen_x_new = camera_lookAt[0];
    float cen_y_new = camera_lookAt[1];
    float cen_z_new = camera_lookAt[2];
      
    // choose new branch when auto camera starts up
    if (camera_animate == camera_autoTimer){
      hover_id = -1;
      lock_selection = false;
      Picking3D(1);
      autoBranch_id = int(random(0,extinct_branches.size()));
      camera_autoBranch = extinct_branches.get(autoBranch_id);
      float [] random_negative = {1.,1.,1.}; 
      if ( random(0.,1.) <= 0.5) random_negative[0] = -1.;
      if ( random(0.,1.) <= 0.5) random_negative[1] = -1.;
      if ( random(0.,1.) <= 0.5) random_negative[2] = -1.;
      // range is from -1 to -0.2 and 0.2 to 1
      camera_autoRand = new PVector(random(.2,1.)*random_negative[0],
                                    random(.2,1.)*random_negative[1],
                                    random(.2,1.)*random_negative[2]);
      camera_autoRand.mult(500.0);
      camera_easeSpeed = 0;
    }

    // choose new branch again at specified increments
    if (camera_animate%camera_autoUpdate==0) {
      hover_id = -1;
      lock_selection = false;
      Picking3D(1);
      autoBranch_id = int(random(0,extinct_branches.size()));
      camera_autoBranch = extinct_branches.get(autoBranch_id);
      float [] random_negative = {1.,1.,1.};
      if ( random(0.,1.) <= 0.5) random_negative[0] = -1.;
      if ( random(0.,1.) <= 0.5) random_negative[1] = -1.;
      if ( random(0.,1.) <= 0.5) random_negative[2] = -1.;
      // range is from -1 to -0.5 and 0.5 to 1
      camera_autoRand = new PVector(random(.4,1.)*random_negative[0],
                                    random(.4,1.)*random_negative[1],
                                    random(.4,1.)*random_negative[2]);
      camera_autoRand.mult(500.0);
      camera_easeSpeed = 0;
    }
    // ease in current camera position to new camera position
    // also ease in the ease speed so there's an ease in + ease out
    x_new = camera_autoBranch.position.x;
    y_new = camera_autoBranch.position.y;
    z_new = camera_autoBranch.position.z;
    float x_pos_new = x_new+camera_autoRand.x;
    float y_pos_new = y_new+camera_autoRand.y;
    float z_pos_new = z_new+camera_autoRand.z;
    PVector new_pos = new PVector(x_pos_new,y_pos_new,z_pos_new);
    camera_easeSpeed += EaseIn(camera_easeSpeed, cam_speed, 0.005);
    camera_autoPos.x += EaseIn(camera_autoPos.x, x_pos_new, camera_easeSpeed);
    camera_autoPos.y += EaseIn(camera_autoPos.y, y_pos_new, camera_easeSpeed);
    camera_autoPos.z += EaseIn(camera_autoPos.z, z_pos_new, camera_easeSpeed);
    camera_autoCen.x += EaseIn(camera_autoCen.x, x_new, camera_easeSpeed);
    camera_autoCen.y += EaseIn(camera_autoCen.y, y_new, camera_easeSpeed);
    camera_autoCen.z += EaseIn(camera_autoCen.z, z_new, camera_easeSpeed);

    // ETA = distance from current camera position to target
    // if within range we highlight it and lock it off 
    float eta = PVector.sub(camera_autoPos,new_pos).mag();
    cam.setDistance(eta);
    if (eta <= 400) {
      hover_id = autoBranch_id;
      update_text = false;
      Picking3D(1);
      lock_selection = true; //lock selection after doing 3d picking
    }
    else {
      hover_id = -1;
      update_text = true;
      lock_selection = false;
      display_help = 0;
      Picking3D(1);
    }
    
    // move the camera to the right spot
    camera( camera_autoPos.x, camera_autoPos.y, camera_autoPos.z,
          camera_autoCen.x,camera_autoCen.y,camera_autoCen.z,
          0,1,0);
  }

  // when user triggers auto camera to turn off, we make peasycam look at the currently
  // selected branch from auto camera
  else if (camera_animate == 1 && camera_autoBranch != null) {
      float x_new = camera_autoBranch.position.x;
      float y_new = camera_autoBranch.position.y;
      float z_new = camera_autoBranch.position.z;
      cam.lookAt(x_new,y_new,z_new);
      display_help = 1;
      camera_autoBranch = null;
  }

  // increment camera animate
  camera_animate++;



}


float fade_length = 48;
///////////////////////////////////////////////////////////////////////
// F A D E   T O   A U T O C A M
///////////////////////////////////////////////////////////////////////
void FadeToAuto(){
  noStroke();
  // FADE OUT
  if(camera_animate > camera_autoTimer && camera_animate < camera_autoTimer+fade_length){
    float fade = (camera_animate - camera_autoTimer)/fade_length;
    pushMatrix();
      translate(camera_autoPos.x, camera_autoPos.y, camera_autoPos.z);
      fill(255,255-(fade*255.));
      box(2000,1100,2);
    popMatrix();
  }

  // FADE IN
  else if(camera_animate >= camera_autoTimer-fade_length && camera_animate <= camera_autoTimer){ 
    float fade = (camera_autoTimer - camera_animate)/fade_length;
    pushMatrix();
      translate(camera_pos[0], camera_pos[1], camera_pos[2]);
      fill(255,255-(fade*255.));
      box(2000,1100,2);
    popMatrix();
  }
}


