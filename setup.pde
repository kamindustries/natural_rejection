void setup() {
  // size(1280,800,P3D);
  size(960,560,P3D);

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
  xml = loadXML("harpalinae.xml");
  // xml = loadXML("test3.xml");
  // xml = loadXML("test4.xml");
  axiom = xml.getChildren("NODE");
  depth = 0;

  ///////////////////////////////////////////////////////////////////////
  // START GROWING!
  ///////////////////////////////////////////////////////////////////////
  float timer = millis();
  GROW();
  println("tree_list size: " + tree_list.size());
  println("tree mesh size: " + tree_meshes.get(0).getVertexCount());
  println("max depth: " + max_depth);
  println("xml processing time: " + xml_calc_time);
  println("geom processing time: " + geom_calc_time);
  println("total processing time: " + (millis()-timer)/1000.0);
  println("num extinct species: " + extinct_branches.size());

  float extinct_timer = millis();
  println(extinct_timer);

  if (extinct_branches.size()>0){
    Branch p = extinct_branches.get(400);
    int num_extinct_points = extinct_branches.size();
    float scatter = 300.0;
    
    extinct_points = createShape();
    extinct_points.beginShape(POINTS);
      extinct_points.strokeWeight(8);
      extinct_points.stroke(255,0,0);
      // while (p != null) {
      //   if (p.parent == null) break;
      //   else {
      //     extinct_points.vertex(p.position.x, p.position.y, p.position.z);
      //     extinct_points.vertex(p.parent.position.x, p.parent.position.y, p.parent.position.z);
      //     p = p.parent;
      //   }
      // }
      for (int i = 0; i < num_extinct_points; i++){
        Branch ex = extinct_branches.get(i);
        extinct_points.vertex(ex.position.x, ex.position.y, ex.position.z); 
      }
    extinct_points.endShape();
    println(millis());
    println("extinct processing time: "+(extinct_timer-millis())/1000.0);

    hover = new float[num_extinct_points];
  }
  drawGUI();

}