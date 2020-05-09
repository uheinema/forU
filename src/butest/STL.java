
package STL; // STL
  //https://github.com/stockto2/
//desktophero_django/issues/new
import java.io.*;

import java.io.RandomAccessFile;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.ByteOrder;
// etc pp

import processing.core.*;

// import java.io.DataInputStream;
 //import java.io.BufferedInputStream;
 //import java.io.FileInputStream;

	 public class STL
   implements PConstants 
   {
  
  // can be used static and non- static
  STL(PApplet _app){app=_app;};
  private PApplet app;
  static public boolean verbose=false;
  static void aprintln(String s){if(verbose)PApplet.println(s);}
  
  public PShape loadShape(String[] in)
  {
    return loadShape(app,in);
  }
  
  static PShape loadShape
   //throws Exception
   (PApplet _app,String[] in){
   int i=0;
   int vertexCount=0;
   float x,y,z;
   int cnt=0;
 
   String[] sp = in[i].split(" ");
   if(!sp[0].equals("solid"))
   {
     aprintln("stl: not starting with 'solid'");
     // throw?
     return null;
   }
   aprintln("stl: "+in.length+" lines, text.");
   if(in.length>200000){
     aprintln("really??");
     return null;
   }
   PShape s=_app.createShape(); // that is all we need app for
   s.beginShape(TRIANGLES);

  // Warrrr_2f0cdfbb
   for(i=0;i<in.length;i++){
     //if(i<10||i>in.length-10)
     //   PApplet.println("stl "+i+": "+in[i]);
     sp=in[i].split(" ");
     for(int t=0;t<sp.length;t++){
       String spt=sp[t];
       if(spt.equals("")) continue;
       while(spt.charAt(0)=='\t') spt=spt.substring(1);
       if(spt.equals("")) continue;
       if(spt.equals("solid")){
         aprintln("stl: loading "+sp[t+1]);
         break;
       }
       if(sp[t].equals("endsolid")){
         aprintln("stl: loaded "+vertexCount+" vertices for "+sp[t+1]);
         s.endShape();
         return s;
       }
       else if(spt.equals("vertex")){
   
         x=Float.parseFloat(sp[t+1]);
         y=Float.parseFloat(sp[t+2]);
         z=Float.parseFloat(sp[t+3]);
         s.vertex(x,-z,-y);
         vertexCount++;
         break;    // this line    
       }
       else if(spt.equals("endloop")||spt.equals("outer")||spt.equals("endfacet")||spt.equals("facet")){ 
         break; // known junk, ignore
       }
       else{// unknown token, just ignore?
        
        if(cnt++<100)  PApplet.print("|"+spt);
         break;
      }
     } // for splits
   } // for lines
   s.endShape();
   return s;
 }

 public static RandomAccessFile memFile(String name)
   throws Exception {
    //long fsize=0;
    //RandomAccessFile memoryFile;
   
     //memoryFile = 
      return new RandomAccessFile(name, "rw"); 
   }

  public static MappedByteBuffer map(String name,long fsize){
    
    RandomAccessFile memoryFile;
    MappedByteBuffer mappedByteBuffer=null;
  
    try{
     memoryFile = memFile(name);
     if(fsize==0)fsize=memoryFile.length();
     mappedByteBuffer =
       memoryFile
         .getChannel()
         .map(FileChannel.MapMode.
            ///READ_ONLY,
            READ_WRITE,
             0, fsize); 
   } catch (Exception e){
    PApplet.println("mem: no file "+name);
    //e.printStackTrace();
    //throw e;
   }
   return mappedByteBuffer;
}

 public PShape loadShape(String name){
   return loadShapeImpl(app,name,false);
 }
 
 static public PShape loadShape(PApplet _app,String name){
   return loadShapeImpl(_app,name,false);
 }
 
 public static void bergman(String name){
   loadShapeImpl(null,name,true);
 }
 
static private PShape loadShapeImpl(PApplet app,String name,boolean copy)
  //throws Exception
  {
   PShape s=null;
 //  RawSTL scopy= null;
   
   float x,y,z;
   MappedByteBuffer mem=null;
   int ofs=84;
    
     mem=map(name,0);
     mem.order(ByteOrder.LITTLE_ENDIAN);
     
     try { 
       // the header scheme of binary stl is
       // idiotic to start with.and there are 
       // common 'illegal' files beginning with a header like
       // solid someFile blabla ...
       // padded with blanks and then become binary...
       // 
       byte[] header=new byte[84];
       mem.get(header,0,84);
       
       if(isText(header)){
           mem=null;
           s=null;
           // naive...should use the reader...
           String[] in = app.loadStrings(name);
           if(in.length>10000) aprintln("stl: trying "+in.length+" "+name);
           return loadShape(app,in);
       }
       
       int size=mem.getInt(80);
       int skip=1;
       if(size<4||size>100000) // cmon
       {
         aprintln("stl: "+size+ " facets, really?"+name);
         return null;
        }
       if(app!=null){
       //  PApplet.println("create shape");
         s=app.g.createShape();
         s.beginShape(TRIANGLES);
       }
  /*
       if(copy)
       {
         
         scopy=new RawSTL();
         scopy.setPath(name+".raw.stl");   
         scopy.beginShape(TRIANGLES); 
         scopy.writeHeader();    
       }
   */    
       
       aprintln("stl: "+size+" facets, binary.");
       for(;size/skip>300000;skip+=skip);
       if(skip>1){
         aprintln("stl: Too large, only showing every "+skip+". facet.");
        
       }
       for (int i = 0; i < size; i++) { 
        
         //normal 
         {
           x=mem.getFloat(ofs); ofs+=4;
           y=mem.getFloat(ofs); ofs+=4;
           z=mem.getFloat(ofs); ofs+=4;          
         // s.normal(x,y,z); 
         }
         boolean show=(i%skip)==0;
         for(int j=0;j<3;j++){ 
           x=mem.getFloat(ofs); ofs+=4;
           y=mem.getFloat(ofs); ofs+=4;
           z=mem.getFloat(ofs); ofs+=4;          
           if(show) {
             s.vertex(x,-z,-y);
           }
  /*
           if(scopy!=null)
             scopy.vertex(x,-y,-z);
        */
           //if(i<3) aprintln("stl: vertex "+x+" "+y+" "+z);
         } 
         ofs+=2; // stl madness
       } // for size
       
   }
   catch(Exception e){
     aprintln("stl "+name+": huch, "+e.getMessage());
     return null;
     // throw e;
   } 
   
   if(s!=null) s.endShape();  
  // if(scopy!=null) scopy.dispose(); // closes fiele  is this needed?
   // set width height etc?
   aprintln("stl: loaded binary "+name);
   mem=null;
   return s;
 }
 
 @SuppressWarnings("deprecation")
 static public void saveBrutal(PShape s,String name){
   int n=s.getVertexCount();
   int fs=(12*4+2)*(n/3)+80+4;
   MappedByteBuffer mem=map(name,fs);///n*(4*3)+4);
   mem.order(ByteOrder.LITTLE_ENDIAN);
   byte [] buf=new byte[80];
   byte [] dummy=new byte[]{0,0};
   String sn=("stl "+name);
   sn.getBytes(0,PApplet.min(80,sn.length()),buf,0);
   mem.put(buf);
   mem.putInt(n/3);
   for(int f=0;f<n/3;f++){
     int i=f*3;
     mem.putFloat(s.getNormalX(i));
     mem.putFloat(-s.getNormalZ(i));
     mem.putFloat(-s.getNormalY(i));

     for(int v=0;v<3;v++){
       mem.putFloat(s.getVertexX(i+v));
       mem.putFloat(-s.getVertexZ(i+v));
       mem.putFloat(-s.getVertexY(i+v));
     }
     mem.put(dummy);
   }
   // close this file??
 }
 
 static public PShape loadBrutal(PApplet app,String name)
  //throws Exception
  {
   PShape s=null;
   float x,y,z;
   MappedByteBuffer mem=null;
   int i=-1;
    
     mem=map(name,0);
     //mem.order(ByteOrder.LITTLE_ENDIAN);
     
     try { 
   
        // PApplet.println("loading brutal "+name);
         s=app.g.createShape();
         s.beginShape(TRIANGLES);
       
     
       int nvert=mem.getInt();
      
      // PApplet.println("load brutal: "+nvert+" vertices");
      
       for (i = 0; i < nvert; i++) { 
           x=mem.getFloat();
           y=mem.getFloat();
           z=mem.getFloat();    
           s.vertex(x,y,z);   
       } // for size
       
   }
   catch(Exception e){
     PApplet.println("brutal: huch after "+i);
     // throw e;
   }  
   s.endShape();
   //PApplet.println("brutal: loaded "+name);
  // mem=null;
   return s;
 }
 
 
 private static boolean isText(byte[] bytes) 
 {	
   	for (byte b : bytes) {			
     //println("istext: "+b);
     if (b == 0x0a || b == 0x0d || b == 0x09) 
     {				// white spaces				
          continue;		
     	}			
     if (b < 0x20 || (0xff & b) >= 0x80) {				
       // control codes		
       return false;			
      }		
   }	
  	return true;	
 }	
 
 static public PrintWriter openWriter(String path) {
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
 
 }