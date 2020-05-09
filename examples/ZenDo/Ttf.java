/**
 * 
 * 
 * 
 */

import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.ByteOrder;


import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

import processing.core.*;

interface Cmap {
  // int format;
  int get(int i);
}

public class Ttf {

  // hack to fix line spacing
  public float lineFactor= 1.0f;
  
  private float lineHeight() {
    /// ????
    return //1.0f/scaleF
   (ascent
   - descent // is negative (and too large?!
  +lineGap ) * lineFactor // as per glyphsapp.com
   
   
  // yMax-yMin+lineGap 
   ;
   //1.5f* (ascent+descent+lineGap);
  }

  static
    public PApplet me; // set this or a shack...

  static final public HashMap<String, Ttf> fontCache=
    new HashMap<String, Ttf>();
  static String beatNick;
  
  static Ttf loadFont(String nick, String filename) {
    if (fontCache.containsKey(nick)) {
      return fontCache.get(nick);
    }
    Ttf nf=new Ttf(filename); 
    fontCache.put(nick, nf);
    beatNick=nick;
    return nf;
  }

  static Ttf get(String nick) {
    if (fontCache.containsKey(nick)) {
      return fontCache.get(nick);
    }
    return null;// loadFont(nick, nick);
  }

  static Ttf get() {
    return get(beatNick);
  }

  static void set(String nick) {
    beatNick=nick;
  }

  private ShapeCreator shack;
  ShapeCreator Shack(ShapeCreator s) {
    ShapeCreator t=shack;
    shack=s;
    return t;
  }

  String name;
  ByteBuffer file;
  int scalarType;
  short numTables;
  int searchRange, entrySelector, 
    rangeShift;
  int length;
  HashMap<String, Table> tables;
  HashMap<Integer,Glyph> glyphCache;
  
  int size() { 
    real() ;
    return length;
  }

  ShapeCreator shacka() {
    if (shack==null) shack=new defSc();
    return shack;
  }


  class defSc implements ShapeCreator {    
    public void createShape() {
    };
    public  void beginShape() { 
      // logprintln("shapebegin");
      me.beginShape() ;
    };
    public void vertex(float x, float y) {
      me.vertex(x, y);
    };
    public void endShape(int mode) {
      me.endShape(mode);
    };
    public void quadraticVertex(float cx, float cy, 
      float x, float y) {
      me.quadraticVertex(cx, cy, x, y);
    };
    public void curveVertex(
      float x, float y) {
      me.curveVertex(x, y);
    };
    public void beginContour() {
      me.beginContour();
    };
    public void endContour() {
      me.endContour();
    };
  }


  /*
  PrintWriter log1;
   boolean logging=true;
   
   PApplet me=this;
   
   void logprintln(String s){
   if(!logging) return;
   log1.println(s);
   log1.flush();
   }
   */

  void logprintln(String t) {
     PApplet.println(t);
  }

  public Ttf(String name) { 

    this.name=name;
    // delayed set
    file=null;
    //set(mapFile(name));
  }

  public void real() {
    if (file==null) set(mapFile(name));
  }

  public Ttf(ByteBuffer file) {
    set(file);
  }



  void set(ByteBuffer file) {
    this.file=file;
    file.order(ByteOrder.BIG_ENDIAN) ;
    loadTables();
    this.length = this.getGlyphCount();
    loadCmap();
    readHheaTable();
    glyphCache=new HashMap<Integer,Glyph>();
    logprintln("loadhead bot "+version+" length: "+this.length);
    logprintln("unitsPerEm: "+unitsPerEm);
  }

  int getGlyphCount() {
    real();
    int ofs=this.tables.get("maxp").offset + 4;
    logprintln("maxp offset "+ofs);
    file.position(ofs);
    int count = this.filegetUint16();
    return count;
  }


  private String getString(int n) {
    byte buf[] =new byte[n];
    file.get(buf );//,0,n);
    return new String(buf);
  }

  private class Table {
    int cs, offset, length;
    String tag;
    Table(String tag) {
      this.tag=tag;
      cs= file.getInt();    
      offset=file.getInt();    
      length=file.getInt();
      logprintln("table "+tag+" "+length);
    }
  }
  int filegetUint32() { 
    return file.getInt();
  };

  int filegetUint16() { 
    return file.getShort();
  };

  int filegetUint8() { 
    // watch out for signed here
    return file.get() & 0xff;
  };

  int filegetInt16() { 
    return file.getShort();
  };

  int filegetFword() { 
    return file.getShort();
  };

