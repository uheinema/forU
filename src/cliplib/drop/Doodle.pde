

interface ParamProvider {
  float get(int i);
  float get(String s);
}


class Doodle {
  Drawer dr;
  ParamProvider parent;
  float t ; // set to eg. millis()

  public Doodle(Drawer dr) {
    this.dr=dr;
  };
  public Doodle setParent(ParamProvider p) {
    parent=p;
    return this;
  }
  public Doodle setDrawer(PathDrawer p) {
    dr.dr=p;
    return this;
  }
  public Doodle clear() {
    tstack.clear();
    pstack.clear();
    path.clear();
    return this;
  }
  
  /*
  final ArrayList<Item> stack=new ArrayList<Item>();
   class Item {
   String it;
   Item(String s) {
   it=s; // or copy?
   }
   }; // item
   */
  Paths path=new Paths();
  final TStack tstack=new TStack();
  final ArrayList<Paths> pstack= new ArrayList<Paths>();
  ;


  private class Trans //extends PMatrix2D 
  {
    int isSpecial=0;
    PMatrix3D m;
    Trans() {
      // super();
      m=new PMatrix3D();
    };

    Trans(Trans t) {
      //super(t);
      m=new  PMatrix3D(t.m);
      // leave special there
    }

    PVector applySpecial(PVector on) {
      switch(isSpecial) {
      case 2:
        float d=on.x;
        float a=on.y*PI/2;
        return
          new PVector(
          d*cos(a), 
          d*sin(a)
          );
      case 1:
        return
          new PVector(
          on.x+(noise(on.y+t/10000.0+10)-0.5), 
          on.y+noise(on.x+t/10000.0)-0.5);
      case 3:
        return
          new PVector(
          on.x+(noise(on.x+t/10000.0+10)-0.5), 
          on.y+noise(on.y+t/10000.0)-0.5);
      default: 
        return on;
      }
    }
  } // trans

  class TStack extends ArrayList<Trans> {
    static final long serialVersionUID=666;
    TStack() {
    };

    Trans top() {
      if (size()<1) {
        push(new Trans());
      }
      return get(size()-1);
    }



    void push(Trans t) {
      add(t);
    }

    void pop() {
      remove(size()-1);
    }

    PVector apply(PVector v) {
      boolean applied=false;
      for (int i=size()-1; i>=0; i--) {

        Trans port=get(i);

        if (port.isSpecial!=0) {
          v=port.applySpecial(v);
          applied=false;
        }
        if (!applied) {
          port.m.mult(v, v);
          // apply(this);
          //  v=get(i).apply(v);
          applied=true;
        }
      }
      return v;
    }

    void push() {
      if (top().isSpecial!=0) { // need to apply that to
        // the local nonlinear coords
        push(new Trans());
      } else // linear transforms are cumulativ
      {    
        push(new Trans(top()));
      }
    }
  } // tstack



  //Trans here=new Trans();
  void translate(float x, float y) {
    m().translate(x, y);
  }
  void rotate(float angle) {
    m().rotate(angle);
  }
  void scale(float s) {
    m().scale(s, s);//s);
  }
  
  void scale(float x,float y) {
    m().scale(x, y);//s);
  }

  PMatrix3D m() {
    return top().m;
  }

  Trans top() {
    return tstack.top();
  }
  void pop() {
    tstack.pop();
  }
  void push() {
    tstack.push();
  }


  final float MURKS=1110860E19;

  private float def(float modifier, float def) {
    if (modifier==MURKS) return def;
    return modifier;
  }

  void emit(char cmd, float m) {
    // println(" "+cmd+" "+m);
    switch(cmd) {
    case '/' :
      scale(1/def(m, sqrt(2)));
      break;
    case '*':
      scale(def(m, sqrt(2)));
      break;
    case 'X':
      scale(def(m, sqrt(2)),1.0);
      break;
    case 'Y':
      scale(1.0,def(m, sqrt(2)));
      break;
    case '|':
       scale(-1.0,1.0);
       break;
    case 'x':
      translate(1/def(m, 1), 0);
      break;
    case 'y':
      translate(0, 1/def(m, 1));
      break;
    case '>':
      //case 'r':
      rotate(TWO_PI/def(m, 4));
      break;
    case 'r':
      reserve(path);
      break;
    case 'l':
      limit(path);
      break;
    case '[':
      pstack.add(theClip);
      break;
    case ']':
      theClip=pstack.get(pstack.size()-1);
      pstack.remove(pstack.size()-1);
      break;
    case '<':
      rotate(-TWO_PI/def(m, 4));
      break;
    case '{':
      push();
      break;
    case '}':
      pop();
      break;
    case '!':
      top().isSpecial=(int)def(m, 1);
      break;
    case 'b':
      begin();
      break;
    case 'v':    
      vertex();
      break;
    case 'e':
      endLine();
      break;
    case 'c': // convert to curves
      path=curve(path, 20*k1000);
      break;
    case 'f': // useless??
      path=finer(path, 20*k1000);
      break;
    case 'i':
      inflateby(k1000/def(m, 1));
      break;
    case 'd': // deflate
      inflateby(-1.0*k1000/def(m, 1));
      break;
     case 'L': // line inflate
      inflateby(k1000/def(m, 1),true);
      break;
    case ' ':
      break;
    default:
      throw new IllegalArgumentException("unknown emit "+cmd);
    }
  }

