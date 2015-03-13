void GROW() {
  tree_list.clear();
  tree_meshes.clear();

  randomSeed(0);
  ///////////////////////////////////////////////////////////////////////
  // Trunk Geometry 
  ///////////////////////////////////////////////////////////////////////
  float xml_timer = millis();
  PVector root_pos = new PVector(0.0, 0.0, 0.0);
  PVector trunk_pos = new PVector(0.0, branch_length/10.0, 0.0);
  PVector init_grow_dir = new PVector(0.05, 1., 0.05);
  root = new Branch(null, root_pos, init_grow_dir, 1, 0);
  trunk = new Branch(root, trunk_pos, root.grow_dir, root.children, 0);
  // tree_list.add(root);
  // tree_list.add(trunk);

  Branch current;
  current = new Branch(trunk, trunk.position, trunk.grow_dir, 1, trunk.depth);

  // Draw a trunk
  for (int i = 0; i < 1; i++) {
    PVector new_pos = PVector.mult(root.grow_dir, branch_length/10.0);  
    new_pos.add(current.position);

    trunk = new Branch(current, new_pos, current.grow_dir, 1, current.depth);
    current = trunk;

    // tree_list.add(trunk.parent);
    // tree_list.add(trunk);
    // println(trunk.position);
  }


  ///////////////////////////////////////////////////////////////////////
  // R E A D    X M L  
  ///////////////////////////////////////////////////////////////////////
  readChild(axiom, depth, trunk);

  // Print results
  // println("Done with readChild");
  // println("tree_list size: " + tree_list.size());
  // println("max depth: "+max_depth);

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
  // println("max depth: "+max_depth);

  // depth_array = new int[0];

  tree_meshes.add(new PShape());
  tree_meshes.add(new PShape());

  // load meshes with vertex info.
  // need to do some smart coloration based on age
  for(int j = 0; j < tree_meshes.size(); j++) {

    PShape mesh = tree_meshes.get(j);
    mesh = createShape();
    mesh.beginShape(LINES);

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

        // make second mesh all white
        // if (j == 1) {
        //   c0 = cw;
        //   c1 = cw;
        // }

        // specific termination color
        // if (b1.children > 0){
        //   mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
        //   mesh.stroke(c1);
        //   mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
        //   mesh.stroke(c0);
        // } 
        // else {
        //   mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
        //   mesh.stroke(cr);
        //   // mesh.stroke(c1);
        //   mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
        //   mesh.stroke(c0);
        // }
      }
    mesh.endShape();
    tree_meshes.set(j, mesh);
  }
  geom_calc_time = (millis() - xml_timer)/1000.0;
}