import controlP5.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
// 3D creations
import toxi.processing.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.math.*;
import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;
ToxiclibsSupport gfx;
 
XML xml;

boolean FULL_TREE = false;
boolean DRAW_SKELETON = false;
boolean PRINT_INFO = false;
boolean show_hud = true;
boolean show_fps = true;

PeasyCam cam;
ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D p3d ;

float [] camera_pos;
float [] camera_lookAt;
float[] push_back;
float halo_displ;

float s = 0.0;
boolean rev = false;
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

float[] stroke_black = {0.0, 0.0, 0.0};
float[] stroke_white = {1.0, 1.0, 1.0};
float[] stroke_red = {1.0, 0.0, 0.0};

float branch_length = 300.0;
int depth;
// int [] depth_array;
int max_depth = 122;
float xml_calc_time = 0.0;
float geom_calc_time = 0.0;

XML[] axiom;

PFont font1 = createFont("SourceSansPro-Semibold", 20, true);
PFont font2 = createFont("monaco", 10, true);

float spare_slider1 = 0.1;
float spare_slider2 = 3.2;
float spare_slider3 = 7.0;
float spare_slider4 = .18;
float spare_slider5 = 2.5;
float spare_slider6 = 1.0;
float spare_slider7 = 10.0;
float spare_slider8 = 0.14;
float spare_slider9 = 0.05;