  int filegetDate() { 
    file.getInt();
    return file.getInt();
  };
  float filegetFixed() {
    return (file.getInt() *1.0f)/ (1 << 16);
  };

  int fileseek(int po) {
    int t=file.position();
    file.position(po);
    return t;
  }

  float version, fontRevision;
  int checksumAdjustment, magicNumber, 
    flags, unitsPerEm, created, modified;
  int xMin, yMin, xMax, yMax, macStyle;
  int lowestRecPPEM, fontDirectionHint;
  int indexToLocFormat, 
    glyphDataFormat;

  //class Head {
  void loadHead() { 
    fileseek(tables.get("head").offset); 
    this.version = filegetFixed(); 
    this.fontRevision = filegetFixed(); 
    this.checksumAdjustment = filegetUint32(); 
    this.magicNumber = filegetUint32();
    // assert(this.magicNumber == 0x5f0f3cf5);
    this.flags = filegetUint16(); 
    this.unitsPerEm = filegetUint16();
    this.created = filegetDate(); 
    this.modified = filegetDate(); 
    this.xMin = filegetFword(); 
    this.yMin = filegetFword();
    this.xMax = filegetFword(); 
    this.yMax = filegetFword();
    this.macStyle = filegetUint16();
    this.lowestRecPPEM = filegetUint16(); 
    this.fontDirectionHint = filegetInt16();
    this.indexToLocFormat = filegetInt16();
    this.glyphDataFormat = filegetInt16();
  }
  // }

  void loadTables() {
  //  logprintln("loading "+name);
    this.scalarType = file.getInt();
    int numTables = file.getShort();
  //  logprintln("tables: "+numTables);
    this.searchRange = file.getShort();
    this.entrySelector = file.getShort();
    this.rangeShift = file.getShort();
    tables=new HashMap<String, Table>();
    for (int i = 0; i < numTables; i++) { 
      String tag = getString(4);
      Table t= new Table(tag);
      tables.put(tag, t);
    }
    loadHead();
  };

  private int getGlyphOffset(int index) {
    // logprintln("szstt glyphoffset "+ index);
    // assert("loca" in this.tables);
    Table table = this.tables.get("loca");
    // println("table "+table.tag+" offset="+table.offset);
    int offset, next;
    if (this.indexToLocFormat == 1) {
      fileseek(table.offset + index * 4);
      offset = filegetUint32();
      next = filegetUint32();
    } else {
      fileseek(table.offset + index * 2);
      offset = filegetUint16() * 2;
      next = filegetUint16() * 2;
    }
    if (offset == next) {
      // indicates glyph has no outline( eg space)
      return 0;
    }
    // logprintln("Offset for glyph index "+index+" is "+offset);
    return offset + this.tables.get("glyf").offset;
  }

  int ascent, descent, lineGap, advanceWidthMax;
  int minLeftSideBearing, minRightSideBearing;
  int xMaxExtent, caretSlopeRise, caretSlopeRun;
  int caretOffset, metricDataFormat, numOfLongHorMetrics;

  private void readHheaTable() {
    // assert("hhea" in this.tables);
    int tableOffset = this.tables.get("hhea").offset;
    fileseek(tableOffset);
    // int version = 
    filegetFixed(); // 0x00010000
    this.ascent = filegetFword();
    this.descent = filegetFword();
    this.lineGap = filegetFword();
    this.advanceWidthMax = filegetFword();//UF
    this.minLeftSideBearing = filegetFword();
    this.minRightSideBearing = filegetFword();
    this.xMaxExtent = filegetFword();
    this.caretSlopeRise = filegetInt16();
    this.caretSlopeRun = filegetInt16();
    this.caretOffset = filegetFword();
    filegetInt16(); // reserved
    filegetInt16(); // reserved
    filegetInt16(); // reserved
    filegetInt16(); // reserved
    this.metricDataFormat = filegetInt16();
    this.numOfLongHorMetrics = filegetUint16();
  }

