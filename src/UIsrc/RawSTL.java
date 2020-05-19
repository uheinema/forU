
package STL;

import java.io.*;

import processing.core.*;

 // import processing.DXFraw.*;
 // This could have been a subclass of DXFraw, but as always
 // the useful attach points eg. writeHeader()
 // are protected...and it is not part of APDE.
 
public class RawSTL extends PGraphics {

  File file;
  PrintWriter writer;
  float scale=1.0f; // set to prescale your model
  
  // inherited shape,vertices,vertexCount;
  
  public RawSTL() { }

  public void setPath(String name){
    // why not open it now?
    writer=openWriter(name);
   // writer=new PrintWriter(name);
  }
  
 private PrintWriter openWriter(String path) {
    //PApplet.println("setpath "+path);
    //this.path = path;
    File file=null;
    if (path != null) {
      file = new File(path);
      if (!file.isAbsolute()) file = null;
    }
    if (file == null) {
      throw new RuntimeException("stl: export could not open "+path);
    }
      // have to create file object here, because the name isn't yet
    // available in allocate()
   
    try {
        return  new PrintWriter(new FileWriter(file));
    } catch (IOException e) {
        throw new RuntimeException(e);  // java 1.4+
    }
    
  }
 
  
  // ..............................................................


  public void dispose() {
    writeFooter();
    writer.flush();
    writer.close();
    writer = null;
  }


  public boolean displayable() {
    return false;  // just in case someone wants to use this on its own
  }


  public boolean is2D() {
    return false;
  }


  public boolean is3D() {
    return true;
  }


  // ..............................................................


  public void beginDraw() {
    writeHeader();  
  }


  public void endDraw() {
    writer.flush();
  }


  // ..............................................................

 
  public void println(String what) {
    writer.println(what);
  }
 

  // ..............................................................


  public void beginShape(int kind) {
    shape = kind; // from pgraphics

    if ((shape != LINES) &&
        (shape != TRIANGLES) &&
        (shape != POLYGON)) {
      String err =
        "RawSTL can only be used with beginRaw(), " +
        "because it only supports triangles";
      throw new RuntimeException(err);
    }

    vertexCount = 0;
  }

   
  public void writeHeader() {
    println("solid thing");
  }
  
  
  public void writeFooter() {
    println("endsolid thing"); 
  }
  
  /// we swap coords from processing to stl space
  //  and scale, if wanted (from world? coords)
  public void writevertex(int i){
    println("  vertex "+
       vertices[i][X]*scale+ " " +
       (-vertices[i][Z]*scale)+" "+
       (-vertices[i][Y]*scale)
     );
  }

  public void writeFacet() {
    println(" facet normal 1 0 0"); // who cares, but needed by some importers (AstroPrint)
    println("  outer loop");
    for(int i=0;i<vertexCount;i++)
     writevertex(i);
    println("  endloop");
    println(" endfacet");
    vertexCount = 0;
  }


  public void vertex(float x, float y, float z) {
      float vertex[] = vertices[vertexCount];
  
      vertex[X] = x;  // note: not mx, my, mz like PGraphics3
      vertex[Y] = y;
      vertex[Z] = z;
  /** ELLIPSE, LINE, QUAD; TRIANGLE_FAN, QUAD_STRIP; etc. */
  // protected int kind;  ...again...why protercted???

      vertexCount++;
  
      if (shape == LINES|| shape==POINTS||
          shape==LINE_STRIP) {
       // PApplet.println("stl: No lines, please!");    
        vertexCount = 0;
       }
      else if (shape == TRIANGLES){
         if(vertexCount == 3)
          writeFacet();
      }
      else{
       //PApplet.println(err):
       String err="stl: oops, what is shape "+shape+" vertexCount "+vertexCount;
       throw new RuntimeException(err);
      }
    }
  
  
    public void endShape(int mode) {
      if (vertexCount != 0) {
         // ((shape != LINE_STRIP) && (vertexCount != 1))) {
        //PApplet.println(
        String err="stl: "+vertexCount+" extra vertices found.";
        throw new RuntimeException(err);
      }
 
    }
  
 
}