  String emiting;
  int cmdi;

  char next() {
    if (cmdi>=emiting.length())
      return ' ';
    else
      return emiting.charAt(cmdi);
  }

  boolean accept(char c) {
    if (next()==c) {

      cmdi++;
      return true;
    } else
      return false;
  }

  char accept() {
    char c=next();
    cmdi++;
    return c;
  }

   String rest(){
     int i=cmdi;
     cmdi=123345;
     return emiting.substring(i);
   }
   
  float acceptNumber(float def) {

    int dot=0;
    float n=0;
    int frac=-1;
    int neg=1;
    
    if(accept('-')){
       neg=-1;
    }
    while ( Character.isDigit(next())) {
      n*=10;
      n+=int(next()-'0');
      cmdi++;
      dot++;
      if (frac>=0) frac++;
      else{
        if (accept('.')) {
          frac=0;
        }
      }
    }
    for (; frac>0; frac--) {
      n/=10;
    }
    if (dot>0) 
    return n*neg;
    else
      return def;
  }

  boolean isMurks(float f) {
    return f==MURKS;
  }

  public void emit(String cmds) {
    emiting=trim(cmds);
    cmdi=0;
    //  println("emit: "+cmds);
    for (; cmdi<emiting.length(); ) {
      float modifier=MURKS;
      char cmd=accept();
      
      if (accept('$')) {
        
        if(accept('t')){
          modifier=1000.0/t; // seconds..
        }
        else if(accept('#')){
          modifier=parent.get(rest());
        }
        else
          modifier=parent.get(int(acceptNumber(0)));
      } else
        modifier=acceptNumber(MURKS);     
      emit( cmd, modifier);
    }
  }




  void vertex() {
    PVector v=new PVector(0, 0);
    v=tstack.apply(v);
    vertex(v.x, v.y);
  }

  void vertex(float x, float y) {
    path.add(k1000*x, k1000*y);
    //println("v: "+x+" "+y);
  }

  void begin() {
    path=new Paths();//or clear?
    // dr.begin();
    // println("b:");
  }

  void end() {
    // dr.end()
  }
  void endLine() {
    //  fill(0);
    // stroke(0);
    // println("l:");
    dr.drawLine(path);
  }

  PVector get(Path pa, int i) {
    Point.LongPoint p=pa.get(i);
    return new PVector(p.x, p.y);
  }

  Path curve(Path p, float detail) {
    Path s=new Path();
    int i;
    if (p.size()<4) {
      return p;
    }
    s.add(p.get(1));
    for (i=1; i<p.size()-2; i++) {
      // first point is already set
      // guess length of segment
      PVector c1=get(p, i-1);
      PVector p1=get(p, i);  
      PVector p2=get(p, i+1); 
      PVector c2=get(p, i+2);
      float guess=p1.dist(p2);
      float steps=guess/detail;
     // if (steps<3) steps=3;
      steps=round(steps);
      float delta=1.0/steps;
      float u=delta;
      for (; u<1.0; u+=delta) {
        float x=curvePoint(c1.x, p1.x, p2.x, c2.x, u);
        float y=curvePoint(c1.y, p1.y, p2.y, c2.y, u);
        s.add(x, y);
      }
      s.add(p2.x, p2.y);
    }
    return s;
  }
  Paths curve(Paths ps, float detail) {
    Paths s=new Paths();
    for (Path p : ps) {
      s.add(curve(p, detail));
    }
    return s;
  }
  Paths finer(Paths ps, float detail) {
    Paths s=new Paths();
    for (Path p : ps) {
      s.add(finer(p, detail));
    }
    return s;
  }


  Path finer(Path p, float detail) {
    Path s=new Path();
    int i;
    if (p.size()<2) {
      return p;
    }
    s.add(p.get(1));
    for (i=0; i<p.size()-1; i++) {
      // first point is already set
      // guess length of segmen
      PVector p1=get(p, i);  
      PVector p2=get(p, i+1); 

      float guess=p1.dist(p2);
      float steps=guess/detail;
      //if(steps<1) steps=1; // 
      steps=round(steps);
      float delta=1.0/steps;
      float u=delta;
      for (; u<1.0; u+=delta) {
        float x=lerp(p1.x, p2.x, u);
        float y=lerp(p1.y, p2.y, u);
        s.add(x, y);
      }
      s.add(p2.x, p2.y);
    }
    return s;
  }
  // seperate here, so we can inflate it
  // path is in screen longints...
  // path=curve(path,20); // detail

  void inflateby(float w) {
  inflateby(w,false);
  }
  
  void inflateby(float w,boolean forline) {
    PVector v=tstack.apply(new PVector(0, 0));
    float l=w*v.dist(tstack.apply(new PVector(1, 0)) ); 
    
    path=(forline 
      ? inflateClosed(path, l)
      : inflate(path, l));
  }
} // doodle
