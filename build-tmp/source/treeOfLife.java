import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import peasy.test.*; 
import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 
import toxi.processing.*; 
import toxi.geom.*; 
import toxi.geom.mesh.*; 
import toxi.geom.mesh.subdiv.*; 
import toxi.math.*; 
import toxi.physics.*; 
import toxi.physics.behaviors.*; 
import toxi.physics.constraints.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class treeOfLife extends PApplet {






// 3D creations








ToxiclibsSupport gfx;
 
XML xml;

boolean PRINT_INFO = false;

PeasyCam cam;
ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D p3d ;

float [] camera_pos;
float [] camera_lookAt;
float[] push_back;
float halo_displ;

float[] hover;

int marginX = 20;
int marginY = 20;

PShader lineShader;
PShader lineShader2;
PShader pointShader;

float extinct_pts_weight = 100;

Branch root;
Branch trunk;
ArrayList<Branch> tree_list = new ArrayList<Branch>();
ArrayList<Branch> extinct_branches = new ArrayList<Branch>();
ArrayList<PShape> tree_meshes = new ArrayList<PShape>();
ArrayList<PShape> extinct_meshes = new ArrayList<PShape>();
PShape extinct_points;

float[] stroke_black = {0.0f, 0.0f, 0.0f};
float[] stroke_white = {1.0f, 1.0f, 1.0f};
float[] stroke_red = {1.0f, 0.0f, 0.0f};

float branch_length = 300.0f;
int depth;
// int [] depth_array;
int max_depth = 122;
float xml_calc_time = 0.0f;
float geom_calc_time = 0.0f;

XML[] axiom;

PFont font1 = createFont("SourceSansPro-Semibold", 20, true);
PFont font2 = createFont("monaco", 10, true);

float spare_slider1 = -0.9f;
float spare_slider2 = 1.0f;
float spare_slider3 = 3.0f;
float spare_slider4 = 1.0f;
float spare_slider5 = 30.0f;
float spare_slider6 = 3.0f;
float spare_slider7 = 4.0f;
float spare_slider8 = 0.27f;
///////////////////////////////////////////////////////////////////////
// Branch class
///////////////////////////////////////////////////////////////////////
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
  currCameraMatrix = new PMatrix3D(p3d.camera);
  camera();
  cp5.draw(); //DRAW CONTROLS AFTER CAMERA FOR GREAT SUCCESS
  p3d.camera = currCameraMatrix;

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
  // spare_slider1 = -0.9;
  // spare_slider2 = 1.0;
  // spare_slider3 = 3.0;
  // spare_slider4 = 1.0;
  // spare_slider5 = 30.0;
  // spare_slider6 = 3.0;
  // spare_slider7 = -20.0;
  cp5.addSlider("spare1")
  .setPosition(marginX, marginY+20)
  .setRange(-1.f, 1.f)
  .setValue(-0.9f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare2")
  .setPosition(marginX, marginY+30)
  .setRange(0.1f, 10.0f)
  .setValue(1.0f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare3")
  .setPosition(marginX, marginY+40)
  .setRange(0.1f, 5.0f)
  .setValue(3.0f)
  .setSize(300,9)
  ;
  cp5.addSlider("spare4")
  .setPosition(marginX, marginY+50)
  .setRange(0.01f, 2.0f)
  .setValue(1.0f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare5")
  .setPosition(marginX, marginY+60)
  .setRange(0.01f, 10.0f)
  .setValue(10.0f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare6")
  .setPosition(marginX, marginY+70)
  .setRange(0.0f, 1.0f)
  .setValue(1.0f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare7")
  .setPosition(marginX, marginY+80)
  .setRange(0.0f, 5.0f)
  .setValue(4.0f)
  .setSize(300,9)
  ;  
  cp5.addSlider("spare8")
  .setPosition(marginX, marginY+90)
  .setRange(0, 1.0f)
  .setValue(0.27f)
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
  if (theEvent.isFrom(cp5.getController("spare7"))) {
    spare_slider7 = theEvent.getController().getValue();
  }
  if (theEvent.isFrom(cp5.getController("spare8"))) {
    spare_slider8 = theEvent.getController().getValue();
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

  background(255);
  
  ///////////////////////////////////////////////////////////////////////
  // RE DRAW EVERY  F R A M E
  ///////////////////////////////////////////////////////////////////////
  if (frameCount%24==0) {
    GROW();
  }

  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  push_back[0]=camera_pos[0]-camera_lookAt[0];
  push_back[1]=camera_pos[1]-camera_lookAt[1];
  push_back[2]=camera_pos[2]-camera_lookAt[2];
  
  float cam_zoom = (float)cam.getDistance();
  halo_displ = cam_zoom * spare_slider1;

  // TURNS OFF CAMERA CONTROLS WHEN HOVERING OVER SLIDER
  if (cp5.window(this).isMouseOver()) {
    cam.setActive(false);
  } else { 
    cam.setActive(true);
  }

  textFont(font1);

  if (frameCount%24==0) lineShader = loadShader("linefrag.glsl", "linevert.glsl");

  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider2);
  //   lineShader.set("stroke_color", stroke_black);
  //   shader(lineShader, LINES);
  //   shape(tree_meshes.get(0));
  // popMatrix();
  
  // noFill();
  box(10); 
  
  // pushMatrix();
  //   lineShader.set("stroke_weight", (float)spare_slider3);
  //   lineShader.set("stroke_color", stroke_white);
  //   shader(lineShader, LINES);    
  //   translate(push_back[0]/halo_displ, push_back[1]/halo_displ, push_back[2]/halo_displ);
  //   shape(tree_meshes.get(1));
  // popMatrix();

  pushMatrix();
    lineShader.set("stroke_weight", (float)spare_slider2);
    lineShader.set("stroke_color", stroke_red);
    shader(lineShader, LINES);
    for (int i = 0; i < extinct_meshes.size(); i++) {
      shape(extinct_meshes.get(i));
    }
  popMatrix();

  resetShader();

  // // Pick ray tests
  // if (extinct_branches.size()>0){
  //   shape(extinct_points);

  //   Ray3D r = PickRay(camera_pos);
  //   float radius = 10.0;

  //   for (int i = 0; i < extinct_points.getVertexCount(); i++) {
  //     PVector cen = extinct_points.getVertex(i);
  //     PVector cen_orig = extinct_points.getVertex(i);
  //     PVector fix_zoom = new PVector(camera_lookAt[0],camera_lookAt[1],camera_lookAt[2]);
  //     fix_zoom.sub(cen);
  //     fix_zoom.normalize();
  //     fix_zoom.mult(sqrt(cam_zoom) * -1.0);
  //     cen.add(fix_zoom); //fix for peasycam "zoom"

  //     ///////////////////////////////////////////////////////////////////////
  //     // do intersection calculation
  //     ///////////////////////////////////////////////////////////////////////
  //     float f = IntersectSphere(r, cen, radius);

  //     // If hovering, do something
  //     if (f > 0.0) {
  //       hover[i] = f;
  //       fill(0,255,0);
  //       text("cool", cen_orig.x, cen_orig.y + 10, cen_orig.z + 5);
  //     }
  //     if (f <= 0.0) hover[i] = 0.0;
  //   }
  // }


  drawGUI();
  textFont(font2);
  text(frameRate, width - 70, marginY);

}
///////////////////////////////////////////////////////////////////////
// Return ray
///////////////////////////////////////////////////////////////////////
public Ray3D PickRay(float[] _cam_pos){

  PMatrix3D proj = p3d.projection.get();
  PMatrix3D modvw = p3d.modelview.get();
  PVector cam = new PVector(_cam_pos[0],_cam_pos[1],_cam_pos[2]);

  // GluLookAt  ...
  float x = 2* ((float)mouseX) / (float)width - 1;
  float y = 2* ((float)height - (float)mouseY) / (float)height - 1;
  float z = 1.0f;
  PVector vect = new PVector(x, y, z);
  
  PVector transformVect = new PVector();
 
  proj.apply(modvw);
  proj.invert();
  proj.mult(vect, transformVect);

  stroke(200);

  Ray3D ray = new Ray3D(new Vec3D(cam.x, cam.y, cam.z), 
                        new Vec3D(transformVect.x,transformVect.y,transformVect.z));

  return ray;
}

///////////////////////////////////////////////////////////////////////
// Picking sphere
///////////////////////////////////////////////////////////////////////
public float IntersectSphere(Ray3D _r, PVector _cen, float _radius){

  Vec3D _d = _r.getDirection();
  PVector d = new PVector(_d.x, _d.y, _d.z);
  PVector o = new PVector(_r.x, _r.y, _r.z);

  PVector o_c = PVector.sub(o, _cen);
  float a = d.dot(d);
  float b = 2.f * (d.dot(o_c));
  float c = (o_c.dot(o_c)) - _radius * _radius;
  float detect = b*b - 4*a*c;

  if(detect > 0.0f) {
    float t1 = (-b - sqrt(detect)) / (2.0f * a);
    if(t1 > 0.0f) return t1;
    float t2 = (-b + sqrt(detect)) / (2.0f * a);
    if (t2 > 0.0f) return t2;
  }
  else if (detect == 0.0f) {
    float t = -b / (2.0f * a);
    if (t > 0.0f) return t;
  }

  return -1.0f; //we ignore negative intersections, -1 qualifies as a miss
}

public void GROW() {
  tree_list.clear();
  tree_meshes.clear();
  extinct_branches.clear();
  extinct_meshes.clear();

  randomSeed(0);
  
  ///////////////////////////////////////////////////////////////////////
  // T R U N K 
  ///////////////////////////////////////////////////////////////////////
  
  float xml_timer = millis();
  PVector root_pos = new PVector(0.0f, 0.0f, 0.0f);
  PVector trunk_pos = new PVector(0.0f, branch_length/10.0f, 0.0f);
  PVector init_grow_dir = new PVector(0.05f, 1.f, 0.05f);
  root = new Branch(null, root_pos, init_grow_dir, 1, 0);
  trunk = new Branch(null, trunk_pos, root.grow_dir, root.children, 0);
  // tree_list.add(root);
  // tree_list.add(trunk);

  Branch current;
  current = new Branch(null, trunk.position, trunk.grow_dir, 1, trunk.depth);

  // Draw a trunk
  for (int i = 0; i < 1; i++) {
    PVector new_pos = PVector.mult(root.grow_dir, branch_length/10.0f);  
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

  // how long it took to go through the xml file
  xml_calc_time = (millis() - xml_timer)/1000.0f;


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

  // load meshes with vertex info
  // need to do some smart coloration based on age
  for(int j = 0; j < tree_meshes.size(); j++) {

    PShape mesh = tree_meshes.get(j);
    mesh = createShape();
    mesh.beginShape(LINES);

      // for (int i = 0; i < tree_list.size()-2; i+=2){
      //   Branch b0 = tree_list.get(i);
      //   Branch b1 = tree_list.get(i+1);

      //   // set up colors
      //   float grad0 = abs((1 - (b0.depth/(float)max_depth))) * 255;
      //   float grad1 = abs((1 - (b1.depth/(float)max_depth))) * 255;
      //   color c0 = color(grad0,grad0,grad0);
      //   color c1 = color(grad1,grad1,grad1);
      //   color cw = color(255,255,255);
      //   color cr = color(0,0,0);

      //   if (b1.children == 0) {
      //     c1 = cr; 
      //   }
      //   mesh.vertex(b0.position.x, b0.position.y, b0.position.z);
      //   mesh.stroke(c1);
      //   mesh.vertex(b1.position.x, b1.position.y, b1.position.z);
      //   mesh.stroke(c0);
      // }

    mesh.endShape();
    tree_meshes.set(j, mesh);
  }
  geom_calc_time = (millis() - xml_timer)/1000.0f;

  if (extinct_branches.size()>0){
    Branch p = extinct_branches.get(400);
    int num_extinct_points = extinct_branches.size();
    float scatter = 300.0f;
    
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
    Branch p0 = extinct_branches.get(i);
    Branch p1 = p0.parent;
    

    PShape mesh = extinct_meshes.get(i);
    mesh = createShape();
    mesh.beginShape();
    mesh.noFill();
    // mesh.curveTightness(spare_slider8);
    mesh.curveTightness(0.05f);
    mesh.curveVertex(p0.position.x, p0.position.y, p0.position.z);
    mesh.curveVertex(p0.position.x, p0.position.y, p0.position.z);

    int j = 1;

      while (p1 != null || p0 != null) {
        // set up colors
        float grad0 = abs((1 - (j/(1.f+(float)p0.depth)))) * 255;
        float grad1 = abs((1 - (j/(1.f+(float)p1.depth)))) * 255;
        int c0 = color(grad0,grad0,grad0);
        int c1 = color(grad1,grad1,grad1);
        int cw = color(255,255,255);
        int cr = color(0,0,0); 
        
        PVector o0 = p0.position;
        PVector o1 = p1.position;

        PVector r = new PVector(random(-1,1), random(-1,1), random(-1,1));
        r.mult(j * spare_slider8);

        if (p1.parent == null) {
          o0.add(r);
          o1.add(r);
          mesh.curveVertex(o0.x, o0.y, o0.z);
          mesh.stroke(c0);
          mesh.curveVertex(o1.x, o1.y, o1.z);
          mesh.stroke(c1);
          break;
        }
        else {
          PVector perp_vector = p0.grow_dir.cross(r);
          perp_vector.mult(j * spare_slider7);
          o0.add(perp_vector);
          o0.add(r);
          mesh.curveVertex(o0.x, o0.y, o0.z);
          mesh.stroke(c0);
          
          p0 = p1.parent;
        }
      }
    mesh.endShape();
    extinct_meshes.set(i, mesh);
    j++;
  }
}
public void readChild(XML[] _parent, int _depth, Branch _branch) {
  Branch branch = _branch;    //the incoming parent branch
  int current_depth = _depth;
  int num_branches = _parent.length;
  // if (depth == 0) num_branches = _parent[0].getInt("CHILDCOUNT");

  // float current_branch_length = (branch_length/float(current_depth+1));
  float current_branch_length = branch_length*((1+max_depth-current_depth)/((float)max_depth+1.f));
  current_branch_length *= .2f;
  // if (current_branch_length >= branch_length/4.0){ 
  //   current_branch_length = current_branch_length/4.0;
  // }
  // if (current_branch_length <= 20){
  //   current_branch_length = 20;
  // }
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
  if (spread > 1.0f) spread = 1.0f;
  if (spread < 0.03f) spread = .03f;
  spread = spread * 0.015f;

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
  if (perturb >= 20) perturb = 10;
  if (perturb <= 1) perturb = 2;
  perturb *= perturb*0.5f;
  // perturb = PI * perturb/20.0;
  // perturb *= pow(((max_depth-current_depth+1)/(float)max_depth),3);
  perturb *= pow((max_depth+1)/((float)current_depth+1.f),1.4f);
  perturb *= spare_slider5 * 0.1f;
  
  cross_p.mult(perturb);

  // add original growing dir with scaled cross product
  // PVector initial_grow_dir = PVector.add(branch.grow_dir, cross_p);

  // get final variables lined up to prepare to rotate around grow dir vector
  PVector tan1 = init_grow_dir.cross(cross_p);
  float dot = init_grow_dir.dot(branch.grow_dir);
  PVector len = PVector.mult(branch.grow_dir, dot);
  // len.mult(spare_slider4 * 1.0 * ((current_depth)/(float)max_depth));
  len.mult(spare_slider4 * 1.0f * (max_depth-current_depth)/(float)max_depth);

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
  
  // String base_name = new String();
  // if (depth == 0) {
  //   XML _base_name = _parent[0].getChild("NAME");  
  //   base_name = _base_name.getContent();
  //   println(base_name + ", " + _parent[0].getInt("CHILDCOUNT"));
  // }

  
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
    if (name == "") name = "[no name]";

    if (PRINT_INFO == true){
      println(spacing + "Name: " + name + ", " + children.length + ", " + id);
    }

    ///////////////////////////////////////////////////////////////////////
    // Math it up
    ///////////////////////////////////////////////////////////////////////
    
    // float rot = cos(spare_slider6*PI*i/(float)_parent.length);
    float angle = (2 * PI * (i/(float)_parent.length));
    // PVector tan2_rotate = PVector.mult(tan2,rot);
    float rand_scale = .25f;
    PVector rot_cos = PVector.mult(tan1, cos(angle + random(-rand_scale, rand_scale)));
    PVector rot_sin = PVector.mult(cross_p, sin(angle + random(-rand_scale, rand_scale)));
    PVector new_grow_dir = PVector.add(rot_cos, rot_sin);
    // len.mult(perturb);
    new_grow_dir.add(len);
    new_grow_dir.normalize();
    
    // new_grow_dir = initial_grow_dir;
    // new_grow_dir.normalize();


    PVector new_pos = PVector.mult(new_grow_dir, current_branch_length);  
    new_pos.add(branch.position);
    // println("newpos:"+new_pos);

    Branch next_branch = new Branch(_branch, new_pos, new_grow_dir, children.length, current_depth);
    
    tree_list.add(branch);
    tree_list.add(next_branch);
    
    // if (children.length == 0 && extinct != 0){
    // if (extinct != 0){
    if (children.length == 0){
      // tree_list.add(branch);
      // tree_list.add(next_branch);

      extinct_branches.add(next_branch);
    }
    // if (children.length > 0){
    //   tree_list.add(branch);
    //   tree_list.add(next_branch);
    // }

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
  size(960,560,P3D);

  // Setting up the camera
  cam= new PeasyCam(this,0,0,100,600);       
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(4000);
  cam.setSuppressRollRotationMode();
  camera_pos = cam.getPosition();
  camera_lookAt = cam.getLookAt();
  perspective(PI/3.0f, PApplet.parseFloat(width)/PApplet.parseFloat(height), 1/10.0f, 10000.0f);
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
  println("total processing time: " + (millis()-timer)/1000.0f);
  println("num extinct species: " + extinct_branches.size());



  drawGUI();

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
