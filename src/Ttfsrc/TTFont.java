/***************************************************************************************
 * forU.Ttf
 * Copyright (c) 2019-2020 by the author
 * @author Ullrich Heinemann , https://github.com/uheinema
 *
 * All rights reserved. 
 * A simple, platform-agnostic library for handling TrueType fonts.
 * Released under the terms of the GPLv3, refer to: http://www.gnu.org/licenses/gpl.html
 ***************************************************************************************/
/*
**
 * 
 *  Based on
 *  
 // http://stevehanov.ca/blog/?id=143
 // https://gist.github.com/smhanov/f009a02c00eb27d99479a1e37c1b3354
 // TrueType.ts
 // By Steve Hanov
 // steve.hanov@gmail.com
 // Released to the public domain on April 18, 2020
 //
 */
package forU.Ttf;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.ByteOrder;
import java.io.*;//FileOutputStream;

import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

// for debugging
import java.io.PrintWriter;


//port processing.core.PApplet;
//mport processing.core.PGraphics;
//mport processing.core.PVector;
//mport processing.core.PConstants;


interface Cmap {
  int format();
  int getGlyphIndex(int i);
  int getSegments();
  int getSegmentStart(int i);
  int getSegmentEnd(int i);
}

public class TTFont implements Cmap {

  // hack to fix line spacing
  public float lineFactor= 1.0f;

  public float lineHeight() {
    /// ????
    return //1.0f/scaleF
      (ascent
      - descent // is negative (and too large?!
      +lineGap ) * lineFactor // as per glyphsapp.com


      // yMax-yMin+lineGap 
      ;
    //1.5f* (ascent+descent+lineGap);
  }


  static public PrintWriter log;
  static public boolean logging=false;

  public void logprintln(String s) {

    if (!logging) return;
    if (log==null) return;
    log.println(s);
    log.flush();
  }
  /*

   void logprintln(String t) {
   PApplet.println(t);
   }
   */

  // always access through shaka()
  private ShapeCreator shack;
  private static ShapeCreator defshack;

  public ShapeCreator writeTo(ShapeCreator s) {
    ShapeCreator t=shack;
    shack=s;
    if (defshack==null) defshack=shack;
    return t;
  }

  public static void defaultDrawer(ShapeCreator s) {
    defshack=s;
  }

  public ShapeCreator shacka() {
    if (shack==null) shack=defshack;
    //new DefaultShapeCreator();
    return shack;
  }

  //  @Deprecated
  //  public static void writeTo(PGraphics g) {
  //    //me=g; 
  //    defshack=new ShapeDrawer(g);
  //    //shack=null;
  //    return;
  //  }


  String name;
  String nick;
  ByteBuffer file;
  int scalarType;
  short numTables;
  int searchRange, entrySelector, 
    rangeShift;
  int length;
  HashMap<String, Table> tables;
  HashMap<Integer, Glyph> glyphCache;

  public int size() { 
    real() ;
    return length;
  }


  public TTFont(String name) { 

    this.name=name;
    // delayed set to real use
    file=null;
    //set(mapFile(name));
  }

  public void real() {
    if (file==null) set(mapFile(name));
  }

  public
    TTFont(ByteBuffer buffer) {
    set(buffer);
  }

  public TTFont(InputStream imp)
    throws IOException
  {
    set(mapStream(imp));
  }

  void set(ByteBuffer file) {
    this.file=file;
    file.order(ByteOrder.BIG_ENDIAN) ;
    loadTables();
    this.length =readGlyphCount();
    loadCmap();
    readHheaTable();
    glyphCache=new HashMap<Integer, Glyph>();
    logprintln("loadhead bot "+version+" length: "+this.length);
    logprintln("unitsPerEm: "+unitsPerEm);
  }

