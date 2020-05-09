
import java.util.Date;
import forU.Ttf.*;

public class ForZen implements ParamProvider {
  private final StringDict dict=new StringDict();
  private final ArrayList<String> params=new ArrayList<String>();
  boolean inComment=false;
  //boolean inDef=false;
  private String defining=null;
  private String defname=null;
  Doodle dude=null;//new Doodle();
  float rim=50; // corner rounding
  float scale=800;
  private int scanParam=0;

 public String [] defined(){return dict.keyArray(); }
  // Drawer dr=null;

  public ForZen (PathDrawer dr, float scale, float rim) {  
    //his.dr=dr;

    // fonttT=Ttf.get(); // last font loaded? or used?
    this.dude=new Doodle(dr);
    this.scale=scale-rim;
    this.rim=rim;
    
  }

  boolean verbose = true;
  ForZen verbose(boolean b) {
    verbose=b;
    return this;
  }

  void dprintln(String s) {
    if (verbose) PApplet.println(s);
  }

  public void clear() {
    dict.clear();
    begin(millis());
  }


  public ForZen begin(float t)
  {
    defining=null;
    params.clear();
    dude.clear().setParent(this);
    dude.t=t;

    dude.translate(rim/2, rim/2);
    dude.scale(scale);
    scanParam=0;
    return this;
  }

  public void end()
  {
    dude.close();
  }
  // Patamprovider callbavk

  Ttf fonttT =null;

  float doHere(boolean rot, boolean sca)
  {
    // getS(0) is our parameter p
    // dude.path has vertices in screen coords*k1000
    // execute p for each vertex...
    // 
    dude.push();
    // these factors should be unknown here
    // implent on dude level?
    dude.m().reset();
    float sc1000=PathDrawer.k1000*scale; 
    // mimic begin( )is wrong...
    // dude.translate(ofs/2, ofs/2);
    //  dude.scale(scale);
    // but this is ok??
    dude.scale(scale);
    // save the path for later restoring
    Paths pa=dude.path;
    dude.path=new Paths();
    for (Path paa : pa)//.get(0);
    {
      for (int i=0; i<paa.size(); i++) {

        PVector v=dude.get(paa, i);
        //  println("at "+v.x/scf+" "+v.y/scf);
        dude.push();
        dude.translate(v.x/sc1000, v.y/sc1000);
        dude.top().finalm=true; // omly use transforms up to hrre
        if(rot||sca){
          if(i<paa.size()-1){
            PVector to=dude.get(paa,i+1);
            
            to.sub(v);
            float a=to.heading();
            if (rot)
              dude.rotate(a);
            if(sca){
              dude.scale(to.mag()/sc1000);          
            }
          }
          else{
            dude.pop();
            break;
          }
          
        }
        execute(getS(0), 0);
        dude.pop();
      }
    }
    dude.path=pa;
    dude.pop();
    return 1.0f;
  }

  float renderTtf(String t) {
    if (fonttT==null) fonttT=Ttf.get();
    ShapeCreator r=fonttT.writeTo(dude);
    float ots=fonttT.textSize(1.00);
    PVector p=fonttT.text(t);
    fonttT.textSize(ots);
    fonttT.writeTo(r);
   // println("xt:"+p.x+" yt:"+p.y);
    dude.translate(-p.y,p.x);
    return 1.0f;
  }


  String getS(int i) {
    String s=getParam(params.size()-1-i);
    // println( "hetS "+s);
    return s;
  };

  float get(int i) {
    return new Float(getS(i));
  }

  float get(String whatta) {
    //float s=second();
    // dividers of PI
    String[] sp=split(whatta, "#");
    String was="", it ="";
    String what=sp[0];
    if (sp.length>1) was=sp[1];
    if (sp.length>2) it=sp[2];
    if ( "millis".equals(what))
      return (1000.0/(millis()%1000.0));
    if ( "second".equals(what)) 
      return 60.0/(second()%60.0);
    if ( "minute".equals(what))
      return 60.0/( minute ()%60);
    if ( "hour".equals(what))
      return 12.0/hour();
    if ( "hourhand".equals(what))
      return 12.0/(hour()+(minute()%60.0)/60);
    if ( "frames".equals(what))
      return 10.0/frameRate;
    if ( "N-1".equals(what))
      return (float(getS(0))*1.0)-1.0;
    if ( "Frame".equals(what))
      return renderTtf(""+frameCount);
    if ( "Date".equals(what))
      return renderTtf(""+new Date());
    if ( "\"".equals(what)) {   
      return renderTtf(was);
    }
    if ( "include".equals(what)) {   
      execute(loadLocalStrings(was));
      return 1.0f;
    }
    if ( "Text".equals(what)) {   
      if (("".equals(was))) {
        return renderTtf(getS(0));
      }
      return renderTtf(was);
    }
    if ( "Font".equals(what)) { 
      // println("font "+was+"&"+it);
      if (!("".equals(it))) {
        fonttT=Ttf.loadFont(was, fontdir+it);
        if (sp.length>3) {
          fonttT.lineFactor=float(sp[3]);
        }
      } else 
      fonttT=Ttf.get(was);   
      return 1.0f;
    }
    if ( "Here".equals(what)) { 
      return doHere(false, false);
    }
    if ( "HereR".equals(what)) { 
      return doHere(true, false);
    }
   if ( "HereRS".equals(what)) { 
      return doHere(true, true);
    }

    println("Unknown callback \""+whatta+"\"");
    throw new IllegalArgumentException("Unknown callback '"+whatta+"'");
    //  return dude.MURKS;
  }

