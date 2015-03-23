void readChild(XML[] _parent, int _depth, Branch _branch) {
  Branch branch = _branch;    //the incoming parent branch
  int current_depth = _depth;
  int num_branches = _parent.length;

  float current_branch_length = branch_length*((1+max_depth-current_depth)/((float)max_depth+1.));
  current_branch_length *= .2;

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
  if (spread > 1.0) spread = 1.0;
  if (spread < 0.03) spread = .03;
  spread = spread * 0.015;

  // Create a random vector to compare to
  PVector rand_vec = new PVector(random(-1,1), random(-1,1), random(-1,1));
  rand_vec.mult(spread);
  PVector init_grow_dir = PVector.add(branch.grow_dir, rand_vec);
  init_grow_dir.normalize();

  // get perpendicular angle to grow direction, normalize and scale
  // scaling eventually achieves the cone radius of the new branches 
  // cross_p = angle(cone) tangent ("green vector")
  // tan1 = rotational tangent ("yellow vector")

  PVector perp_vector = branch.grow_dir.cross(rand_vec);
  init_grow_dir.add(perp_vector);
  PVector cross_p = branch.grow_dir.cross(init_grow_dir);
  
  float perturb = _parent.length;
  if (current_depth == 0) perturb = 20;
  if (perturb >= 20) perturb = 5;
  if (perturb <= 2) perturb = 2;
  perturb *= perturb*0.5;
  float perturb_grad = current_depth/((float)max_depth+1);
  if(perturb_grad >= .8) perturb_grad = .8; //clamp angle falloff with generation

  perturb *= perturb_grad;
  perturb *= spare_slider5 * 0.1;
  
  cross_p.mult(perturb);

  // add original growing dir with scaled cross product
  // PVector initial_grow_dir = PVector.add(branch.grow_dir, cross_p);

  // get final variables lined up to prepare to rotate around grow dir vector
  PVector tan1 = init_grow_dir.cross(cross_p);
  float dot = init_grow_dir.dot(branch.grow_dir);
  PVector len = PVector.mult(branch.grow_dir, dot);
  len.mult(spare_slider4 * .1 * ((current_depth+1.)/(float)max_depth));


  
  ///////////////////////////////////////////////////////////////////////
  // Begin calculating new branches
  ///////////////////////////////////////////////////////////////////////

  for (int i = 0; i < _parent.length; i++) {

    ///////////////////////////////////////////////////////////////////////
    // XML stuff Gets data of all immediate children
    ///////////////////////////////////////////////////////////////////////
    XML[] children =  _parent[i].getChildren(path);
    int id = _parent[i].getInt("ID");
    int extinct = _parent[i].getInt("EXTINCT");
    XML _name = _parent[i].getChild("NAME");  
    String name = _name.getContent();
    String tmp_name = _name.getContent();
    if (tmp_name == "") tmp_name = "[no name]";

    if (PRINT_INFO == true){
      println(spacing + "Name: " + tmp_name + ", " + children.length + ", " + id);
    }

    ///////////////////////////////////////////////////////////////////////
    // Math it up
    ///////////////////////////////////////////////////////////////////////
    
    // float rot = cos(spare_slider6*PI*i/(float)_parent.length);
    float angle = (2 * PI * (i/(float)_parent.length));
    // PVector tan2_rotate = PVector.mult(tan2,rot);
    float rand_scale = .25;
    PVector rot_cos = PVector.mult(tan1, cos(angle + random(-rand_scale, rand_scale)));
    PVector rot_sin = PVector.mult(cross_p, sin(angle + random(-rand_scale, rand_scale)));
    PVector new_grow_dir = PVector.add(rot_cos, rot_sin);
    new_grow_dir.add(len);
    new_grow_dir.normalize();
    float cd = current_depth + 3.0;
    if (cd >= max_depth) cd = max_depth-3; //max length multiplier
    if (max_depth - cd <= 10) cd = 10; //min length multiplier
    new_grow_dir.mult(((max_depth - cd)/(float)max_depth)*spare_slider12);
        

    PVector new_pos = PVector.mult(new_grow_dir, current_branch_length);  
    new_pos.add(branch.position);
    // println("newpos:"+new_pos);

    Branch next_branch = new Branch(_branch, new_pos, new_grow_dir, children.length, current_depth, name);
    
    tree_list.add(branch);
    tree_list.add(next_branch);
    
    if (FULL_TREE==true) {
      if (children.length == 0 && extinct != 0){
        extinct_branches.add(next_branch);
      }
    }
    else if (children.length == 0 && random(0.,1.)<1.){
      extinct_branches.add(next_branch);
    }


    ///////////////////////////////////////////////////////////////////////
    // Begin recrusive loop
    ///////////////////////////////////////////////////////////////////////
    readChild(children, current_depth+1, next_branch);

    // }
  }
  // println(stars);
  // println("");
}