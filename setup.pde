void setup() {
  // size(1280,800,P3D);
  size(640,400,P3D);

  //setting up the camera
  cam= new PeasyCam(this,0,0,100,600);       
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(4000);
  cam.setSuppressRollRotationMode();
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  perspective(PI/3.0, float(width)/float(height), 1/10.0, 10000.0);
  push_back = new float[3];
  zoom = (float)cam.getDistance();
  
  //control P5 stuff      
  g3 = (PGraphics3D)g;
  setupGUI();
  
  lineShader = loadShader("linefrag.glsl", "linevert.glsl");
  lineShader2 = loadShader("linefrag.glsl", "linevert.glsl");
  
  // Sets random seed so we get same results each time
  randomSeed(0);

  ///////////////////////////////////////////////////////////////////////
  // Read XML
  ///////////////////////////////////////////////////////////////////////
  
  // xml = loadXML("tree_of_life_complete.xml");
  xml = loadXML("harpalinae.xml");
  // xml = loadXML("test3.xml");
  // xml = loadXML("test4.xml");
  axiom = xml.getChildren("NODE");
  depth = 0;

  ///////////////////////////////////////////////////////////////////////
  // START GROWING!
  ///////////////////////////////////////////////////////////////////////
  GROW();


  // int timer = millis();
  // readChild(axiom, depth, trunk);

  // // Print results
  // println("Done with readChild");
  // println("tree_list size: " + tree_list.size());
  // // println("max depth: "+max_depth);
  // max_depth = 2;
  // for (int i = 0; i < tree_list.size(); i++) {
  //   Branch b0 = tree_list.get(i);
  //   if (max_depth<=b0.depth) {
  //     max_depth = b0.depth;
  //   }
  // }
  // println("max depth: "+max_depth);

  // depth_array = new int[0];

  // tree_meshes.add(new PShape());
  // tree_meshes.add(new PShape());

  // // load meshes with vertex info.
  // // need to do some smart coloration based on age
  // for(int j = 1; j < tree_meshes.size(); j++) {

  //   PShape mesh = tree_meshes.get(j);
  //   mesh = createShape();
  //   mesh.beginShape(LINES);

  //     for (int i = 0; i < tree_list.size()-2; i+=2){
  //       Branch b0 = tree_list.get(i);
  //       Branch b1 = tree_list.get(i+1);

  //       // set up colors
  //       float grad0 = b0.depth/float(max_depth)*255.0;
  //       float grad1 = b1.depth/float(max_depth)*255.0;
  //       color c0 = color(grad0,grad0,grad0);
  //       color c1 = color(grad1,grad1,grad1);
  //       color cw = color(255,255,255);
  //       color cr = color(255,0,0);

  //       // make second mesh all white
  //       if (j == 1) {
  //         c0 = cw;
  //         c1 = cw;
  //       }

  //       if (b1.children > 0){
  //         mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
  //         mesh.stroke(c1);
  //         mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
  //         mesh.stroke(c0);

  //         depth_array = append(depth_array, b0.children);
  //         depth_array = append(depth_array, b1.children);
  //       } 
  //       else {
  //         mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
  //         mesh.stroke(cr);
  //         mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
  //         mesh.stroke(c0);

  //         depth_array = append(depth_array, b0.children);
  //         depth_array = append(depth_array, b1.children);
  //       } 
  //       // }
  //       // if (b0.children == 0) {
  //       //   stroke(255,0,0);
  //       //   mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
  //       // }
  //     }
  //   mesh.endShape();
  //   tree_meshes.set(j, mesh);
  // }
  // println("MESH CALC TIME: " + (millis()-timer)/1000.0);

  // int mesh_size = tree_meshes.get(0).getVertexCount();
  // println("mesh size: "+mesh_size);
  // XML[] test = axiom[0].getChildren("NODES/NODE/NODES/NODE");
  // for (int i = 0; i < test.length; i++) {
  //   XML name = test[i].getChild("NAME");
  //   String _name = name.getContent();
  //   if (_name == "") _name = "[no name]";
  //   println(_name);
  // }
  // println(test.length);
  // println(axiom[0].getInt("CHILDCOUNT"));


}