  private PVector getHorizontalMetrics(int glyphIndex) {
    // assert("hmtx" in this.tables);

    int old = fileseek(this.tables.get("hmtx").offset + 4);
    int offset = this.tables.get("hmtx").offset;
    int advanceWidth, leftSideBearing;
    if (glyphIndex < this.numOfLongHorMetrics) {
      offset += glyphIndex * 4;
      old = fileseek(offset);
      advanceWidth = filegetUint16();
      leftSideBearing = filegetInt16();
    } else {
      // read the last entry of the hMetrics array
      old = fileseek(offset + (this.numOfLongHorMetrics - 1) * 4);
      advanceWidth = filegetUint16();
      fileseek(offset + this.numOfLongHorMetrics * 4 +
        2 * (glyphIndex - this.numOfLongHorMetrics));
      leftSideBearing = filegetFword();
    }

    this.fileseek(old);
    return new PVector (advanceWidth, leftSideBearing);

    //    advanceWidth: advanceWidth,
    //     leftSideBearing: leftSideBearing
  }
  
public Glyph getGlyph(int index){
     real();
      if(glyphCache.containsKey(index)){
        return glyphCache.get(index);
      }
      Glyph g=new Glyph(index);
      glyphCache.put(index,g);
      return g;
    }

  public class Glyph {
    int xMin, xMax, yMax, yMin;
    int numberOfContours=0;
    int offset;
    int numPoints;
    PVector hMetrics;

   
    
    private Glyph( int index) { 
      // real(); // should we call this?
      offset = getGlyphOffset(index); 
      numberOfContours=0;
      if (offset==0) return;
      if (offset >= tables.get("glyf").offset
        + tables.get("glyf").length) 
      { 
        logprintln(" glyph offset too lreturn null");
      }
      // assert(offset >= this.tables["glyf"].offset); 
      // assert(offset < this.tables["glyf"].offset + this.tables["glyf"].length); 
      fileseek(offset); 
      // var glyph = { 
      numberOfContours=filegetInt16();
      xMin= filegetFword();
      yMin= filegetFword();
      xMax= filegetFword();
      yMax= filegetFword(); 
      //assert(glyph.numberOfContours >= -1);
      if (numberOfContours == -1) { 
      //  PApplet.println("****" +index+" compound!!!!!");
        readCompoundGlyph();
      } else { 
        readSimpleGlyph();
      }
      hMetrics=getHorizontalMetrics(index);
      if (hMetrics==null)
        hMetrics=new PVector(yMax, 0);
    };

    boolean isSimple=true;
    int contourEnds[];
    PVector points[];
    int flags[];

    final int 
      ON_CURVE = 1, 
      X_IS_BYTE = 2, 
      Y_IS_BYTE = 4, 
      REPEAT = 8, 
      X_DELTA = 16, 
      Y_DELTA = 32; 


    private void readSimpleGlyph() {

   //   logprintln("simple contours : "+numberOfContours);
      contourEnds = new int[numberOfContours];
      int cmax=0;
      for ( int i = 0; i < numberOfContours; i++ ) 
      { 
        contourEnds[i]=filegetUint16();
        if (contourEnds[i]>cmax)
          cmax= contourEnds[i];
      };
      // skip over intructions 
      fileseek(filegetUint16() + file.position());
      if (numberOfContours == 0) { 
        return;
      } 
      numPoints = cmax + 1; 
   //   logprintln("points "+numPoints);
      flags = new int[numPoints]; 
      points=new PVector[numPoints];

      for ( int pi = 0; pi < numPoints; pi++ ) { 
        int flag = filegetUint8(); 
        flags[pi]=flag; 
        points[pi]=new PVector(0, 0);
        if ( (flag & REPEAT) !=0 ) { 
          int repeatCount = filegetUint8(); 
          // assert(repeatCount > 0); 
       //   logprintln("repeat "+repeatCount+" from "+pi);
          while (repeatCount-->0) {          
            pi++;
            flags[pi]=flag;
            points[pi]=new PVector(0, 0);
          }
        }
      } // numpoints
      readCoords(true, X_IS_BYTE, X_DELTA, 
        xMin, xMax);
      readCoords(false, Y_IS_BYTE, Y_DELTA, 
        yMin, yMax);
      //  println("points "+points.length);
    }

    private void readCoords(
      boolean forX, 
      int byteFlag, 
      int deltaFlag, 
      int min, 
      int max) {

      int value = 0; 
      for ( int i = 0; i < numPoints; i++ ) {
        int flag = flags[i]; 
        //    println("flag ",flag);
        if ( (flag & byteFlag ) !=0) { 
          if ( (flag & deltaFlag )!=0) { 
            value += filegetUint8();
          } else {
            value -= filegetUint8();
          }
        } else if ( !((flag & deltaFlag) !=0)) {
          value += filegetInt16();
        } else { 
          // value is unchanged.
        }
        if (forX) 
          points[i].x = value;
        else
          points[i].y = -value;
      }
      // println("coords "+numPoints);
    }


