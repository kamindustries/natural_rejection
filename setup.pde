void setup() {
  // size(1280,800,P3D);
  size(960,560,OPENGL);

  // Setting up the camera
  cam= new PeasyCam(this,0,0,100,600);       
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(4000);
  cam.setSuppressRollRotationMode();
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  perspective(PI/3.0, float(width)/float(height), 1/10.0, 10000.0);
  push_back = new float[3];
  halo_displ = (float)cam.getDistance();
  
  // Control P5 stuff      
  setupGUI();

  // Graphics
  gfx = new ToxiclibsSupport(this);
  p3d = (PGraphics3D)g;

  println("gathering shaders...");
  lineShader = loadShader("linefrag.glsl", "linevert.glsl");
  lineShader2 = loadShader("linefrag.glsl", "linevert.glsl");

  pointShader = new PShader(this, "point_vert.glsl", "point_frag.glsl");
  pointShader.set("weight", extinct_pts_weight);
  pointShader.set("sprite", loadImage("particle.png"));
  println("loaded shaders.");
 
  // Sets random seed so we get same results each time
  randomSeed(0);

  ///////////////////////////////////////////////////////////////////////
  // Read XML
  ///////////////////////////////////////////////////////////////////////
  
  // xml = loadXML("tree_of_life_complete.xml");
  if (FULL_TREE==true) xml = loadXML("tree_of_life_complete.xml");
  else {
    xml = loadXML("harpalinae.xml");
    // xml = loadXML("test3.xml");
    // xml = loadXML("test4.xml");
  }
  axiom = xml.getChildren("NODE");
  depth = 0;
  println("init max depth: " + max_depth);

  ///////////////////////////////////////////////////////////////////////
  // START GROWING!
  ///////////////////////////////////////////////////////////////////////
  float timer = millis();
  GROW();
  // GROW();
  println("tree_list size: " + tree_list.size());
  println("tree mesh size: " + tree_meshes.get(0).getVertexCount());
  println("max depth: " + max_depth);
  println("xml processing time: " + xml_calc_time);
  println("geom processing time: " + geom_calc_time);
  println("total processing time: " + (millis()-timer)/1000.0);
  println("num extinct species: " + extinct_branches.size());



  drawGUI();

}