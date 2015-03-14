class Cube {
  // variables
  int id;          // id
  float x, y, z, w;  // position (x, y, z) and width (w)
  color c;         // color (in scene, not buffer)
  boolean update;
  // constructor
  public Cube(int id, float x, float y, float z, int w, boolean _update) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.update = _update;
    c = color(random(255), 250, 50);
  }
  // make the color change
  public void changeColor() {
    // int r = (int)red(c);
    // int g = (int)green(c);
    // int b = (int)blue(c);
    // c = color(r, 255 - g, b);
    // c = color(255,0,0);
    float r = LerpVal();
    float g = LerpVal();
    float b = LerpVal();
    c = color(r,g,b);
    update = false;
  }
  public void resetColor() {
      int r = (int)red(c);
      int g = (int)green(c);
      int b = (int)blue(c);
      // c = color(r, 255 - g, b);
      c = color(0,0,0);
      update = true;
  }
  // display the cube on screen
  public void display(PGraphics ecran) {
    // ecran.fill(c);
    ecran.stroke(c);
    drawCube(ecran);
  }
  // draw the cube in the buffer
  public void drawBuffer(PGraphics buffer) {
    color idColor = getColor(id);
    // buffer.fill(idColor);
    buffer.stroke(idColor);
    drawCube(buffer);
  }
  private void drawCube(PGraphics g) {
    g.strokeWeight(10);
    g.pushMatrix();
    g.translate(x, y, z);
    // ellipse(0,0,w,w);
    // g.box(w);
    g.point(0,0,0);
    // sphere(w);
    g.popMatrix();
    update = true;
  }
}