    /********** compund */
    class Comp {
      // Mat matrix=new Mat(1,0,1,0,0);
      float a=1;
      float b=0, c=0, d=1, e=0,f=0;
      int glyphIndex;
      int destPointIndex=0;
      int srcPointIndex=0;
      Comp(int gi) {
        glyphIndex=gi;
      };
    }
    float fileget2Dot14() {
      return ( filegetInt16() *1.0f)/ (1 << 14);
    }

    private void readCompoundGlyph( ) {
      final int ARG_1_AND_2_ARE_WORDS = 1, 
        ARGS_ARE_XY_VALUES = 2, 
       // ROUND_XY_TO_GRID = 4, 
        WE_HAVE_A_SCALE = 8, 
        // RESERVED              = 16
        MORE_COMPONENTS = 32, 
        WE_HAVE_AN_X_AND_Y_SCALE = 64, 
        WE_HAVE_A_TWO_BY_TWO = 128, 
        WE_HAVE_INSTRUCTIONS = 256;
       // USE_MY_METRICS = 512, 
       // OVERLAP_COMPONENT = 1024;

      int flag = MORE_COMPONENTS;
      Comp component;
      
      contourEnds = new int[100];
      int ci=0;
      points = new PVector[1000]; // resize later
      flags = new int[1000];
      int pi = 0;

      while ((flag & MORE_COMPONENTS)!=0) {
   

        flag = filegetUint16();

        component = new Comp(
          filegetUint16()

          );
   { int arg1, arg2;
        if ((flag & ARG_1_AND_2_ARE_WORDS)!=0) {
          arg1 = filegetInt16();
          arg2 = filegetInt16();
        } else {
          arg1 = filegetUint8();
          arg2 = filegetUint8();
        }

        if ((flag & ARGS_ARE_XY_VALUES)!=0) {
          component.e = arg1;
          component.f = arg2;
        } else {
          // what are these for?
          component.destPointIndex = arg1;
          component.srcPointIndex = arg2;
        }
}
        if ((flag & WE_HAVE_A_SCALE)!=0) {
          component.a = fileget2Dot14();
          component.d = component.a;
        } else if ((flag & WE_HAVE_AN_X_AND_Y_SCALE)!=0) {
          component.a = fileget2Dot14();
          component.d = fileget2Dot14();
        } else if ((flag & WE_HAVE_A_TWO_BY_TWO)!=0) {
          component.a = fileget2Dot14();
          component.b = fileget2Dot14();
          component.c = fileget2Dot14();
          component.d = fileget2Dot14();
        }

        //log("Read component glyph index %s", component.glyphIndex);
        // this.log("Transform: [%s %s %s %s %s %s]", component.matrix.a, component.matrix.b,
        //    component.matrix.c, component.matrix.d, component.matrix.e, component.matrix.f);
        int old = file.position();
        // oops, should be loaded from cache...thos is why glyps sre not
        // cached on a charcode nase oroginslly
        Glyph simpleGlyph = getGlyph(component.glyphIndex);
        // or could tjis be compound? who caess...
        if (simpleGlyph!=null) { // always..
          int pointOffset =pi;
          for (int i = 0; i < simpleGlyph.contourEnds.length; i++) {
            contourEnds[ci]=
              simpleGlyph.contourEnds[i] +
              pointOffset;
            ci++;
          }
          for (int i = 0; i < simpleGlyph.points.length; i++) {
            float x = simpleGlyph.points[i].x;
            float y = simpleGlyph.points[i].y;
            x = component.a * x + component.b * y +
              component.e;
            y = component.c * x + component.d * y +
              component.f;

            points[pi]=new PVector(x, y);
            flags[pi]=simpleGlyph.flags[i];
            pi++;
          }
        }

        file.position(old);
      }

      contourEnds=Arrays.copyOf(contourEnds,ci);
      points=Arrays.copyOf(points,pi);
      flags=Arrays.copyOf(flags,pi);
      numberOfContours = contourEnds.length;

      if ((flag & WE_HAVE_INSTRUCTIONS)!=0) {
        file.position(filegetUint16() + file.position());
        // skip, for whatever reason
      }
      logprintln("compound contours : "+numberOfContours 
      +  " points: " +pi);
      
      
    }

    /****** end compound */


    private boolean onCurve(int i)
    {
      return (flags[i]&ON_CURVE)!=0;
      // return false;
    }

    void draw() {
      draw(0, 0);
    }

    void draw(float x, float y, float factor) { 
      draw(shacka(), x, y, factor);
    }

