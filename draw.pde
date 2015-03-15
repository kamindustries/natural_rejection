void draw() {

  background(bg_color);
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
  mouseXY[0] = mouseX;
  mouseXY[1] = mouseY;
  
  float cam_zoom = (float)cam.getDistance();
  halo_displ = cam_zoom * spare_slider1;

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  textFont(font1);

  s+=0.02;

  if (FULL_TREE==false){

    if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    if (frameCount%24==0) pointShader = new PShader(this, "point_vert.glsl", "point_frag.glsl");
    lineShader.set("stroke_weight", (float)spare_slider2);
    lineShader.set("stroke_color", clr_black);
    lineShader.set("push", 0);
    lineShader.set("render_solid", 0);
    lineShader.set("alpha", 1.);
    lineShader2.set("stroke_weight", (float)spare_slider3);
    lineShader2.set("stroke_color", clr_white);
    lineShader2.set("push", spare_slider1);
    lineShader2.set("render_solid", 1);
    lineShader2.set("alpha", 1.);
    pointShader.set("mouse", mouseXY);
    pointShader.set("weight", .8);
  
    for (int i = 0; i < extinct_meshes.size(); i++) {
      
      // AMBIENT COLOR CYCLING
      PVector rnd = new PVector(extinct_rand_vec3[i].x,extinct_rand_vec3[i].y,extinct_rand_vec3[i].z);
      rnd.mult(spare_slider11);

      float f = i/(float)extinct_meshes.size();
      float c = (sin(s + (f * PI * 2.)) + 1.) * 0.5  ;
      if (c <= 0.05) c = 0.05;
      c = c*c;
      clr_red[0] = (c * 1.0 * spare_slider8) + rnd.x;
      clr_red[1] = (c * 1.0 * spare_slider9) + rnd.y;
      clr_red[2] = (c * 1.0 * spare_slider10)+ rnd.z;
      
      lineShader.set("stroke_color", clr_red);
      lineShader.set("alpha", fade_val_a);

      // HOVER MODS
      if (extinct_picked[i] == 1) {
        fade_val[i] += EaseIn(fade_val[i], hover_max, ease_speed);
        fade_val_a[i] += EaseIn(fade_val_a[i], 1., ease_speed);

        if (fade_val[i] >= hover_max*.98) fade_val[i] = hover_max;
        if (fade_val[i] <= 0.05) fade_val[i] = 0.0;

        clr_red[0] += fade_val[i] * 0.5 * spare_slider8;
        clr_red[1] += fade_val[i] * 0.5 * spare_slider9;
        clr_red[2] += fade_val[i] * 0.5 * spare_slider10;
        if (clr_red[0]>=1) clr_red[0] = 1.;

        float w = (float)spare_slider2 * (fade_val[i]+1.);
        
        // if (lock_selection==true) {
        //   a += EaseIn(fade_val[i]*.5, 1., ease_speed);
        // }

        lineShader.set("stroke_color", clr_red);
        lineShader.set("stroke_weight", w);
        lineShader.set("alpha", fade_val_a[i]);
      }
      else {

        if (fade_val[i] > 0) {
          fade_val[i] += EaseIn(fade_val[i], 0., ease_speed);
        }
        if (fade_val_a[i] > 0) {
          if (lock_selection==true || hover_id > 0) {
            fade_val_a[i] += EaseIn(fade_val_a[i], .1, ease_speed);
          }
          else fade_val_a[i] += EaseIn(fade_val_a[i], .55, ease_speed);
        }

        if (fade_val[i] <= 0.05) fade_val[i] = 0.0;
        if (fade_val_a[i] <= 0.05) fade_val_a[i] = 0.0;
        float ease_out_color = fade_val[i] - EaseIn(fade_val[i], c, ease_speed);
        float ease_out_pt_color = fade_val[i];

        clr_red[0] += ease_out_color * 0.5 * spare_slider8;
        clr_red[1] += ease_out_color * 0.5 * spare_slider9;
        clr_red[2] += ease_out_color * 0.5 * spare_slider10;
        if (clr_red[0]<=0) clr_red[0] = 0.;
        
        float w = (float)spare_slider2 * (fade_val[i]+1.);
        
        // if (lock_selection==true || hover_id >= 0) a = (fade_val[i]*.5)+.0;
        // else if (fade_val[i]<=.05 && hover_id <0) a += EaseIn(fade_val[i]*.5, .3, ease_speed);

        lineShader.set("stroke_color", clr_red);
        lineShader.set("stroke_weight", w);
        lineShader.set("alpha", fade_val_a[i]);
      }

      shader(lineShader, LINES);
      shape(extinct_meshes.get(i));

      // PVector extinct_vertex = extinct_points.getVertex(i);
      // shader(pointShader, POINTS);
      // point(extinct_vertex.x,extinct_vertex.y,extinct_vertex.z);
    }
    if (DRAW_SKELETON == true){
      shape(tree_meshes.get(0));
    }

    if (DRAW_HALO==true){
      shader(lineShader2, LINES);
      for (int i = 0; i < extinct_meshes.size(); i++) {
        shape(extinct_meshes.get(i));
      }
    }
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
      clr_red[0] = c;
      lineShader.set("stroke_color", clr_red);

      // HOVER MODS
      if (extinct_picked[i] == 1) {
        lineShader.set("stroke_color", clr_green);
        lineShader.set("stroke_weight", 2.);

        pointShader.set("stroke_color", clr_green);
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
  //   lineShader.set("stroke_color", clr_black);
  //   shader(lineShader, LINES);
  //   shape(tree_meshes.get(0));
  // popMatrix();
  
  // noFill();
  
  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider3);
  //   lineShader.set("stroke_color", clr_white);
  //   shader(lineShader, LINES);    
  //   translate(push_back[0]/halo_displ, push_back[1]/halo_displ, push_back[2]/halo_displ);
  //   shape(tree_meshes.get(1));
  // popMatrix();

    // resetShader();
    // resetShader(LINES);
    // resetShader(POINTS);

  // Pick ray tests
  if (extinct_branches.size()>0){
    
    // for (int i = 0; i < cubes.length; i++) {
    //   cubes[i].display(this.g);
    // }
    ///////////////// turn this back on /////////////////
    ///////////////// turn this back on /////////////////

    shader(pointShader, POINTS);
    stroke(0);
    shape(extinct_points);

    // for (int i = 0; i < extinct_branches.size(); i++){
    // shape(extinct_points);
      // Branch p = extinct_branches.get(i);
      // point(p.position.x,p.position.y,p.position.z);

    // Ray3D r = PickRay(camera_pos);

    // }

    float radius = 10.0;

    // shader(pointShader, POINTS);

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
  resetShader();
  resetShader(LINES);
  resetShader(POINTS);

  box(10); 

  // pushMatrix();
  //   noFill();
  //   translate(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
  //   box(5);
  // popMatrix();

  drawGUI();
  
  if (show_hud==true){
    textFont(font2);
    text(frameRate, width - 70, marginY);
  }
}