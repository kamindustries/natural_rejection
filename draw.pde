void draw() {
  // recalculate every frame
  // PShape tree_mesh0;
  // PShape tree_mesh1;
  // tree_list = new ArrayList<Branch>();
  // tree_meshes = new ArrayList<PShape>();


  ///////////////////////////////////////////////////////////////////////
  // RE DRAW EVERY F R A M E
  ///////////////////////////////////////////////////////////////////////
  
  if (frameCount%24==0) {
    tree_list.clear();
    tree_meshes.clear();
    GROW();
  }

  background(25);
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  zoom = (float)cam.getDistance() * spare_slider1;
  push_back[0]=camera_pos[0]-camera_lookAt[0];
  push_back[1]=camera_pos[1]-camera_lookAt[1];
  push_back[2]=camera_pos[2]-camera_lookAt[2];

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  textFont(font1);


  pushMatrix();
    if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    lineShader.set("stroke_weight", (float)spare_slider2);
    lineShader.set("stroke_color", 0.0);
    shader(lineShader, LINES);
    shape(tree_meshes.get(0));
  popMatrix();
  
  pushMatrix();
    if (frameCount%24==0) lineShader2 = loadShader("linefrag.glsl", "linevert.glsl");
    lineShader2.set("stroke_weight", (float)spare_slider3);
    lineShader2.set("stroke_color", 1.0);
    shader(lineShader2, LINES);    
    translate(push_back[0] / zoom, push_back[1] / zoom, push_back[2] / zoom);
    shape(tree_meshes.get(1));
  popMatrix();

  // for (int i = 1; i < tree_list.size(); i++){
  //   Branch b1 = tree_list.get(i);
  //   Branch b0 = b1.parent;

  //   strokeWeight(1);
  //   stroke(25,0,0);
  //   // line(b0.position.x, b0.position.y, b0.position.z, b1.position.x, b1.position.y, b1.position.z);

  //   strokeWeight(4);
  //   stroke(255,0,0);
  //   // point(b0.position.x, b0.position.y, b0.position.z);

  //   fill(0);
  //   // text(i, b0.position.x+10, b0.position.y, b0.position.z);
  //   // println(b0.position);
  // }

  noFill();
  box(10);
  resetShader();

  
  // if (frameCount%24==0) println(frameRate);
  // if (frameCount%24==0) println(zoom);

  drawGUI();
  textFont(font2);
  text(frameRate, width - 70, marginY);
}