  /*
  void dump(){
   int ps=0;
   for(String s:params.){
   println("stack"+ps+": "+getParam(ps));
   ps++;
   }
   }
   */


  void pushParam() { 
    params.add("");
  }

  String getParam(int np) {
    String r="";

    if (np>=0&&np<params.size()) 
      r=params.get(np);
    // println("getparam["+np+"]: "+r);
    return r;
  }

  private void appendParam( String s) {
    // there
    //println("append:"+s);
    int ix=params.size()-1;
    params.set(ix, params.get(ix)+
      " "+s);
    // println("->"+getParam(ix));
  } 

  private void dropParams(int mytop) {
    for (int i=params.size()-1; 
      i>=mytop&&i>0; 
      i--) {
      params.remove(i);
    }
  }

  public ForZen execute(String s, int plimit)//ArrayList<String> passed)
  {
    Tokenizer t=new Tokenizer(s); 

    // println("execote "+params.size()+s);
    // dump();

    int mytop=params.size()-scanParam;

    //pushParam(); 
    for (String to=t.next(); to!=null; to=t.next()) {
      if ("/*".equals(to)) {
        inComment = true;
        continue;
      };

      if (inComment) {
        if ("*/".equals(to)) {
          inComment=false;
        }
        continue;
      };

      if (";".equals(to)) {
        dict.set(defname, defining);
        defining=null;
        continue;
      }
      if (defining!=null) {
        defining+=" "+to;
        continue;
      } 

      if ('$'==to.charAt(0)) {
        int np=0;
        if (to.length()>1) {
          char nxt=to.charAt(1);
          if (Character.isDigit(nxt)) {
            {

              np=nxt-'0';
            }
          }
        }
        String thisParam=getParam(mytop-np-1);

        if (scanParam>0) {
          // inside a paranm definition, expand it
          appendParam(thisParam);
        } else {
          //  println("executing param -"+np);
          execute(thisParam, mytop);
          dropParams(mytop);
        }
        continue;
      }

      if ("(".equals(to)) {
        scanParam++;
        if (scanParam>1) {
          // inside parameter, copy
          // always to the top
          appendParam( to);
        } else  
        {
          // start s parameter definition
          pushParam();
        }
        continue;
      };

      if (")".equals(to)) {
        scanParam--;
        if (scanParam<=0) {
          // ends this definition, fine
          continue;
        } else {
          appendParam(to);
          continue;
        }
      }
      if (",".equals(to)) {
        // just do nothing???...
        // will raise error if not in param

        if (scanParam>1) {
          appendParam( to);
        }
        // another param
        else 
        pushParam();
        continue;
      }

      if (scanParam>0) {

        appendParam(to);
        continue;
      }
      if (dict.hasKey(to)) {
        // println( "call :"+to+" using: "+mytop);
        //params.get();

        execute(dict.get(to), mytop);
        dropParams(mytop);
        // 
        // discard
        // 
        continue;
      }



      switch(to.charAt(0)) {
      case ':':
        // if(defining!= null) // cant happen..
        defname=to.substring(1);
        defining="";
        break;

      case '.':
        dude.emit(to.substring(1));
        break;
      case '#':
        // reflect to ourself
        get(to.substring(1));
        break;
      default:
        //println("oopsie,what is "+to);
        try {
          // just feed through....
          dude.emit(to);
        }
        catch( IllegalArgumentException e) {     
          //throw new IllegalArgumentException
          println(e.getMessage());
          println
            ("ForZen: unknown '"+to+"' in "+s);
          throw e;
        }
        break;
      }
    }

    return this;
  }


  ForZen execute(String[] stuff) {

    for (String s : stuff) {
      execute(s, 0);
    }
    return this;
  }
} // forzen
