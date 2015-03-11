import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import peasy.test.*; 
import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class treeOfLife extends PApplet {







XML xml;

boolean PRINT_INFO = false;

PeasyCam cam;
ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D g3; 

float [] camera_pos;
float [] camera_lookAt;
float[] push_back;
float zoom;

int marginX = 20;
int marginY = 20;

PShader lineShader;
PShader lineShader2;

Branch root;
Branch trunk;
ArrayList<Branch> tree_list = new ArrayList<Branch>();
ArrayList<PShape> tree_meshes = new ArrayList<PShape>();
// PShape tree_mesh0;
// PShape tree_mesh1;
float branch_length = 300.0f;
int depth;
int [] depth_array;
int max_depth = 123;

XML[] axiom;

PFont font1 = createFont("SourceSansPro-Semibold", 20, true);
PFont font2 = createFont("monaco", 10, true);

float spare_slider1 = 0;
float spare_slider2 = 0;
float spare_slider3 = 0;
float spare_slider4 = 0;
float spare_slider5 = 0;
float spare_slider6 = 0;

// Define branch class to hold all our information
class Branch {
  Branch parent;
  PVector position, grow_dir;
  int children;
  int depth;

  Branch(Branch _parent, PVector _position, PVector _grow_dir, int _children, int _depth) {
    parent = _parent;
    position = _position;
    grow_dir = _grow_dir;
    children = _children;
    depth = _depth;
  }
}
public void drawGUI() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  g3.camera = currCameraMatrix;

  // TITLE
  fill(0);
  textFont(font1);
  textAlign(LEFT);
  text("Natural Rejection", marginX, marginY + 10);
  
  // textFont(fontHeader2);
  // text("Comparing Seattle's Interests in Fiction and Non-fiction", 
  //       marginX, marginY + 58);

  // // LABELS
  // textFont(fontLabelTitle);
  // text("MOST CHECKED OUT TITLES", marginX, marginY+130);
  // textFont(fontSliders);
  // text("ENTIRE LIBRARY", marginX+25, marginY+154);
  // text("WITHIN DEWEY", marginX+25, marginY+175);
  // text("FLIP LABELS", marginX+25, marginY+259);
  // text("TOGGLE LABELS", marginX+25, marginY+279);
  // text("* One block = one week", marginX, marginY+680);

}

