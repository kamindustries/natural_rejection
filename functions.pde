///////////////////////////////////////////////////////////////////////
// Return ray
///////////////////////////////////////////////////////////////////////
Ray3D PickRay(float[] _cam_pos){

  PMatrix3D proj = p3d.projection.get();
  PMatrix3D modvw = p3d.modelview.get();
  PVector cam = new PVector(_cam_pos[0],_cam_pos[1],_cam_pos[2]);

  // GluLookAt  ...
  float x = 2* ((float)mouseX) / (float)width - 1;
  float y = 2* ((float)height - (float)mouseY) / (float)height - 1;
  float z = 1.0;
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
float IntersectSphere(Ray3D _r, PVector _cen, float _radius){

  Vec3D _d = _r.getDirection();
  PVector d = new PVector(_d.x, _d.y, _d.z);
  PVector o = new PVector(_r.x, _r.y, _r.z);

  PVector o_c = PVector.sub(o, _cen);
  float a = d.dot(d);
  float b = 2. * (d.dot(o_c));
  float c = (o_c.dot(o_c)) - _radius * _radius;
  float detect = b*b - 4*a*c;

  if(detect > 0.0) {
    float t1 = (-b - sqrt(detect)) / (2.0 * a);
    if(t1 > 0.0) return t1;
    float t2 = (-b + sqrt(detect)) / (2.0 * a);
    if (t2 > 0.0) return t2;
  }
  else if (detect == 0.0) {
    float t = -b / (2.0 * a);
    if (t > 0.0) return t;
  }

  return -1.0; //we ignore negative intersections, -1 qualifies as a miss
}

///////////////////////////////////////////////////////////////////////
// K E Y B O A R D
///////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'h'){
    if (show_hud==true) show_hud=false;
    else if (show_hud==false) show_hud=true;
  }
  if (key == 'H'){
    if (show_fps==true) show_fps=false;
    else if (show_fps==false) show_fps=true;
  }
}