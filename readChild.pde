void readChild(XML[] _parent, int _depth, Branch _branch) {
  Branch branch = _branch;    //the incoming parent branch
  int current_depth = _depth;

  float current_branch_length = (branch_length/float(current_depth+1));
  if (current_branch_length >= branch_length/4.0){ 
    current_branch_length = current_branch_length/4.0;
  }
  if (current_branch_length <= 20){
    current_branch_length = 20;
  }
  String path = "NODES/NODE";
  String spacing = " ";
  String stars = "**********";
  String dash = "----------";

  // Create printing cues based on depth
  for (int i = 0; i < current_depth; i++) {
    spacing += "  ";
    stars += "**";
    dash += "--";
  }

  if (PRINT_INFO == true){
    println("parent.parent pos:"+branch.parent.position);
    println("parent pos:"+branch.position);
    // println(stars + " d: " + current_depth);
  }

  ///////////////////////////////////////////////////////////////////////
  // Prep work to make vectors rotate around grow direction like a tripod
  ///////////////////////////////////////////////////////////////////////

  // Spread controls how wide the new branches fan out from the parent
  // The more children it has, the less spread it will have. Limited to
  // a certain range to give good results. **MAKE MIN/MAX EDITABLE**
  float spread = 1/(float(branch.children)-1);
  if (spread > 1.0) spread = spare_slider4;
  if (spread < 0.03) spread = spare_slider5;
  spread = spread * 1.0;

  // Create a random vector to compare to
  PVector rand_vec = new PVector(random(-1,1), random(-1,1), random(-1,1));
  rand_vec.mult(1.0);
  PVector init_grow_dir = PVector.add(branch.grow_dir, rand_vec);
  init_grow_dir.normalize();

  // get perpendicular angle to grow direction, normalize and scale
  // scaling eventually achieves the cone radius of the new branches 
  // cross_p = angle(cone) tangent ("green vector")
  // tan1 = rotational tangent ("yellow vector")

  // PVector cross_p = branch.grow_dir.cross(rand_vec);
  PVector cross_p = branch.grow_dir.cross(init_grow_dir);
  // cross_p.normalize();
  // cross_p.mult(spare_slider6/100.0);

  // add original growing dir with scaled cross product
  // PVector initial_grow_dir = PVector.add(branch.grow_dir, cross_p);

  // get final variables lined up to prepare to rotate around grow dir vector
  PVector tan1 = init_grow_dir.cross(cross_p);
  // PVector tan1 = initial_grow_dir.cross(branch.grow_dir);
  // PVector tan2 = tan1.cross(branch.grow_dir);
  // float dot = initial_grow_dir.dot(branch.grow_dir);
  float dot = init_grow_dir.dot(branch.grow_dir);
  PVector len = PVector.mult(branch.grow_dir, dot);

  Branch p = branch.parent;
  int offset_scale = current_depth;

  // go down the tree to the root adding more branches
  // stochastically

  // float rand_foo = random(1.0);
  // if (branch.children == 0 && rand_foo < 0.001) {
  //   while (p != null) {
  //     // if (p.parent != null) {
  //     if (p.parent == null) {
  //       break;
  //     } else {
  //       PVector offset = new PVector(random(-1,1), random(-1,1), random(-1,1));
  //       offset.mult(4.0/(float)offset_scale);
  //       PVector offset2 = PVector.mult(offset, 0.5);


  //       PVector pos = PVector.add(p.position, offset2);
  //       PVector pos2 = PVector.add(p.parent.position, offset);
  //       Branch extra1 = new Branch(null, pos, p.grow_dir, 0);
  //       Branch extra2 = new Branch(null, pos2, p.grow_dir, 0);
  //       tree_list.add(extra1);
  //       tree_list.add(extra2);
  //       offset_scale--;
  //       p = p.parent;
  //     }
  //   }
  // }


  ///////////////////////////////////////////////////////////////////////
  // Begin calculating new branches
  ///////////////////////////////////////////////////////////////////////

  for (int i = 0; i < _parent.length; i++) {

    ///////////////////////////////////////////////////////////////////////
    // XML stuff to debug. Gets data of all immediate children
    // Not necessary to draw tree
    ///////////////////////////////////////////////////////////////////////
    XML[] children =  _parent[i].getChildren(path);
    int id = _parent[i].getInt("ID");
    int extinct = _parent[i].getInt("EXTINCT");
    XML _name = _parent[i].getChild("NAME");  
    String name = _name.getContent();
    if (name == "") name = "[no name]";

    if (PRINT_INFO == true){
      println(spacing + "Name: " + name + ", " + children.length + ", " + id);
    }

    ///////////////////////////////////////////////////////////////////////
    // Math it up
    ///////////////////////////////////////////////////////////////////////
    
    // float rot = cos(spare_slider6*PI*i/(float)_parent.length);
    float angle = PI * i/(float)_parent.length;
    // PVector tan2_rotate = PVector.mult(tan2,rot);
    PVector rot_cos = PVector.mult(tan1, cos(angle));
    PVector rot_sin = PVector.mult(cross_p, sin(angle));
    PVector new_grow_dir = PVector.add(rot_cos, rot_sin);
    new_grow_dir.add(len);
    
    // new_grow_dir = initial_grow_dir;
    // new_grow_dir.normalize();


    PVector new_pos = PVector.mult(new_grow_dir, current_branch_length);  
    new_pos.add(branch.position);
    // println("newpos:"+new_pos);

    Branch next_branch = new Branch(_branch, new_pos, new_grow_dir, children.length, current_depth);
    

    tree_list.add(branch);
    tree_list.add(next_branch);
    

    ///////////////////////////////////////////////////////////////////////
    // Burrow deeper into the tree
    ///////////////////////////////////////////////////////////////////////

    // if (children.length > 0) {

      // Print all the child names under current node as a kind of preview
      // println(dash);
      // int child_count = 0;
      // for (int j = 0; j < children.length; j++) {
      //   XML _child_name = children[j].getChild("NAME");
      //   String child_name = _child_name.getContent();
      //   if (child_name == "") child_name = "[no_name]";
      //   child_count = children[j].getInt("CHILDCOUNT");

      // println(spacing + child_name + ", " + child_count);
      // }
      

      ///////////////////////////////////////////////////////////////////////
      // Begin recrusive loop
      ///////////////////////////////////////////////////////////////////////
      readChild(children, current_depth+1, next_branch);

    // }
  }
  // println(stars);
  // println("");
}