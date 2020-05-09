


public class ForZen implements ParamProvider {
  private final StringDict dict=new StringDict();
  private final ArrayList<String> params=new ArrayList<String>();
  boolean inComment=false;
  //boolean inDef=false;
  private String defining=null;
  private String defname=null;
  Doodle dude=null;//new Doodle();
  int ofs=50; // corner rounding
  int wid=800;
  private int scanParam=0;

  // Drawer dr=null;

  public ForZen (PathDrawer dr) {  
    //his.dr=dr;
    this.dude=new Doodle(dr);
    begin();
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
    begin();
  }


  public void begin()
  {
    defining=null;
    params.clear();
    dude.clear().setParent(this);
    dude.t=millis();

    dude.translate(ofs/2, ofs/2);
    dude.scale(wid+ofs);
    scanParam=0;
  }

  // Patamprovider callbavk

  String getS(int i) {
    String s=getParam(params.size()-1-i);
    //println( "hetS
    return s;
  };

  float get(int i) {
    return new Float(getS(i));
  }

  float get(String what, String was) {
    //float s=second();
    // dividers of PI
    if ( "millis".equals(what))
      return (1000.0/(millis()%1000.0));
    if ( "second".equals(what)) 
      return 60.0/(second()%60.0);
    if ( "minute".equals(what))
      return 60.0/(minute()%60);
    if ( "hour".equals(what))
      return 12.0/hour();
    if ( "hourhand".equals(what))
      return 12.0/(hour()+(minute()%60.0)/60);
    if ( "frames".equals(what))
      return 10.0/frameRate;
    if ( "N-1".equals(what))
      return (float(was)*1.0)-1.0;

    println("callback \""+what+"\"");
    throw new IllegalArgumentException("unknown callback "+what);
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

  public ForZen execute(String s)//ArrayList<String> passed)
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
          execute(thisParam);
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

        execute(dict.get(to));
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
      execute(s);
    }
    return this;
  }
} // forzen
