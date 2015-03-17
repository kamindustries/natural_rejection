void GROW() {
  tree_list.clear();
  tree_meshes.clear();
  extinct_branches.clear();
  extinct_meshes.clear();

  randomSeed(0);


  ///////////////////////////////////////////////////////////////////////
  // T R U N K 
  ///////////////////////////////////////////////////////////////////////
  
  float xml_timer = millis();
  PVector root_pos = new PVector(0.0, 0.0, 0.0);
  PVector trunk_pos = new PVector(0.0, branch_length/10.0, 0.0);
  // PVector init_grow_dir = new PVector(0.05, 1., 0.05);
  PVector init_grow_dir = new PVector(.7, -.3, 1.);
  root = new Branch(null, root_pos, init_grow_dir, 1, 0, "root");
  trunk = new Branch(null, trunk_pos, root.grow_dir, root.children, 0, "trunk");
  // tree_list.add(root);
  // tree_list.add(trunk);

  Branch current;
  current = new Branch(null, trunk.position, trunk.grow_dir, 1, trunk.depth, "trunk");

  // Draw a trunk
  for (int i = 0; i < 1; i++) {
    PVector new_pos = PVector.mult(root.grow_dir, branch_length/10.0);  
    new_pos.add(current.position);

    trunk = new Branch(null, new_pos, current.grow_dir, 1, current.depth, "trunk");
    current = trunk;

    // tree_list.add(trunk.parent);
    // tree_list.add(trunk);
    // println(trunk.position);
  }
  selected_branch = trunk;


  ///////////////////////////////////////////////////////////////////////
  // R E A D    X M L  
  ///////////////////////////////////////////////////////////////////////
  
  readChild(axiom, depth, trunk);

  // how long it took to go through the xml file
  xml_calc_time = (millis() - xml_timer)/1000.0;


  ///////////////////////////////////////////////////////////////////////
  // G E O M E T R Y
  ///////////////////////////////////////////////////////////////////////
  
  xml_timer = millis();

  // Calculate max depth of file
  max_depth = 0;
  for (int i = 0; i < tree_list.size(); i++) {
    Branch b0 = tree_list.get(i);
    if (max_depth<=b0.depth) {
      max_depth = b0.depth;
    }
  }

  tree_meshes.add(new PShape());
  tree_meshes.add(new PShape());

  // load meshes with vertex info.
  // colors based on age
  // also has option to make tips black (to scale later)
  for(int j = 0; j < tree_meshes.size(); j++) {

    PShape mesh = tree_meshes.get(j);
    mesh = createShape();
    mesh.beginShape(LINES);
    // if (DRAW_SKELETON==true){
      for (int i = 0; i < tree_list.size()-2; i+=2){
        Branch b0 = tree_list.get(i);
        Branch b1 = tree_list.get(i+1);

        // set up colors
        float grad0 = abs((1 - (b0.depth/(float)max_depth))) * 255;
        float grad1 = abs((1 - (b1.depth/(float)max_depth))) * 255;
        color c0 = color(grad0,grad0,grad0);
        color c1 = color(grad1,grad1,grad1);
        color cw = color(255,255,255);
        color cr = color(0,0,0);

        // if (b1.children == 0) { //turn tips black
        //   c1 = cr; 
        // }
        mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
        mesh.stroke(c1);
        mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
        mesh.stroke(c0);
      }
    // }

    mesh.endShape();
    tree_meshes.set(j, mesh);
  }
  geom_calc_time = (millis() - xml_timer)/1000.0;

  ///////////////////////////////////////////////////////////////////////
  // mesh containing EXTINCT species as vertex pts
  // also loads extinct arraylist containing appropriate number of pshapes
  ///////////////////////////////////////////////////////////////////////
  display_name = "";

  if (extinct_branches.size()>0){
    int num_extinct_points = extinct_branches.size();
    cubes = new Cube[num_extinct_points];
    extinct_names = new String[num_extinct_points];
    extinct_picked = new int[num_extinct_points];
    fade_val = new float[num_extinct_points];
    fade_val_a = new float[num_extinct_points];
    extinct_rand_vec3 = new PVector[num_extinct_points];

    extinct_points = createShape();
    extinct_points.beginShape(POINTS);
    extinct_points.strokeWeight(10);
      // extinct_points.stroke(255,0,0);

      for (int i = 0; i < num_extinct_points; i++){
        Branch p = extinct_branches.get(i);
        extinct_points.vertex(p.position.x, p.position.y, p.position.z); 
        extinct_points.stroke(255,0,0);
        extinct_names[i] = p.name;
        extinct_picked[i] = 0;
        fade_val[i] = 0.0;
        fade_val_a[i] = 0.1;
        extinct_rand_vec3[i] = new PVector(random(0.,1.),random(0.,1.),random(0.,1.)) ;
        
        cubes[i] = new Cube(i, p.position.x, p.position.y, p.position.z, 5 + (int)random(15), true);
      }

    extinct_points.endShape();

    for (int i = 0; i < extinct_points.getVertexCount(); i++) {
      extinct_meshes.add(new PShape());
    }
  }

  ///////////////////////////////////////////////////////////////////////
  // D R A W   E X T I N C T   C U R V E S
  ///////////////////////////////////////////////////////////////////////
  for (int i = 0; i < extinct_meshes.size(); i++){
    float j = 0;
    if (j >= max_depth) j = max_depth;
    
    Branch p = extinct_branches.get(i);
    
    // set up colors
    float c_rand = random(10,50);    
    float grad0 = abs((1 - (j/(1.+(float)p.depth)))) * 255;
    color c0 = color(c_rand,c_rand,c_rand);
    color cw = color(255,255,255);
    color cr = color(0,0,0);


    PShape mesh = extinct_meshes.get(i);
    mesh = createShape();
    mesh.beginShape();
    mesh.noFill();
    // extinct_points.strokeWeight(10);
    // mesh.curveTightness(1.);

    // mesh.curveVertex(p.position.x, p.position.y, p.position.z);
    mesh.vertex(p.position.x, p.position.y, p.position.z);
    mesh.stroke(c0);

      while (p != null) {
        if (j>=max_depth) j=max_depth-1;
        // j = (max_depth - j) / (float)max_depth;
        // j *= 10.;
        float j_scale = (max_depth - j) / (float)max_depth;
        j_scale *= 10.;
        if (j<1){ 
          // j_scale = 1. / (float)max_depth;
          j_scale = 0.;
        }
        PVector o = p.position;
        PVector r = new PVector(random(-1.,1.), random(-1.,1.), random(-1.,1.));
        // r.add(o);
        // r.normalize();

        // r.mult(spare_slider7);
        // r.mult((j_scale) / (float)max_depth);
        // float angle = (2 * PI * (j/(float)max_depth));
        float angle1 = random(0,2*PI);
        float angle2 = random(0,2*PI);
        PVector inv_grow_dir = PVector.mult(p.grow_dir, -1.0);
        r.add(inv_grow_dir);
        r.normalize();
        PVector green_vector = inv_grow_dir.cross(r);
        PVector y_vector = green_vector.cross(inv_grow_dir);
        float dot = green_vector.dot(inv_grow_dir);
        PVector grow_dir_scaled = PVector.mult(inv_grow_dir, dot);

        PVector rot_cos = PVector.mult(green_vector, cos(angle1));
        PVector rot_sin = PVector.mult(y_vector, sin(angle2));
        PVector new_angle = PVector.add(rot_cos, rot_sin);
        // new_angle.add(grow_dir_scaled);
        // new_angle.normalize();
        // new_angle.mult(j_scale * spare_slider6 * .1);
        // o.add(new_angle);
        new_angle.mult(spare_slider6 * j_scale);
        // y_vector.mult(spare_slider6);
        
        PVector new_offset = new PVector(random(-.5,.5), random(-.5,.5), random(-.5,.5));
        // new_offset.mult(4.0/(float)j_scale);
        new_offset.mult(spare_slider7 * j_scale * random(0.2,1.));

        // o.add(new_angle);
        o.add(new_offset);



        if (p.parent == null) {
          // green_vector.normalize();
          // green_vector.cross(o);
          // green_vector.mult(j_scale * spare_slider6 * 1.0);
          // green_vector.mult(j_scale * spare_slider6 * 1.);
          // r.mult(40.);
          // o.add(r);
          // o.add(green_vector);
          // o.add(r);

          mesh.curveVertex(o.x, o.y, o.z);
          mesh.stroke(c0);
          mesh.curveVertex(o.x, o.y, o.z);
          mesh.stroke(c0);
          break;
        }
        else {
          // green_vector.normalize();
          // green_vector.mult(j_scale * spare_slider6);
          // o.add(r);
          // o.add(green_vector);
          // o.add(r);

          mesh.curveVertex(o.x, o.y, o.z);
          mesh.stroke(c0);
          
          p = p.parent;
        }
        j++;
      }
    mesh.endShape();
    extinct_meshes.set(i, mesh);
  }
}