public void setupGUI() {

  ///////////////////////////////////////////////////////////////////////
  // Sliders
  ///////////////////////////////////////////////////////////////////////

  cp5 = new ControlP5(this); 
  // cp5.setControlFont(fontSliders);
  // cp5.setColorLabel(textColor);

  cp5.addSlider("spare1")
  .setPosition(marginX, marginY+20)
  .setRange(-1.f, 1.f)
  .setValue(-.25f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare2")
  .setPosition(marginX, marginY+30)
  .setRange(0.1f, 10.0f)
  .setValue(0.4f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare3")
  .setPosition(marginX, marginY+40)
  .setRange(0.1f, 10.0f)
  .setValue(1.4f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare4")
  .setPosition(marginX, marginY+50)
  .setRange(0.1f, 10.0f)
  .setValue(1.4f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare5")
  .setPosition(marginX, marginY+60)
  .setRange(0.1f, 10.0f)
  .setValue(1.4f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare6")
  .setPosition(marginX, marginY+70)
  .setRange(-360.0f, 360.0f)
  .setValue(360.0f)
  .setSize(300,9)
  ;  
  // this is important:
  cp5.setAutoDraw(false);

}

public void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(cp5.getController("spare1"))) {
    spare_slider1 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare2"))) {
    spare_slider2 = theEvent.getController().getValue();
  }
    if (theEvent.isFrom(cp5.getController("spare3"))) {
    spare_slider3 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare4"))) {
    spare_slider4 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare5"))) {
    spare_slider5 = theEvent.getController().getValue();
  }  
  if (theEvent.isFrom(cp5.getController("spare6"))) {
    spare_slider6 = theEvent.getController().getValue();
  }
  // if (theEvent.isFrom(checkbox)) {
  //     user_toggle_table1 = (int)checkbox.getArrayValue()[0];
  //     user_toggle_table2 = (int)checkbox.getArrayValue()[1];
  //   }
  // if (theEvent.isFrom(checkbox_labels)) {
  //     user_toggle_labels = (int)checkbox_labels.getArrayValue()[0];
  //   }
  // if (theEvent.isFrom(checkbox_label_flip)) {
  //     user_toggle_label_flip = (int)checkbox_label_flip.getArrayValue()[0];
  //   }
}
public void draw() {
  // recalculate every frame
  // PShape tree_mesh0;
  // PShape tree_mesh1;
  // tree_list = new ArrayList<Branch>();
  // tree_meshes = new ArrayList<PShape>();


  if (frameCount%24==0) {
    tree_list.clear();
    tree_meshes.clear();
    GROW();
  }

  background(128);
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  zoom = (float)cam.getDistance() * spare_slider1;
  push_back[0]=camera_pos[0]-camera_lookAt[0];
  push_back[1]=camera_pos[1]-camera_lookAt[1];
  push_back[2]=camera_pos[2]-camera_lookAt[2];

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  textFont(font1);


  pushMatrix();
    // if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");
    // lineShader.set("stroke", spare_slider3);
    // shader(lineShader, LINES);
    shape(tree_meshes.get(0));
  popMatrix();
  
  pushMatrix();
    // if (frameCount%24==0) lineShader2 = loadShader("linefrag.glsl", "linevert.glsl");
    // lineShader2.set("stroke", spare_slider2);
    // shader(lineShader2, LINES);    
    translate(push_back[0] / zoom, push_back[1] / zoom, push_back[2] / zoom);
    shape(tree_meshes.get(1));
  popMatrix();

  // for (int i = 1; i < tree_list.size(); i++){
  //   Branch b1 = tree_list.get(i);
  //   Branch b0 = b1.parent;

  //   strokeWeight(1);
  //   stroke(25,0,0);
  //   // line(b0.position.x, b0.position.y, b0.position.z, b1.position.x, b1.position.y, b1.position.z);

  //   strokeWeight(4);
  //   stroke(255,0,0);
  //   // point(b0.position.x, b0.position.y, b0.position.z);

  //   fill(0);
  //   // text(i, b0.position.x+10, b0.position.y, b0.position.z);
  //   // println(b0.position);
  // }

  noFill();
  box(10);
  resetShader();

  
  // if (frameCount%24==0) println(frameRate);
  // if (frameCount%24==0) println(zoom);

  drawGUI();
  textFont(font2);
  text(frameRate, width - 70, marginY);
}
public void GROW() {
  randomSeed(0);
  ///////////////////////////////////////////////////////////////////////
  // Trunk Geometry 
  ///////////////////////////////////////////////////////////////////////
  PVector root_pos = new PVector(0.0f, 0.0f, 0.0f);
  PVector trunk_pos = new PVector(0.0f, branch_length/4.0f, 0.0f);
  PVector init_grow_dir = new PVector(0.f, 1.f, 0.f);
  root = new Branch(null, root_pos, init_grow_dir, 1, 0);
  trunk = new Branch(root, trunk_pos, root.grow_dir, root.children, 0);
  tree_list.add(root);
  tree_list.add(trunk);

  Branch current;
  current = new Branch(trunk, trunk.position, trunk.grow_dir, 1, trunk.depth);

  // Draw a trunk
  for (int i = 0; i < 1; i++) {
    PVector new_pos = PVector.mult(root.grow_dir, branch_length/4.0f);  
    new_pos.add(current.position);

    trunk = new Branch(current, new_pos, current.grow_dir, 1, current.depth);
    current = trunk;

    tree_list.add(trunk.parent);
    tree_list.add(trunk);
    // println(trunk.position);
  }

  ///////////////////////////////////////////////////////////////////////
  // Kick off recursion down XML file tree
  ///////////////////////////////////////////////////////////////////////
  readChild(axiom, depth, trunk);

  // Print results
  // println("Done with readChild");
  // println("tree_list size: " + tree_list.size());
  // println("max depth: "+max_depth);

  // Calculate max depth of file
  max_depth = 2;
  for (int i = 0; i < tree_list.size(); i++) {
    Branch b0 = tree_list.get(i);
    if (max_depth<=b0.depth) {
      max_depth = b0.depth;
    }
  }
  // println("max depth: "+max_depth);

  depth_array = new int[0];

  tree_meshes.add(new PShape());
  tree_meshes.add(new PShape());

  // load meshes with vertex info.
  // need to do some smart coloration based on age
  for(int j = 1; j < tree_meshes.size(); j++) {

    PShape mesh = tree_meshes.get(j);
    mesh = createShape();
    mesh.beginShape(LINES);

      for (int i = 0; i < tree_list.size()-2; i+=2){
        Branch b0 = tree_list.get(i);
        Branch b1 = tree_list.get(i+1);

        // set up colors
        float grad0 = b0.depth/PApplet.parseFloat(max_depth)*255.0f;
        float grad1 = b1.depth/PApplet.parseFloat(max_depth)*255.0f;
        int c0 = color(grad0,grad0,grad0);
        int c1 = color(grad1,grad1,grad1);
        int cw = color(255,255,255);
        int cr = color(255,0,0);

        // make second mesh all white
        if (j == 1) {
          c0 = cw;
          c1 = cw;
        }

        // specific termination color
        if (b1.children > 0){
          mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
          mesh.stroke(c1);
          mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
          mesh.stroke(c0);

          depth_array = append(depth_array, b0.children);
          depth_array = append(depth_array, b1.children);
        } 
        else {
          mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
          mesh.stroke(cr);
          mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
          mesh.stroke(c0);

          depth_array = append(depth_array, b0.children);
          depth_array = append(depth_array, b1.children);
        } 
        // }
        // if (b0.children == 0) {
        //   stroke(255,0,0);
        //   mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
        // }
      }
    mesh.endShape();
    tree_meshes.set(j, mesh);
  }
}
public void readChild(XML[] _parent, int _depth, Branch _branch) {
  Branch branch = _branch;    //the incoming parent branch
  int current_depth = _depth;

  float current_branch_length = (branch_length/PApplet.parseFloat(current_depth+1));
  if (current_branch_length >= branch_length/4.0f){ 
    current_branch_length = current_branch_length/4.0f;
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
  float spread = 1/(PApplet.parseFloat(branch.children)-1);
  if (spread > 1.0f) spread = spare_slider4;
  if (spread < 0.03f) spread = spare_slider5;
  spread = spread * 1.0f;

  // Create a random vector to compare to
  PVector rand_vec = new PVector(random(-1,1), random(-1,1), random(-1,1));
  rand_vec.mult(1.0f);
  PVector init_grow_dir = PVector.add(branch.grow_dir, rand_vec);
  init_grow_dir.normalize();

  // get perpendicular angle to grow direction, normalize and scale
  // scaling eventually achieves the cone radius of the new branches 
  // cross_p = angle(cone) tangent ("green vector")
  // tan1 = rotational tangent ("yellow vector")

  // PVector cross_p = branch.grow_dir.cross(rand_vec);
  PVector cross_p = branch.grow_dir.cross(init_grow_dir);
  // cross_p.normalize();
  cross_p.mult(spare_slider6/100.0f);

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
public void setup() {
  // size(1280,800,P3D);
  size(640,400,P3D);

  //setting up the camera
  cam= new PeasyCam(this,0,0,100,600);       
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(4000);
  cam.setSuppressRollRotationMode();
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  perspective(PI/3.0f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 1/10.0f, 10000.0f);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "treeOfLife" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
