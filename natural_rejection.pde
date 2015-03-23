import controlP5.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
 
XML xml;

boolean FULL_TREE = true;
boolean DRAW_MAIN = true;
boolean DRAW_HALO = false;
boolean DRAW_SKELETON = false;
boolean PRINT_INFO = false;
boolean show_hud = false;
boolean show_text = true;
boolean update_cubes = true;
int screenshot_number = 0;

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
float camera_fov = PI/2.5;
int camera_animate = 0;
float camera_easeSpeed = 0.00;
PVector camera_autoPos;
PVector camera_autoCen;
PVector camera_autoRand;
Branch camera_autoBranch;
int autoBranch_id = 970;

color bg_color = color(255,255,255);
float base_cR = .06;
float base_cG = .05;
float base_cB = .03;
float gain = 1.6;

float s = 0.0;
float anim_speed = 1.3;
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
int text_list_size = 4;
// float [][] fade_text;
// float [][] fade_text_rand;
float text_fade_speed = .06;
ArrayList<float[]> fade_text = new ArrayList<float[]>();
ArrayList<float[]> fade_text_rand = new ArrayList<float[]>();
ArrayList<String> text_names_list = new ArrayList<String>();
float [] title_fade;
float [] title_fade_rand;
int title_display_time = 100;
boolean display_title = false;
boolean display_help_mouse = true;
String title = "Natural Rejection";
String subtitle = "Extinct species from the Tree of Life Web Project phylogenetic database";
String [] help_info = { "Hover over branch tips to show species name",
                        "Click to lock selection",
                        "Double click to focus on node" };
                      
String [] help_dialog = {   "controls:  ", 
                            ""+char(8593), "  increase taxonomy list",
                            ""+char(8595), "  decrease taxonomy list",
                            "1", "  halo effect",
                            "2", "  entire tree",
                            "H", "  show GUI",
                            "R", "  rebuild tree",
                            "?", "  show this menu",};
                          
float help_dialog_fade = 255;
int display_help_delay = 90;
int display_help_timer = 240;
int display_help = 1;

char arrow = 8627;

int marginX = 20;
int marginY = 30;

PShader lineShader;
PShader lineShader2;
PShader lineShader3;
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

PFont font1 = createFont("Verdana", 22, true);
PFont font2 = createFont("monaco", 10, true);
PFont font3 = createFont("Verdana", 30, true);

int hud_offset = 400;
int hud_spacing = 10;
float spare_slider1 = 0.06;
float spare_slider2 = .65;
float spare_slider3 = 1.0;
float spare_slider4 = .16; //.11
float spare_slider5 = 3.89; //1.5
float spare_slider6 = .23;
float spare_slider7 = 1.0;
float spare_slider8 = .93;
float spare_slider9 = 0.09;
float spare_slider10 = 0.03;
float spare_slider11 = .19;  //color random
float spare_slider12 = 3.05; //length mult
float spare_slider13 = 1.;
float spare_sliderx = 2350.;
float spare_slidery = 0.;
float spare_sliderz = 950.;
float spare_sliderx2 = 1900.;
float spare_slidery2 = 90.;
float spare_sliderz2 = 2000.;

boolean sketchFullScreen() {
  return true;
}