    void draw(float x, float y) { 
      draw(shacka(), x, y, 1.0f);
    }

    private PVector spoints(int i, float scale) {
      // who cares about petfotmance...
      return new PVector(points[i].x, points[i].y).mult(scale);
    }

    private void draw(ShapeCreator cr, float x, float y, float scale) { 
      x*=scale;
      y*=scale;

      if (numberOfContours<=0||!isSimple)return;
      int p = 0, c = 0, 
        s = 0, contourStart=0;
      PVector prev;
      cr.beginShape();
      while (p < points.length) { 
        PVector point = spoints(p, scale); 
        if (s == 0) {
          if (p!=0) // c has not increased 
            cr.beginContour();
          cr.vertex((point.x+x), (point.y+y));
          // ctx.moveTo(point.x + x, point.y + y);
          s = 1;
        } else if (s == 1) {
          if (onCurve(p)) {
            cr.vertex((point.x+x), point.y +y);
            // set first cp??
          } else {
            s = 2; // or set prev...
          }
        } else {
          prev = spoints(p - 1, scale);

          if (onCurve(p)) {
            cr.quadraticVertex(prev.x + x, prev.y + y, 
              point.x + x, point.y + y);
            s = 1;
          } else { // really???
            cr.quadraticVertex(prev.x + x, prev.y + y, 
              (prev.x + point.x) / 2 + x, 
              (prev.y + point.y) / 2 + y);
          }
        }
        if (p == contourEnds[c]) {
          if (s == 2) { // final point was off-curve. connect to start
            prev = point;
            point = spoints(contourStart, scale);
            if (onCurve(contourStart)) {
              cr.quadraticVertex(prev.x + x, prev.y + y, 
                point.x + x, point.y + y);
            } else {
              cr.quadraticVertex(prev.x + x, prev.y + y, 
                (prev.x + point.x) / 2 + x, 
                (prev.y + point.y) / 2 + y);
            }
          }
          if (c>0) cr.endContour();
          contourStart = p + 1;
          c += 1;
          s = 0;
        }
        p += 1;
      }
      cr.endShape(PConstants.CLOSE);
    } // draw
  } // glyph

  public Glyph loadGlyph(int i) {
    return getGlyph(i);
  }

  HashMap<Integer, Cmap> cmaps;

  @SuppressWarnings("unused")
    void loadCmap() {
    //  assert("cmap" in this.tables);
    cmaps=new HashMap<Integer, Cmap>();
    int tableOffset = this.tables.get("cmap").offset;
    fileseek(tableOffset);
    int version = filegetUint16(); // must be 0
    int numberSubtables = filegetUint16();

    // tables must be sorted by platform id and then platform specific
    // encoding.
    for (int i = 0; i < numberSubtables; i++) {
      // platforms are: 
      // 0 - Unicode -- use specific id 6 for full coverage. 0/4 common.
      // 1 - MAcintosh (Discouraged)
      // 2 - reserved
      // 3 - Microsoft
      int platformID = filegetUint16();
      int platformSpecificID = filegetUint16();
      int offset = filegetUint32();
      logprintln("CMap platformid="+platformID 
        +" specificid="+platformSpecificID);
      if (platformID == 0)
      {
        if (readCmap(tableOffset+offset))
          break;
      }
      if (platformID == 3 && (platformSpecificID <= 1)) {
        if ( readCmap(tableOffset + offset)) {
          break;
        }
      }
    }

    // use unicode table preferably.
    //
  }



  class Cmap0 extends HashMap<Integer, Integer> implements Cmap {
    Cmap0() {
      // format=0;
      for (int i = 0; i < 256; i++) {
        int glyphIndex = filegetUint8();
        //  this.log("   Glyph[%s] = %s", i, glyphIndex);         
        put(i, glyphIndex);
      }
    }
    public int get(int i) {
      return super.get(i);
    }
  }



  @SuppressWarnings("unused")
    boolean readCmap(int offset) {
    int oldPos = fileseek(offset);
    int format = filegetUint16();
    int length = filegetUint16();
    int language = filegetUint16();
    Cmap cmap=null;

    logprintln("    Cmap format "+format+" length "+ length);
    if (format == 0) {
      cmap = new Cmap0();
    } else if (format == 4) {
      cmap= new Cmap4();
    }
    fileseek(oldPos);
    if (cmap!=null) {
      this.cmaps.put(format, cmap);
      return true;
    }

    return false;
  }


