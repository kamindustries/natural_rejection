#define PROCESSING_LINE_SHADER

uniform mat4 transform;
uniform vec4 viewport;

attribute vec4 vertex;
attribute vec4 color;
attribute vec4 direction;

varying vec4 vertColor;

uniform sampler2D texture;

uniform float stroke_weight;
uniform float alpha;
uniform float stroke_color[];
uniform float push;
uniform int render_solid;

vec3 clipToWindow(vec4 clip, vec4 viewport) {
  vec3 dclip = clip.xyz / clip.w;
  vec2 xypos = (dclip.xy + vec2(1.0, 1.0)) * 0.5 * viewport.zw;
  return vec3(xypos, dclip.z * 0.5 + 0.5);
}
  
void main() {

  vec3 stroke_c = vec3(stroke_color[0],stroke_color[1],stroke_color[2]);
  float stroke_c_avg = (stroke_c.r+stroke_c.g+stroke_c.b)/3.0;

  vec4 clip0 = transform * vertex;
  vec4 clip1 = clip0 + transform * vec4(direction.xyz, 0);
  
  // float thickness_mod = color.r;
  // if (thickness_mod<=0.15) thickness_mod = 0.15;
  // thickness_mod = thickness_mod;
  // float thickness = direction.w * stroke_weight * thickness_mod * 2.0;
  float thickness = direction.w * stroke_weight * 0.9 * 2.0;

  vec3 win0 = clipToWindow(clip0, viewport); 
  vec3 win1 = clipToWindow(clip1, viewport); 
  vec2 tangent = win1.xy - win0.xy;
  vec2 normal = normalize(vec2(-tangent.y, tangent.x));


  // float foo = 1.0;
  // if (stroke_c_avg >=0.98) foo = stroke_weight;

  // vec2 offset = normal * thickness * foo;
  vec2 offset = normal * thickness;

  gl_Position.xy = clip0.xy + offset.xy;
  gl_Position.zw = clip0.zw;

  // push back for halo effect
  if (push > 0. || push < 0.) gl_Position.z = clip0.z + (push/10.0);
  else gl_Position.z = clip0.z + (alpha*-.0015);

  // float z_fog = (abs(1.-((length(gl_Position.xyz)+1.) * 0.001)) * 1.)+.1;
  float z_fog1 = (pow(clip1.z,1.2) * .00005)*.4;
  float z_fog0 = 1.-(clip0.z * .00025)+0.1;

  // set color to assigned stroke color
  vec4 out_color;
  // out_color = color;
  // out_color.rgb = color.rgb;
  out_color.rgb = stroke_c + vec3(z_fog1,z_fog1,z_fog1);
  out_color.a = alpha;
  if (render_solid == 1) {
    out_color.rgb = stroke_c.rgb;
    out_color.a = 1.0;
  }
  else if (render_solid < 1) out_color.a *= (color.a * z_fog0)  ;
  if (out_color.a <= 0.07) out_color.a = 0.07;

  // out_color.rgb = vec3(z_fog0,z_fog0,z_fog0);
  // out_color.a = 1.;
  
  // out_color = color;
  vertColor = out_color;
  // vertColor = color;
    
}