#define PROCESSING_POINT_SHADER
uniform mat4 projection;
uniform mat4 modelview;
uniform float weight;
uniform vec4 viewport;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;
varying vec2 texCoord;

uniform float stroke_color[];
uniform float mouse[];


void main() {
  vec3 stroke_c = vec3(stroke_color[0],stroke_color[1],stroke_color[2]);
  vec2 mouse = vec2(mouse[0], mouse[1]);
  float new_weight = weight;
  // float new_weight = 10.;

  vec4 pos = modelview * vertex;
  vec4 clip = projection * pos;

  vec4 foo_mat = clip + projection * vec4(offset, 0., 0.);
  
  float z_fog = 1.0-abs(length(foo_mat.xyz) * 0.0001);

  float dx = 2. * (viewport.z - mouse.x) / viewport.z - 1.;
  float dy = 2. * (viewport.w - mouse.y) / viewport.w - 1.;
  vec4 mouse_vec = vec4(dx, -dy, -1., 1.);
  vec4 mouse_to_clip = mouse_vec - foo_mat;

  float fm = 120.;
  float fm2 = 100000.;

  foo_mat.z = abs(foo_mat.z);
  if (foo_mat.z <= fm) foo_mat.z = fm;

  float mouse_a = 1. * dot(foo_mat.xyz, foo_mat.xyz);
  float mouse_b = 1. * dot(mouse_vec.xyz, mouse_to_clip.xyz);
  // float mouse_c = 1. * dot(foo_mat.xyz, foo_mat.xyz) - (5. * 5.);
  // float detect = (mouse_b*mouse_b) - 4.*mouse_a*mouse_c;
  // float f1 = (mouse_b + sqrt((detect))) / (2. * mouse_a);
  float f = -(mouse_b) / (2. * mouse_a);

  // float mouse_scale = abs(length(mouse_vec - clip.xyz));
  float mouse_dot = dot(mouse_vec.xyz, mouse_to_clip.xyz);
  float mouse_dot_sqrt = sqrt((mouse_dot));
  float mouse_scale = (f) * 960.;
  float m_min = .25;
  float m_max = 1.5;
  // mouse_scale = 1.-abs(mouse_scale * weight * weight);
  float t1 = 1.-(mouse_scale * .6 * .6);
  mouse_scale = t1 * 1.;
  mouse_scale *= log(1./mouse_scale) * -.25;
  // if (mouse_scale <= 0.1) mouse_scale = weight;
  // if( mouse_scale >= m_max) mouse_scale *= 1./log(100.);
  // if (mouse_scale <= 1.0) mouse_scale = 1.;
  // if (mouse_scale >= m_max) mouse_scale *= 1./sqrt(mouse_scale);
  // if (mouse_scale <= m_min) mouse_scale += abs(m_min * mouse_scale * -1.);
  // if (mouse_scale <= .1) mouse_scale = .3;

  // float clamp_z = abs(foo_mat.z);
  // clamp_z = .01 * clamp_z;
  // float z_min = .1;
  // float z_max = mouse_scale * .5;
  // if (clamp_z <= z_min) clamp_z = z_min * .9;
  // if (clamp_z >= z_max) clamp_z = z_max;
  // mouse_scale = (mouse_scale + clamp_z);
  // mouse_scale *= mouse_scale;
  // mouse_scale *= mouse_scale;
  // if (mouse_scale <= m_min) mouse_scale = m_min;
  // if (mouse_scale >= 2.) mouse_scale = 2.;

  vec2 new_offset = offset;
  new_offset.xy *= vec2(mouse_scale,mouse_scale);
  vec4 out_position = clip + projection * vec4(new_offset, 0., 0.);
  gl_Position.xyw = out_position.xyw;
  gl_Position.z = out_position.z - 0.01;

  // new_weight *= dx;
  // new_weight += 10.;
  // new_weight = 10.;


  texCoord = (vec2(0.5) + offset / (new_weight * 100.));

  vec4 out_color;


  out_color.rgb = stroke_c;
  out_color.a = color.a * z_fog;
  // out_color.g = foo_mat.z;
  float mouse_color = clamp(mouse_scale*2., 0., 1.0);
  out_color.rgb += vec3(mouse_color,mouse_color*.25,mouse_color*.1);
  out_color.rgb *= z_fog;
  // out_color.g = 1.0;
  vertColor = out_color;


}