  /**
   Cmap format 4 is a list of segments which can possibly include gaps
   */
  class Cmap4  implements Cmap {
    // format = 4;
    class Segment {
      int endCode=0;
      int startCode=0;
      int idDelta=0;
      int idRangeOffset=0;
    }

    Segment segments[];
    //: Segment[];


    @SuppressWarnings("unused")
      Cmap4() {
      int i;

      // 2x segcount
      int segCount = filegetUint16() / 2;
      segments = new Segment[segCount];
      // 2 * (2**floor(log2(segCount)))
      int searchRange = filegetUint16();
      // log2(searchRange)
      int entrySelector = filegetUint16();
      // (2*segCount) - searchRange
      int rangeShift = filegetUint16();
      // Ending character code for each segment, last is 0xffff
      for (i = 0; i < segCount; i++) {
        segments[i]=new Segment();
        segments[i].endCode=

          filegetUint16();
      }

      // reservePAd
      filegetUint16();

      // starting character code for each segment
      for (i = 0; i < segCount; i++) {
        segments[i].startCode = filegetUint16();
      }

      // Delta for all character codes in segment
      for (i = 0; i < segCount; i++) {
        segments[i].idDelta = filegetUint16();
      }

      // offset in bytes to glyph indexArray, or 0
      for (i = 0; i < segCount; i++) {
        int ro = filegetUint16();
        if (ro>0) {
          segments[i].idRangeOffset = file.position() - 2 + ro;
        } else {
          segments[i].idRangeOffset = 0;
        }
      }
    } // create



    public int get(int charCode) {
      for (int j = 0; j < segments.length; j++) {
        Segment segment = this.segments[j];
        if (segment.startCode <= charCode && segment.endCode >=
          charCode) {
          int index, glyphIndexAddress;
          if (segment.idRangeOffset!=0) {
            glyphIndexAddress = segment.idRangeOffset + 2 *
              (charCode - segment.startCode);
            fileseek(glyphIndexAddress);
            index = filegetUint16();
          } else {
            index = (segment.idDelta + charCode) & 0xffff;
          } 
          return index;
        }
      }     

      return 0;
    }
  } // Cmap4

  int cmapped(int i) {
    int format=4;
    if (cmaps.containsKey(format)) {
      return cmaps.get(format).get(i);
    }
    format=0;
    if (i<255&&cmaps.containsKey(format)) {
      return cmaps.get(format).get(i);
    }
    // now what???

    return 0;
  }

  HashMap <Integer, Glyph>glcache=new HashMap<Integer, Glyph>();

  public Glyph getMappedGlyph(int ch) {
    real();
    if (glcache.containsKey(ch)) {
      return glcache.get(ch);
    }
    Glyph gl=getGlyph(cmapped(ch));
    glcache.put(ch, gl);
    return gl;
  }

  public float scaleF(float size) {
    return 
      size / this.unitsPerEm;
  }

  private float textsize= 64;
  public float textSize(float t) {
    float o=textsize;
    textsize=t;
    return o;
  }

  private void drawRaw(char ch, float x, float y) {
    getMappedGlyph(ch).draw(x, y, scaleF(textsize));
  }

  public void draw(char ch, int size) {
    // me.pushMatrix();
    textsize= size;
    drawRaw(ch, 0, 0);
    //   me.popMatrix();
  }

  public void text(String t) {
  
    float x=0;
    float y=0;

    shacka().createShape();
    if (t==null||t.equals("")) return;
    for (char ch : t.toCharArray()) {
      switch (ch) {
        case '\n':
          x=0;
        y+=lineHeight();
        break;
        default:
        Glyph g=getMappedGlyph(ch);
        g.draw(x, y, scaleF(textsize)); 
        //drawRaw(ch, x, y);
        PVector m= g.hMetrics;      
        if (m==null){
          x+=getMappedGlyph('n').hMetrics.x;
          
          logprintln("oops, no metric on "+ch);
        }
        else
          x+=m.x;
      }
    }
  }

  public  ByteBuffer mapFile(String name) {
    RandomAccessFile memoryFile;
    try {
      PApplet.println("map: "+name);
      memoryFile = new RandomAccessFile(name, "rw");
      long fsize=memoryFile.length();
      return
        memoryFile
        .getChannel()
        .map(FileChannel.MapMode.
        READ_ONLY, 
        //  READ_WRITE, 
        0, fsize);
    } 
    catch (Exception e) {
      PApplet.println("mem: no file "+name);
      //e.printStackTrace();
      //throw e;
    }
    return null;
  }
}
