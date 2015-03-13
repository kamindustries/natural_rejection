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
PShape extinct_points;


float branch_length = 300.0;
int depth;
// int [] depth_array;
int max_depth = 18;
float xml_calc_time = 0.0;
float geom_calc_time = 0.0;

XML[] axiom;

PFont font1 = createFont("SourceSansPro-Semibold", 20, true);
PFont font2 = createFont("monaco", 10, true);

float spare_slider1 = -0.9;
float spare_slider2 = 1.0;
float spare_slider3 = 3.0;
float spare_slider4 = 1.0;
float spare_slider5 = 30.0;
float spare_slider6 = 3.0;
float spare_slider7 = -20.0;
