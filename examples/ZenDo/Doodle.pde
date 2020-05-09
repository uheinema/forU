

interface ParamProvider {
  float get(int i);
  float get(String s);
}


class Doodle extends ClipDrawer implements ShapeCreator{
  //ClipDrawer dr;
  ParamProvider parent;
  float t ; // set to eg. millis()

  public Doodle(PathDrawer dr) {
  //  this.dr=dr;
    super(dr);
  };
  
  public Doodle setParent(ParamProvider p) {
    parent=p;
    return this;
  }
 /* public Doodle setDrawer(PathDrawer p) {
    dr.dr=p;
    return this;
  }*/
  public Doodle clear() {
    tstack.clear();
    pstack.clear();
    clipstack.clear();
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
final ArrayList<Paths> clipstack= new ArrayList<Paths>();
  ;

  private class Trans //extends PMatrix2D 
  {
    int isSpecial=0;
    boolean finalm=false;
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
          if(port.finalm) return v;
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
      clipstack.add(path);
      pstack.add(theClip);
      limit(path);
      break;
    case ']':
      theClip=pstack.get(pstack.size()-1);
      pstack.remove(pstack.size()-1);
      path=clipstack.get(clipstack.size()-1);
      clipstack.remove(clipstack.size()-1) ;
      reserve(path);
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
      createShape();
      break;
    case 'h': // hole
      beginContour();
      break;
    case 'v':    
      vertex();
      break;
    case 'e':
      Paths r=path;
     // path=curve(path,k1000*k1000);
      endLine();
      path=r;
      break;
    case 'c': // convert to curves
      path=curve(path, def(m,20)*k1000); 
      break;
   // case 'f': // useless??
   //   path=finer(path, 20*k1000);
    //  break;
    case 'i':
      path=inflateRound(path,unit()*k1000/def(m, 1));
      break;
    case 'd': // deflate, drprecated?
      path=inflateRound(path,unit()*-k1000/def(m, 1));
      break;
    case 'm': // miter
      path=inflateMiter(path,unit()*k1000/def(m, 1));
      break;
     case 'L': // line inflate
      path=inflateRoundLine(path,unit()*k1000/def(m, 1));     
      break;
     case 'R':
      path=inflateRoundString(path,unit()*k1000/def(m, 1));     
      break;
     case 'P':
      path=inflateMiterString(path,unit()*k1000/def(m, 1));     
      break;
     
     case 'M':
      path=inflateMiterLine(path,unit()*k1000/def(m, 1));
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
      
      modifier=acceptNumber(MURKS);
      if (accept('$')) {
        if(accept('t')){
          modifier=def(modifier,1.0)*1000.0/t; // seconds..
        }
        else if(accept('#')){
          modifier=def(modifier,1.0)*parent.get(rest());
        }
        else
          modifier=parent.get(int(acceptNumber(0)));
      }          
      emit( cmd, modifier);
    }
  }




  void vertex() {
    vertexi(0, 0);
  }
  
  private final PVector last=new PVector(0,0);;
  
  
  void vertex(float x,float y) {
   // println("vx: "+x+" "+y);
    last.x=x;
    last.y=y;
     vertexi(-y,x);
    }
    
void vertexi(float x,float y) {
    PVector v=new PVector(x, y);
    v=tstack.apply(v);
    vertexRaw(v.x, v.y);
  }

  void vertexRaw(float x, float y) {
    path.add(k1000*x, k1000*y);
  //  println("v: "+x+" "+y);
  }

  void createShape(){
    path=new Paths();//or clear?
  }
  void beginShape() {
    path.add(new Path());
    //beginContour();
  }

  void endShape(int mode) {
    if(mode==CLOSE)
      close(path);
    
    // dr.end()
  }
  
  void beginContour(){
    path.add(new Path());
  }
  
  void endContour(){close(path);};
  
  void curveVertex(float x, float y){
    // todo, but not needed by ttf
    
    vertex(x,y);
  }
  
  public void quadraticVertex(float cx, float cy,
                      float x3, float y3) {
    // guess step count...
    float deltaa=30; // ???
    PVector to= new PVector(x3,y3);
    // we are in the characters coord system
    // steps should depend on target distance,
    // ie. w/ apply ( and msybe k1000?)...todo
   float d=last.dist(to);
    int steps=floor(max(2,d*deltaa));
    if(steps>6) steps=6;
  //println("steps "+steps+" for "+d);
    doQuadSteps(steps,last,
     new PVector(cx,cy),
     new PVector(x3,y3));
    vertex(x3,y3);
  }
  
  void doQuadSteps(int steps,
         PVector p1,
         PVector c1,PVector p2){
     
      float delta=1.0f/steps;
      float u=0;
      for (int ii=1; ii<steps; ii++) {
        u+=delta;
        float x=quadraticPoint(p1.x, c1.x, p2.x, u);
        float y=quadraticPoint(p1.y, c1.y, p2.y, u);
        vertex(x, y);
      }
  }
  // use def= 20*k1000...
  
  public float quadraticPoint(float a, float b, float c, float t) {
    return bezierPoint(a, 
      a + ((b-a)*2/3.0f), 
      c + ((b-c)*2/3.0f), 
      c, 
      t);
  }
  
  public float bezierPoint(float a, float b, float c, float d, float t) {
    float t1 = t-1.0f;
    return t * ( 3*t1*(b*t1-c*t) + d*t*t ) - a*t1*t1*t1;
  }
  
  void endLine() {
    //  fill(0);
    // stroke(0);
    // println("l:");
    
    drawLine(path);
  }

  PVector get(Path pa, int i) {
    Point.LongPoint p=pa.get(i);
    return new PVector(p.x, p.y);
  }

float unit() {
    PVector v=tstack.apply(new PVector(0, 0));
    return v.dist(tstack.apply(new PVector(1, 0)) ); 
}
  
  @Deprecated
  void inflateby(float w,boolean forline) {
    float l=w*unit();
    path=(forline 
      ? inflateMiterLine(path, l)
      : inflateRound(path, l));
  }
} // doodle
