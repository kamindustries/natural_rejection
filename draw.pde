void draw() {

  background(255);
  
  ///////////////////////////////////////////////////////////////////////
  // RE DRAW EVERY  F R A M E
  ///////////////////////////////////////////////////////////////////////
  if (FULL_TREE==false){
    if (frameCount%24==0) {
      GROW();
    }
  }

  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  push_back[0]=camera_pos[0]-camera_lookAt[0];
  push_back[1]=camera_pos[1]-camera_lookAt[1];
  push_back[2]=camera_pos[2]-camera_lookAt[2];
  
  float cam_zoom = (float)cam.getDistance();
  halo_displ = cam_zoom * spare_slider1;

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  textFont(font1);

  if (FULL_TREE==false){
    if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    lineShader.set("stroke_weight", (float)spare_slider2);
    lineShader.set("stroke_color", stroke_red);
    lineShader.set("stroke_weight", (float)spare_slider3);
    lineShader.set("stroke_color", stroke_white);
    lineShader.set("push", spare_slider1);
    }

  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider2);
  //   lineShader.set("stroke_color", stroke_black);
  //   shader(lineShader, LINES);
  //   shape(tree_meshes.get(0));
  // popMatrix();
  
  // noFill();
  box(10); 
  
  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider3);
  //   lineShader.set("stroke_color", stroke_white);
  //   shader(lineShader, LINES);    
  //   translate(push_back[0]/halo_displ, push_back[1]/halo_displ, push_back[2]/halo_displ);
  //   shape(tree_meshes.get(1));
  // popMatrix();

  pushMatrix();
    // lineShader.set("stroke_weight", (float)spare_slider2);
    // lineShader.set("stroke_color", stroke_red);
    shader(lineShader, LINES);
    for (int i = 0; i < extinct_meshes.size(); i++) {
      shape(extinct_meshes.get(i));
    }
  popMatrix();

  pushMatrix();
    // lineShader.set("stroke_weight", (float)spare_slider3);
    // lineShader.set("stroke_color", stroke_white);
    // lineShader.set("push", spare_slider1);
    shader(lineShader2, LINES);
    // translate(push_back[0]/halo_displ, push_back[1]/halo_displ, push_back[2]/halo_displ);
    for (int i = 0; i < extinct_meshes.size(); i++) {
      shape(extinct_meshes.get(i));
    }
  popMatrix();

  resetShader();

  // // Pick ray tests
  // if (extinct_branches.size()>0){
  //   shape(extinct_points);

  //   Ray3D r = PickRay(camera_pos);
  //   float radius = 10.0;

  //   for (int i = 0; i < extinct_points.getVertexCount(); i++) {
  //     PVector cen = extinct_points.getVertex(i);
  //     PVector cen_orig = extinct_points.getVertex(i);
  //     PVector fix_zoom = new PVector(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
  //     fix_zoom.sub(cen);
  //     fix_zoom.normalize();
  //     fix_zoom.mult(sqrt(cam_zoom) * -1.0);
  //     cen.add(fix_zoom); //fix for peasycam "zoom"

  //     ///////////////////////////////////////////////////////////////////////
  //     // do intersection calculation
  //     ///////////////////////////////////////////////////////////////////////
  //     float f = IntersectSphere(r, cen, radius);

  //     // If hovering, do something
  //     if (f > 0.0) {
  //       hover[i] = f;
  //       fill(0,255,0);
  //       text("cool", cen_orig.x, cen_orig.y + 10, cen_orig.z + 5);
  //     }
  //     if (f <= 0.0) hover[i] = 0.0;
  //   }
  // }


    drawGUI();
  
  if (show_fps==true){
    textFont(font2);
    text(frameRate, width - 70, marginY);
  }
}