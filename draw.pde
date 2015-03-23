void draw() {
  
  perspective(camera_fov, float(width)/float(height), 1/10.0, 10000.0);
  hint(ENABLE_DEPTH_TEST);
  background(bg_color);
  blendMode(BLEND);

  

  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  push_back[0]=camera_pos[0]-camera_lookAt[0];
  push_back[1]=camera_pos[1]-camera_lookAt[1];
  push_back[2]=camera_pos[2]-camera_lookAt[2];
  mouseXY[0] = mouseX;
  mouseXY[1] = mouseY;

  float cam_zoom = (float)cam.getDistance();
  halo_displ = cam_zoom * spare_slider1;
  
  AutoCamera();

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  // textFont(font1);

  s+=(0.02*spare_slider13);

  // if (FULL_TREE==false){
    if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    if (frameCount%24==0) lineShader3 = loadShader("linefrag_skel.glsl", "linevert_skel.glsl");
    if (frameCount%24==0) pointShader = new PShader(this, "point_vert.glsl", "point_frag.glsl");
  // }
  if (DRAW_MAIN){
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
      c = pow(c, 4);
      if (c <= 0.001) c = 0.001;
      if (c >= 1.0) c = 1.0;
      clr_red[0] = ((base_cR + (c*spare_slider8) + rnd.x)/(2+spare_slider11))*gain;
      clr_red[1] = ((base_cG + (c*spare_slider9) + rnd.y)/(2+spare_slider11))*gain;
      clr_red[2] = ((base_cB + (c*spare_slider10)+ rnd.z)/(2+spare_slider11))*gain;

      lineShader.set("stroke_color", clr_red);
      lineShader.set("alpha", fade_val_a);

      // HOVER MODS
      if (extinct_picked[i] == 1) {
        fade_val[i] += EaseIn(fade_val[i], hover_max, ease_speed);
        fade_val_a[i] += EaseIn(fade_val_a[i], 2., ease_speed);

        if (fade_val[i] >= hover_max*.98) fade_val[i] = hover_max;
        if (fade_val[i] <= 0.05) fade_val[i] = 0.0;

        clr_red[0] += fade_val[i] * 0.5 * clr_red[0]; //makes hover color mostly red
        clr_red[1] += fade_val[i] * 0.5 * clr_red[1];         
        clr_red[2] += fade_val[i] * 0.5 * clr_red[2]; 
        if (clr_red[0]>=1) clr_red[0] = 1.;
        if (clr_red[1]>=1) clr_red[1] = 1.;
        if (clr_red[2]>=1) clr_red[2] = 1.;

        float w = (float)spare_slider2 * (fade_val[i]+1.);
        
        lineShader.set("stroke_color", clr_red);
        lineShader.set("stroke_weight", w);
        lineShader.set("alpha", fade_val_a[i]);
      }

      else {
        // FADE OUT
        if (fade_val[i] > 0) {
          fade_val[i] += EaseIn(fade_val[i], 0., ease_speed);
        }
        if (fade_val_a[i] > 0) {
          if (lock_selection==true || hover_id > 0) {
            update_text = false;
            fade_val_a[i] += EaseIn(fade_val_a[i], .07, ease_speed);
          }
          else fade_val_a[i] += EaseIn(fade_val_a[i], 1., ease_speed);
        }

        if (fade_val[i] <= 0.01) fade_val[i] = 0.0;
        if (fade_val_a[i] <= 0.01) fade_val_a[i] = 0.0;
        float ease_out_color = fade_val[i] - EaseIn(fade_val[i], c, ease_speed);
        float ease_out_pt_color = fade_val[i];

        clr_red[0] += ease_out_color * 0.5 * clr_red[0]; 
        clr_red[1] += ease_out_color * 0.5 * clr_red[1];
        clr_red[2] += ease_out_color * 0.5 * clr_red[2];
        if (clr_red[0]<=0) clr_red[0] = 0.;
        if (clr_red[1]<=0) clr_red[1] = 0.;
        if (clr_red[2]<=0) clr_red[2] = 0.;
        
        float w = (float)spare_slider2 * (fade_val[i]+1.);
        
        // if (lock_selection==true || hover_id >= 0) a = (fade_val[i]*.5)+.0;
        // else if (fade_val[i]<=.05 && hover_id <0) a += EaseIn(fade_val[i]*.5, .3, ease_speed);

        lineShader.set("stroke_color", clr_red);
        lineShader.set("stroke_weight", w);
        lineShader.set("alpha", fade_val_a[i]);
      }

      shader(lineShader, LINES);
      // shader(pointShader, POINTS);
      shape(extinct_meshes.get(i));

      // PVector extinct_vertex = extinct_points.getVertex(i);
      // shader(pointShader, POINTS);
      // point(extinct_vertex.x,extinct_vertex.y,extinct_vertex.z);
    }
  }
    if (DRAW_SKELETON == true){
      // resetShader();
      shader(lineShader3, LINES);
      shape(tree_meshes.get(0));
    }

    if (DRAW_HALO==true){
      shader(lineShader2, LINES);
      for (int i = 0; i < extinct_meshes.size(); i++) {
        shape(extinct_meshes.get(i));
      }
    }
  
  // Pick ray tests
  if (extinct_branches.size()>0){
      
    // display "cubes"- the things resolving the 3D picking
    // for (int i = 0; i < cubes.length; i++) {
    //   cubes[i].display(this.g);
    // }

    shader(pointShader, POINTS);
    stroke(0);
    shape(extinct_points);
  }

  resetShader();
  resetShader(LINES);
  resetShader(POINTS);

  // box at orgin...for debugging stuff
  // box(10); 

  drawGUI();
  
  if (show_hud==true){
    textFont(font2);
    text(frameRate, width - 70, marginY);
  }
}