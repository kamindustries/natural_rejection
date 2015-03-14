void draw() {

  background(255);
  blendMode(BLEND);
  
  ///////////////////////////////////////////////////////////////////////
  // RE DRAW EVERY  F R A M E
  ///////////////////////////////////////////////////////////////////////
  if (FULL_TREE==false){
    if (frameCount%24==0) {
      // GROW();
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

  s+=0.04;

  if (FULL_TREE==false){
    if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    lineShader.set("stroke_weight", (float)spare_slider2);
    lineShader.set("stroke_color", stroke_black);
    lineShader.set("push", 0);
    lineShader.set("render_solid", 0);
    lineShader2.set("stroke_weight", (float)spare_slider3);
    lineShader2.set("stroke_color", stroke_white);
    lineShader2.set("push", spare_slider1);
    lineShader2.set("render_solid", 1);
  
    shader(lineShader, LINES);
    for (int i = 0; i < extinct_meshes.size(); i++) {
      float f = i/(float)extinct_meshes.size();
      float c = (sin(s + (f * PI * 2.)) + 1.) * 0.5  ;
      if (c <= 0.05) c = 0.05;
      c = c*c;
      stroke_red[0] = c;
      lineShader.set("stroke_color", stroke_red);
      if (extinct_picked[i] == 1) {
        lineShader.set("stroke_color", stroke_green);
        lineShader.set("stroke_weight", 8.);
      }
      else {
        lineShader.set("stroke_weight", (float)spare_slider2);
      }
      // if (i == 100) lineShader.set("stroke_color", stroke_red);
      // else lineShader.set("stroke_color", stroke_black);
      shape(extinct_meshes.get(i));
    }
    if (DRAW_SKELETON == true){
      shape(tree_meshes.get(0));
    }

    // shader(lineShader2, LINES);
    // for (int i = 0; i < extinct_meshes.size(); i++) {
    //   shape(extinct_meshes.get(i));
    // }
  }
  else {
    lineShader.set("stroke_weight", (float)spare_slider2);
    shader(lineShader, LINES);
    
    for (int i = 0; i < extinct_meshes.size(); i++) {
      
      // AMBIENT COLOR CYCLING
      float f = i/(float)extinct_meshes.size();
      float c = (sin(s + (f * PI * 2.)) + 1.) * 0.5  ;
      if (c <= 0.05) c = 0.05;
      c = c*c;
      stroke_red[0] = c;
      lineShader.set("stroke_color", stroke_red);

      // HOVER MODS
      if (extinct_picked[i] == 1) {
        lineShader.set("stroke_color", stroke_green);
        lineShader.set("stroke_weight", 8.);
      }
      else {
        lineShader.set("stroke_weight", (float)spare_slider2);
      }
      shape(extinct_meshes.get(i));
    }

    // lineShader2.set("stroke_weight", (float)spare_slider3);
    // shader(lineShader2, LINES);
    // for (int i = 0; i < extinct_meshes.size(); i++) {
    //   shape(extinct_meshes.get(i));
    // }
  }

  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider2);
  //   lineShader.set("stroke_color", stroke_black);
  //   shader(lineShader, LINES);
  //   shape(tree_meshes.get(0));
  // popMatrix();
  
  // noFill();
  
  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider3);
  //   lineShader.set("stroke_color", stroke_white);
  //   shader(lineShader, LINES);    
  //   translate(push_back[0]/halo_displ, push_back[1]/halo_displ, push_back[2]/halo_displ);
  //   shape(tree_meshes.get(1));
  // popMatrix();

    resetShader();
    resetShader(LINES);
    resetShader(POINTS);

  // Pick ray tests
  if (extinct_branches.size()>0){

    shader(pointShader, POINTS);
    shape(extinct_points);

    // for (int i = 0; i < extinct_branches.size(); i++){
    // shape(extinct_points);
      // Branch p = extinct_branches.get(i);
      // point(p.position.x,p.position.y,p.position.z);

    // Ray3D r = PickRay(camera_pos);

    // }

    float radius = 10.0;

    // for (int i = 0; i < extinct_points.getVertexCount(); i++) {

      // strokeWeight(10);
      // shader(pointShader, POINTS);
      // cubes[i].display(this.g);

      // PVector origin = new PVector(0.0,0.0,0.0);
      // PVector cam_lookat_pv = new PVector(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
      // PVector cam_pv = new PVector(camera_pos[0],camera_pos[1],camera_pos[2]);
  
      // PVector cen = extinct_points.getVertex(i);
      // PVector cen2 = extinct_points.getVertex(i);
      // PVector cen_orig = extinct_points.getVertex(i);
      
      // cen.sub(origin);
      // cen.normalize();
      // cen.mult(sqrt(sqrt(cam_zoom)));
      // cen.add(cen_orig);

      // cen2.sub(cam_lookat_pv);
      // cen2.normalize();
      // cen2.mult(sqrt(cam_zoom) * 1.);
      // cen.add(cen2);

      // cam_lookat_pv.add(cen);
      // cam_lookat_pv.normalize();
      // cam_lookat_pv.mult(sqrt(cam_zoom) * -1.0);
      // cen.add(cam_lookat_pv); //fix for peasycam "zoom"


      ///////////////////////////////////////////////////////////////////////
      // do intersection calculation
      ///////////////////////////////////////////////////////////////////////
    //   float f = IntersectSphere(r, cen, radius);

    //   // If hovering, do something
    //   if (f > 0.0) {
    //     hover[i] = f;
    //     fill(0,255,0);
    //     text("cool", cen_orig.x, cen_orig.y + 10, cen_orig.z + 5);
    //     if (frameCount%15==0) {
    //       println("**************");
    //       println("cen orig: "+cen_orig);
    //       println("cen: "+cen);
    //       println("cam pos: "+camera_pos[0]+", "+camera_pos[1]+", "+camera_pos[2]);
    //       println("lookat: "+camera_lookAt[0]+", "+camera_lookAt[1]+", "+camera_lookAt[2]);
    //       println("zoom: "+cam_zoom);
    //       println("");
    //     }
    //   }
    //   if (f <= 0.0) hover[i] = 0.0;
    // }
  }
  // resetShader();
  // resetShader(LINES);
  // resetShader(POINTS);

  box(10); 

  // pushMatrix();
  //   noFill();
  //   translate(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
  //   box(5);
  // popMatrix();

  drawGUI();
  
  if (show_fps==true){
    textFont(font2);
    text(frameRate, width - 70, marginY);
  }
}