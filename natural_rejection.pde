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

boolean FULL_TREE = true;
boolean DRAW_MAIN = true;
boolean DRAW_HALO = false;
boolean DRAW_SKELETON = false;
boolean PRINT_INFO = false;
boolean show_hud = false;
boolean show_text = true;
boolean update_cubes = true;

PGraphics buffer;   // buffer
Cube[] cubes;       // cubes

PeasyCam cam;
ControlP5 cp5;
PMatrix3D currCameraMatrix;
PGraphics3D p3d ;

float [] camera_pos;
float [] camera_lookAt;
float [] push_back;
float [] mouseXY = {0.,0.};
float halo_displ;

color bg_color = color(255,255,255);

float s = 0.0;
int[] extinct_picked;
String[] extinct_names;
String display_name;
float [] fade_val;
float [] fade_val_a;
PVector [] extinct_rand_vec3;
float hover_max = 2.0;
float ease_speed = 0.05;
int hover_id = -1;
boolean lock_selection = false;
boolean mouse_drag = false;
boolean update_text = true;
// float [][] fade_text;
// float [][] fade_text_rand;
float text_fade_speed = .03;
ArrayList<float[]> fade_text = new ArrayList<float[]>();
ArrayList<float[]> fade_text_rand = new ArrayList<float[]>();
ArrayList<String> text_names_list = new ArrayList<String>();
// ArrayList<float[]> fade_text;
// ArrayList<float[]> fade_text_rand;

int marginX = 20;
int marginY = 20;

PShader lineShader;
PShader lineShader2;
PShader pointShader;

float extinct_pts_weight = 100;

Branch root;
Branch trunk;
Branch selected_branch;
ArrayList<Branch> tree_list = new ArrayList<Branch>();
ArrayList<Branch> extinct_branches = new ArrayList<Branch>();
ArrayList<PShape> tree_meshes = new ArrayList<PShape>();
ArrayList<PShape> extinct_meshes = new ArrayList<PShape>();
PShape extinct_points;

float[] clr_black = {0.0, 0.0, 0.0};
float[] clr_white = {1.0, 1.0, 1.0};
float[] clr_red = {1.0, 0.0, 0.0};
float[] clr_green = {0.0, 1.0, 0.0};
float[] clr_pt_hover = {0.0, 0.0, 0.0};
float[] clr_halo;

float branch_length = 300.0;
int depth;
// int [] depth_array;
int max_depth = 122;
float xml_calc_time = 0.0;
float geom_calc_time = 0.0;

XML[] axiom;

PFont font1 = createFont("Verdana", 14, true);
PFont font2 = createFont("monaco", 10, true);

int hud_offset = 400;
int hud_spacing = 10;
float spare_slider1 = 0.1;
float spare_slider2 = .7;
float spare_slider3 = 2.0;
float spare_slider4 = .18;
float spare_slider5 = 2.5;
float spare_slider6 = 10.0;
float spare_slider7 = .14;
float spare_slider8 = .9;
float spare_slider9 = 0.1;
float spare_slider10 = 0.1;
float spare_slider11 = .1;
