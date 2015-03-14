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
  PVector init_grow_dir = new PVector(0.05, 1., 0.05);
  root = new Branch(null, root_pos, init_grow_dir, 1, 0);
  trunk = new Branch(null, trunk_pos, root.grow_dir, root.children, 0);
  // tree_list.add(root);
  // tree_list.add(trunk);

  Branch current;
  current = new Branch(null, trunk.position, trunk.grow_dir, 1, trunk.depth);

  // Draw a trunk
  for (int i = 0; i < 1; i++) {
    PVector new_pos = PVector.mult(root.grow_dir, branch_length/10.0);  
    new_pos.add(current.position);

    trunk = new Branch(null, new_pos, current.grow_dir, 1, current.depth);
    current = trunk;

    // tree_list.add(trunk.parent);
    // tree_list.add(trunk);
    // println(trunk.position);
  }


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
  // need to do some smart coloration based on age
  for(int j = 0; j < tree_meshes.size(); j++) {

    PShape mesh = tree_meshes.get(j);
    mesh = createShape();
    mesh.beginShape(LINES);
    if (DRAW_SKELETON==true){
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

        if (b1.children == 0) {
          c1 = cr; 
        }
        mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
        mesh.stroke(c1);
        mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
        mesh.stroke(c0);
      }
    }

    mesh.endShape();
    tree_meshes.set(j, mesh);
  }
  geom_calc_time = (millis() - xml_timer)/1000.0;

  ///////////////////////////////////////////////////////////////////////
  // mesh containing extinct species as vertex pts
  // also loads extinct arraylist containing appropriate number of pshapes
  ///////////////////////////////////////////////////////////////////////
  if (extinct_branches.size()>0){
    Branch p = extinct_branches.get(400);
    int num_extinct_points = extinct_branches.size();
    float scatter = 300.0;
    
    extinct_points = createShape();
    extinct_points.beginShape(POINTS);
      extinct_points.strokeWeight(8);
      extinct_points.stroke(255,0,0);
      for (int i = 0; i < num_extinct_points; i++){
        Branch ex = extinct_branches.get(i);
        extinct_points.vertex(ex.position.x, ex.position.y, ex.position.z); 
      }
    extinct_points.endShape();
    hover = new float[num_extinct_points];

    for (int i = 0; i < extinct_points.getVertexCount(); i++) {
      extinct_meshes.add(new PShape());
    }
  }

  ///////////////////////////////////////////////////////////////////////
  // D R A W   E X T I N C T   C U R V E S
  ///////////////////////////////////////////////////////////////////////
  for (int i = 0; i < extinct_meshes.size(); i++){
    float j = 1;
    
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
    // mesh.curveTightness(spare_slider9);
    mesh.curveTightness(-.25);

    mesh.curveVertex(p.position.x, p.position.y, p.position.z);
    mesh.stroke(c0);

      while (p != null) {

        j = (max_depth - j) / (float)max_depth;
        j *= 10.;

        PVector o = p.position;
        PVector r = new PVector(random(-1.,1.), random(-1.,1.), random(-1.,1.));
        r.mult(j * spare_slider8 / 100.0);

        if (p.parent == null) {
          PVector perp_vector = p.grow_dir.cross(r);
          perp_vector.mult(j * spare_slider7 * 0.2);
          r.mult(40.);
          o.add(r);
          // o.add(perp_vector);

          mesh.curveVertex(o.x, o.y, o.z);
          mesh.stroke(c0);
          mesh.curveVertex(o.x, o.y, o.z);
          mesh.stroke(c0);

          break;
        }
        else {
          PVector perp_vector = p.grow_dir.cross(r);
          perp_vector.mult(j * spare_slider7);
          o.add(r);
          o.add(perp_vector);
          
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