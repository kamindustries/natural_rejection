#define PROCESSING_LINE_SHADER

uniform mat4 transform;
uniform vec4 viewport;

attribute vec4 vertex;
attribute vec4 color;
attribute vec4 direction;

varying vec4 vertColor;

uniform sampler2D texture;

uniform float stroke_weight;
uniform float stroke_color;
uniform float camera_pos[];

// uniform int gl_VertexID;
  
vec3 clipToWindow(vec4 clip, vec4 viewport) {
  vec3 dclip = clip.xyz / clip.w;
  vec2 xypos = (dclip.xy + vec2(1.0, 1.0)) * 0.5 * viewport.zw;
  return vec3(xypos, dclip.z * 0.5 + 0.5);
}
  
void main() {

  vec3 cam = vec3(camera_pos[0],camera_pos[1],camera_pos[2]);
  // vec3 xyzpos = transform.xyz;
  // vec3 view_scale = 

  vec4 clip0 = transform * vertex;
  vec4 clip1 = clip0 + transform * vec4(direction.xyz, 0);
  
  float thickness = direction.w * stroke_weight * pow(float(color.r), 3.0);
  
  vec3 win0 = clipToWindow(clip0, viewport); 
  vec3 win1 = clipToWindow(clip1, viewport); 
  vec2 tangent = win1.xy - win0.xy;
    
  vec2 normal = normalize(vec2(-tangent.y, tangent.x));
  vec2 offset = normal * thickness * 1.0;

  gl_Position.xy = clip0.xy + offset.xy;
  gl_Position.zw = clip0.zw;

  // set color to assigned stroke color
  vec4 out_color;
  // out_color.rgb = color.rgb;
  out_color.rgb = vec3(stroke_color,stroke_color,stroke_color);
  out_color.a = color.a;
  vertColor = out_color;  
    
}