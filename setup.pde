void setup() {
  // size(1280,800,P3D);
  size(960,560,OPENGL);

  // Setting up the camera
  cam= new PeasyCam(this,0,0,100,600);       
  cam.setMinimumDistance(90);
  cam.setMaximumDistance(4000);
  cam.setSuppressRollRotationMode();
  cam.setResetOnDoubleClick(false);
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

  buffer = createGraphics(width, height, P3D);
  clr_halo = new float[3];
  clr_halo[0] = red(bg_color);
  clr_halo[1] = green(bg_color);
  clr_halo[2] = blue(bg_color);

  // Shaders
  println("gathering shaders...");
  lineShader = loadShader("linefrag.glsl", "linevert.glsl");
  lineShader2 = loadShader("linefrag.glsl", "linevert.glsl");

  lineShader.set("stroke_weight", (float)spare_slider2);
  lineShader.set("stroke_color", clr_red);
  lineShader.set("render_solid", 0);
  lineShader2.set("stroke_weight", (float)spare_slider3);
  lineShader2.set("stroke_color", clr_white);
  lineShader2.set("push", spare_slider1);
  lineShader2.set("render_solid", 1);
  
  pointShader = new PShader(this, "point_vert.glsl", "point_frag.glsl");
  pointShader.set("weight", extinct_pts_weight);
  // pointShader.set("sprite", loadImage("particle.png"));
  println("loaded shaders.");

  // Sets random seed so we get same results each time
  randomSeed(0);

  ///////////////////////////////////////////////////////////////////////
  // Read XML
  ///////////////////////////////////////////////////////////////////////
  
  // xml = loadXML("tree_of_life_complete.xml");
  String file = "harpalinae.xml";
  if (FULL_TREE==true) file = "tree_of_life_complete.xml";
  xml = loadXML(file);
  println("Loaded "+file);
  println("");

  axiom = xml.getChildren("NODE");
  depth = 0;
  println("init max depth: " + max_depth);

  ///////////////////////////////////////////////////////////////////////
  // START GROWING!
  ///////////////////////////////////////////////////////////////////////
  float startup_timer = millis();
  GROW();
  println("First growth complete.");
  //grow a second time to get accurate max depth for smaller trees
  if (FULL_TREE==false) GROW(); 
  int num_extinct_cvs = 0;
  for (int i=0; i<extinct_meshes.size(); i++){
    num_extinct_cvs += extinct_meshes.get(i).getVertexCount();
  }
  println("tree_list size: " + tree_list.size());
  println("tree mesh size: " + tree_meshes.get(0).getVertexCount());
  println("num extinct species: " + extinct_branches.size());
  println("num extinct curve vertices: " + num_extinct_cvs);
  println("max depth: " + max_depth);
  println("xml processing time: " + xml_calc_time);
  println("geom processing time: " + geom_calc_time);
  println("total processing time: " + (millis()-startup_timer)/1000.0);


  // Array lists for text fading
  ArrayList<float[]> fade_text = new ArrayList<float[]>();
  ArrayList<float[]> fade_text_rand = new ArrayList<float[]>();
  ArrayList<String> text_names_list = new ArrayList<String>();

  drawGUI();

}