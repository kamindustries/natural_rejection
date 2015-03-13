///////////////////////////////////////////////////////////////////////
// Branch class
///////////////////////////////////////////////////////////////////////
class Branch {
  Branch parent;
  PVector position, grow_dir;
  int children;
  int depth;

  Branch(Branch _parent, PVector _position, PVector _grow_dir, int _children, int _depth) {
    parent = _parent;
    position = _position;
    grow_dir = _grow_dir;
    children = _children;
    depth = _depth;
  }
}