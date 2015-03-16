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

  // vec3 stroke_c = vec3(stroke_color[0],stroke_color[1],stroke_color[2]);
  float c_ceil = color.r*color.r;
  // if (c_ceil <= .5) c_ceil = .7;
  // vec3 stroke_c = vec3( abs(1.-c_ceil),
  //                       abs(1.-c_ceil),
  //                       abs(1.-c_ceil));
  vec3 stroke_c = vec3(c_ceil,c_ceil,c_ceil);

  vec4 clip0 = transform * vertex;
  vec4 clip1 = clip0 + transform * vec4(direction.xyz, 0);
  
  float thickness_mod = color.r;
  if (thickness_mod<=0.15) thickness_mod = 0.15;
  thickness_mod *= thickness_mod;
  // float thickness = direction.w * stroke_weight * thickness_mod * 2.0;
  // float thickness = direction.w * stroke_weight * 1.0 * 2.0;
  float thickness = direction.w * thickness_mod * 1.0 * 2.0;

  vec3 win0 = clipToWindow(clip0, viewport); 
  vec3 win1 = clipToWindow(clip1, viewport); 
  vec2 tangent = win1.xy - win0.xy;
  vec2 normal = normalize(vec2(-tangent.y, tangent.x));
  
  vec2 offset = normal * thickness;

  gl_Position.xy = clip0.xy + offset.xy;
  gl_Position.zw = clip0.zw;

  // push back for halo effect
  if (push > 0. || push < 0.) gl_Position.z = clip0.z + (push/10.0);
  else gl_Position.z = clip0.z + (alpha*-.0015);

  float z_fog1 = (clip1.z * .0004)-0.;
  float z_fog0 = 1.-(clip0.z * .0004)-0.2;

  // set color to assigned stroke color
  vec4 out_color;
  out_color.rgb = stroke_c;
  // out_color.rgb += (z_fog1*.5);
  // out_color.a = alpha;
  out_color.a = z_fog0;
  if (out_color.a <= 0.03) out_color.a = 0.03;
  if (out_color.a >= 0.3) out_color.a = 0.3;
  // out_color.rgb = vec3(color.r,color.r,color.r);
  // out_color.a = 1.;
  
  // out_color = color;
  vertColor = out_color;
  // vertColor = color;
    
}