  private int readGlyphCount() {
    real();
    int ofs=this.tables.get("maxp").offset + 4;
    //   logprintln("maxp offset "+ofs);
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
      //  logprintln("table "+tag+" "+length);
    }
  }
  int filegetUint32() { 
    long l= file.getInt() ;
    return( int)( l & 0xffffffff);
  };

  int filegetUint16() { 
    return file.getShort() &0xffff;
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

  private float getHorizontalMetrics(int glyphIndex) {
    // assert("hmtx" in this.tables);

    int old = fileseek(this.tables.get("hmtx").offset + 4);
    int offset = this.tables.get("hmtx").offset;
    int advanceWidth;
    //leftSideBearing;
    if (glyphIndex < this.numOfLongHorMetrics) {
      offset += glyphIndex * 4;
      old = fileseek(offset);
      advanceWidth = filegetUint16();
      //  leftSideBearing = filegetInt16();
    } else {
      // read the last entry of the hMetrics array
      old = fileseek(offset + (this.numOfLongHorMetrics - 1) * 4);
      advanceWidth = filegetUint16();
      fileseek(offset + this.numOfLongHorMetrics * 4 +
        2 * (glyphIndex - this.numOfLongHorMetrics));
      //  leftSideBearing = filegetFword();
    }

    this.fileseek(old);
    return advanceWidth;
    //new PVector (advanceWidth, leftSideBearing);

    //    advanceWidth: advanceWidth,
    //     leftSideBearing: leftSideBearing
  }

  public Glyph getGlyph(int index) {
    real();
    if (glyphCache.containsKey(index)) {
      return glyphCache.get(index);
    }
    Glyph g=new Glyph(index);
    glyphCache.put(index, g);
    return g;
  }

  public class Glyph {
    int xMin, xMax, yMax, yMin;
    int numberOfContours=0;
    int offset;
    int numPoints;
    //PVector 
    float hMetrics;

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
      if (hMetrics==0.0)
        hMetrics=yMax;
    };

    boolean isSimple=true;
    int contourEnds[];
    // PVector points[];
    float[] px;
    float[] py;
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
      px=new float[numPoints];
      py=new float[numPoints];
      for ( int pi = 0; pi < numPoints; pi++ ) { 
        int flag = filegetUint8(); 
        flags[pi]=flag; 
        px[pi]=0;
        py[pi]=0f;//new PVector(0, 0);
        if ( (flag & REPEAT) !=0 ) { 
          int repeatCount = filegetUint8(); 
          // assert(repeatCount > 0); 
          //   logprintln("repeat "+repeatCount+" from "+pi);
          while (repeatCount-->0) {          
            pi++;
            flags[pi]=flag;
            px[pi]=0;
            py[pi]=0;//new PVector(0, 0);
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
          px[i]= value;
        else
          py[i]= -value;
      }
      // println("coords "+numPoints);
    }


    /********** compund */
    class Comp {
      // Mat matrix=new Mat(1,0,1,0,0);
      float a=1;
      float b=0, c=0, d=1, e=0, f=0;
      int glyphIndex;
      int destPointIndex=0;
      int srcPointIndex=0;
      Comp(int gi) {
        glyphIndex=gi;
      };
    }

    //******--******************

    float fileget2Dot14() {
      float f=( filegetInt16() *1.0f)/ (1 << 14);
      logprintln("2dot: "+f);
      return f;
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
      px = new float[1000]; 
      py = new float[1000];// resize later
      flags = new int[1000];
      int pi = 0;
      logprintln("start compound");
      while ((flag & MORE_COMPONENTS)!=0) {


        flag = filegetUint16();

        component = new Comp(
          filegetUint16()

          );
        logprintln("sibgluph "+component.glyphIndex);
        { 
          int arg1, arg2;
          if ((flag & ARG_1_AND_2_ARE_WORDS)!=0) {
            arg1 = filegetInt16();
            arg2 = filegetInt16();
          } else {
            arg1 = filegetUint8();
            arg2 = filegetUint8();
          }
          logprintln("args :"+arg1+' '+arg2);
          if ((flag & ARGS_ARE_XY_VALUES)!=0) {
            logprintln("xyvalues");
            component.e = arg1;
            component.f = arg2;
          } else {
            logprintln("index");
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
          for (int i = 0; i < simpleGlyph.px.length; i++) {
            float x = simpleGlyph.px[i];
            float y = simpleGlyph.py[i];
            px[pi] = component.a * x + component.b * y + component.e;
            py[pi] = component.c * x + component.d * y -  component.f;

            //points[pi]=new PVector(x, y);
            flags[pi]=simpleGlyph.flags[i];
            pi++;
          }
        }

        file.position(old);
      }

      contourEnds=Arrays.copyOf(contourEnds, ci);
      px=Arrays.copyOf(px, pi);
      py=Arrays.copyOf(py, pi);
      flags=Arrays.copyOf(flags, pi);
      numberOfContours = contourEnds.length;

      if ((flag & WE_HAVE_INSTRUCTIONS)!=0) {
        file.position(filegetUint16() + file.position());
        // skip, for whatever reason
      }
      logprintln("total contours : "+numberOfContours 
        +  " points: " +pi);
    }

    /****** end compound */


    private boolean onCurve(int i)
    {
      return (flags[i]&ON_CURVE)!=0;
      // return false;
    }

    public void draw() {
      draw(0, 0);
    }

    public void draw(float x, float y, float factor) { 
      draw(shacka(), x, y, factor);
    }

    public void draw(float x, float y) { 
      draw(shacka(), x, y, 1.0f);
    }

    //    private PVector spoints(int i, float scale) {
    //      // who cares about petfotmance...
    //      return new PVector(px[i], py[i]).mult(scale);
    //    }

    public void draw(ShapeCreator cr, float x, float y, float scale) { 
      x*=scale;
      y*=scale;

      if (numberOfContours<=0||!isSimple)return;
      int p = 0, c = 0, 
        s = 0, contourStart=0;
      float prevx, prevy;
      cr.beginShape();
      while (p < px.length) { 
        float sx=px[p]*scale;
        float sy=py[p]*scale;
        //PVector point = spoints(p, scale); 
        if (s == 0) {
          if (p!=0) // c has not increased 
            cr.beginContour();
          cr.vertex((sx+x), (sy+y));
          // ctx.moveTo(point.x + x, point.y + y);
          s = 1;
        } else if (s == 1) {
          if (onCurve(p)) {
            cr.vertex(sx+x, sy +y);
            // set first cp??
          } else {
            s = 2; // or set prev...
          }
        } else {
          prevx = px[p - 1]* scale;
          prevy = py[p - 1]* scale;

          if (onCurve(p)) {
            cr.quadraticVertex(prevx + x, prevy + y, 
              sx + x, sy + y);
            s = 1;
          } else { // really???
            cr.quadraticVertex(prevx + x, prevy + y, 
              (prevx + sx) / 2 + x, 
              (prevy + sy) / 2 + y);
          }
        }
        if (p == contourEnds[c]) {
          if (s == 2) { // final point was off-curve. connect to start
            prevx = sx;
            prevy= sy;
            sx = px[contourStart]*scale;
            sy = py[contourStart]*scale;
            if (onCurve(contourStart)) {
              cr.quadraticVertex(prevx + x, prevy + y, 
                sx + x, sy + y);
            } else {
              cr.quadraticVertex(prevx + x, prevy + y, 
                (prevx + sx) / 2 + x, 
                (prevy + sy) / 2 + y);
            }
          }
          if (c>0) cr.endContour();
          contourStart = p + 1;
          c += 1;
          s = 0;
        }
        p += 1;
      }
      cr.endShape(2);///CLOSE);
    } // draw
  } // glyph

  /********* C M A P **********/

  HashMap<Integer, Cmap> cmaps;

//   @SuppressWarnings("unused")
    void loadCmap() {
    //  assert("cmap" in this.tables);
    cmaps=new HashMap<Integer, Cmap>();
    int tableOffset = this.tables.get("cmap").offset;
    fileseek(tableOffset+2);
   // filegetUint16(); // must be 0
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
          ;//break;
      }
      if (platformID == 3 ) {//&& (platformSpecificID <= 1)) {
        if ( readCmap(tableOffset + offset)) {
          ;//break;
        }
      }
    }

    // use unicode table preferably.
    //
  }



  class Cmap0 implements Cmap {
    int map[];
    int mini=0, maxi=0;
    // }extends HashMap<Integer, Integer> implements Cmap {
    @SuppressWarnings("unused")
      Cmap0() {
      // format=0;
      map=new int[256];
      int length = filegetUint16();
      int language = filegetUint16();
      for (int i = 0; i < 256; i++) {
        int gi = filegetUint8();
        map[i]= gi;
        if (gi!=0) {
          maxi=i;
          if (mini==0) mini=i;
        }
      }
    }

    public int getGlyphIndex(int i) {
      return map[i];
    }
    public int getSegments() {
      return 1;
    }
    public int getSegmentStart(int i) {
      return mini;
    }
    public int getSegmentEnd(int i) {
      return maxi;
    }
    // format was read at 16 bit
    public int format() {
      return 0;
    }
  }



  //? @SuppressWarnings("unused")
  boolean readCmap(int offset) {
    int oldPos = fileseek(offset);
    int format = filegetUint16();


    Cmap cmap=null;

    logprintln("    Cmap format "+format+" length "+ length);
    if (format == 0) {
      cmap = new Cmap0();
    } else if (format == 4) {
      cmap= new Cmap4();
    } else if (format == 12) {
      filegetUint16();
      cmap= new Cmap12();
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
    // overrideable
    int getUint() {
      return filegetUint16();
    }

    @SuppressWarnings("unused")
      void readSearchHints() {

      // 2 * (2**floor(log2(segCount)))
      int searchRange = getUint();
      // log2(searchRange)
      int entrySelector = getUint();
      // (2*segCount) - searchRange
      int rangeShift = getUint();
    }

    Cmap4() {
      read();
    }

    @SuppressWarnings("unused")
      void read() {
      int i;

      int length = getUint();
      int language = getUint();
   //    logprintln("len "+length+" lamng "+language);
      // 2x segcount
      int segCount = getUint() / 2;
      segments = new Segment[segCount];

      // Ending character code for each segment, last is 0xffff
      for (i = 0; i < segCount; i++) {
        segments[i]=new Segment();
        segments[i].endCode=getUint();
      }

      // reservePAd
      getUint();

      // starting character code for each segment
      for (i = 0; i < segCount; i++) {
        segments[i].startCode = getUint();
      }

      // Delta for all character codes in segment
      for (i = 0; i < segCount; i++) {
        segments[i].idDelta = getUint();
      }

      // offset in bytes to glyph indexArray, or 0
      for (i = 0; i < segCount; i++) {
        int ro =getUint();
        if (ro>0) {
          segments[i].idRangeOffset = file.position() - 2 + ro;
        } else {
          segments[i].idRangeOffset = 0;
        }
      }
    } // create

    public int getGlyphIndex(int charCode) {
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

    public int getSegments() {
      return segments.length;
    }
    public int getSegmentStart(int i) {
      return segments[i].startCode;
    }
    public int getSegmentEnd(int i) {
      return segments[i].endCode;
    }

    public int format() {
      return 4;
    }
  } // Cmap4


  class Cmap12 extends Cmap4 {
    // format was read at 16 bit
    @Override
      public int format() {
      return 12;
    }

    @Override 
      int getUint() {
      return filegetUint32();
    }

    @SuppressWarnings("unused")
    @Override
      void read() {
      int i;

      int length = getUint();
      int language = getUint();

      int segCount = getUint() ;
      segments = new Segment[segCount];
   //   logprintln("len "+length+" lang  "+language+ " segs "+segCount);

      // Ending character code for each segment, last is 0xffff
      for (i = 0; i < segCount; i++) {
        segments[i]=new Segment();
        segments[i].startCode=getUint();
        segments[i].endCode=getUint();
        segments[i].idDelta = getUint(); // startGlyphCode
      }
    } // create

    @Override
      public int getGlyphIndex(int charCode) {
      for (int j = 0; j < segments.length; j++) {
        Segment segment = this.segments[j];
        if (segment.startCode <= charCode && segment.endCode >=
          charCode) {

          int index;
            index = (segment.idDelta +( charCode - segment.startCode));
          return index;
        }
      }
      return 0;//or -1 or ??
    }

}

   public int format(){
     real();
      if (cmaps.containsKey(12)) return 12;
      if (cmaps.containsKey(4)) return 4;
      return 0;
     }
     
    Cmap bestmap() {
      real();
      if (cmaps.containsKey(12)) return cmaps.get(12);
      if (cmaps.containsKey(4)) return cmaps.get(4);
      return cmaps.get(0);
    }

    public int getSegments() {
      return   bestmap().getSegments();
    }


    public int getSegmentStart(int i) {
      return  bestmap().getSegmentStart(i);
    }

    public int getSegmentEnd(int i) {
      return bestmap().getSegmentEnd(i);
    }


    public int getGlyphIndex(int i) {
      real();
      int gi=

        bestmap().getGlyphIndex(i);

      if (gi<1) {
        // now what??? look in other maps?
        //   gi=cmaps.get(0).getGlyphIndex(i);
      }
      return gi;
    }



    HashMap <Integer, Glyph>glcache=new HashMap<Integer, Glyph>();

    public Glyph getMappedGlyph(int ch) {
      real();
      if (glcache.containsKey(ch)) {
        return glcache.get(ch);
      }
      Glyph gl=getGlyph(getGlyphIndex(ch));
      glcache.put(ch, gl);
      return gl;
    }

    public float scaleF(float size) {
      return 
        size / this.unitsPerEm; //??
    }

    private static float textsize= 0; // use global
    private static float globaltextsize= 64;

    // I would prefer the other way round, but for
    // PApplet compstibility...
    public float fontSize(float t) {
      float o=textsize;
      textsize=t;
      return o;
    }

    public static float textSize(float t) {
      float o=globaltextsize;
      if (t>0) globaltextsize=t;
      return o;
    }

    public float textSize() {
      if (textsize==0)
        return globaltextsize;
      return textsize;
    }

    //  private void drawRaw(char ch, float x, float y) {
    //    getMappedGlyph(ch).draw(x, y, scaleF(textsize));
    //  }
    //
    //  public void draw(char ch, int size) {
    //    
    //    textsize= size;
    //    drawRaw(ch, 0, 0);
    //    
    //  }

    public float text(String t) {

      float x=0;
      float y=0;
      float mx=0;
      //float my=0;
      shacka().createShape();
      if (t==null||t.equals("")) 
        return 0f;
      int cps=t.length();//t.codePointCount(0,t.length());
      for (int i=0;i<cps;i++)
      {
        int ch=t.codePointAt(i);
        if(ch>0x10000) i++;
        switch (ch) {
        case '\n':
          x=0;
          y+=lineHeight();
          //   my=y;
          break;
        default:
          Glyph g=getMappedGlyph(ch);
          g.draw(x, y, scaleF(textSize())); 
          //drawRaw(ch, x, y);
          // todo: kerning etc.
          float m= g.hMetrics;      
          if (m==0) { // nbzls?
            x+=getMappedGlyph('i').hMetrics;
            // or dash or n ?? 
            //  logprintln("oops, no metric on "+ch);
          } else
            x+=m;
          if (x>mx) mx=x;
        }
      }
      float r=y*scaleF(textSize());
      // PVector r=new PVector(mx, my);
      // r.mult(scaleF(textsize));
      return r;
    }




    @Deprecated
      public  ByteBuffer mapStream(InputStream str) 
      throws IOException
    {
      FileChannel mapp=(((FileInputStream)str).getChannel());
      return mapChannel(mapp, 0);
    }

    public  ByteBuffer mapChannel(FileChannel mapp, long fsize)
      throws IOException
    {
      return mapp.map(FileChannel.MapMode.
        READ_ONLY, 
        0, fsize);
    }


    public  ByteBuffer mapFile(String name) {
      RandomAccessFile memoryFile;
      try {
        logprintln("map: "+name);

        memoryFile = new RandomAccessFile (name, "r");
        long fsize=memoryFile.length();
        FileChannel mapp=
          memoryFile
          .getChannel();
        return mapChannel(mapp, fsize);
      } 
      catch (IOException e) {
        logprintln("mem: no file "+name);
        //e.printStackTrace();
        //throw e;
      }
      return null;
    }
    
    
// see http://www.unicode.org/faq//utf_bom.html#utf16-3
  public static String utf(int C){
  
  if(C<0x10000) return ""+C;
  final char HI_SURROGATE_START = 0xD800;
  
  char X = (char) (C & 0xffff); 
  int U = (C >> 16) & ((1 << 5) - 1);
  char W = (char)( U - 1); 
  final char HiSurrogate =
    (char)( HI_SURROGATE_START | (W << 6) | X >> 10);
  final char LO_SURROGATE_START = 0xDC00; 
  char LoSurrogate =(char)( (LO_SURROGATE_START | X &
      ((1 << 10) - 1)));
  //println("sur "+hex(C)+": "+hex(+HiSurrogate)+" "+hex(LoSurrogate));
  return ""+HiSurrogate+LoSurrogate;
}

    
  }
