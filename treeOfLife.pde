import controlP5.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

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
float branch_length = 300.0;
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