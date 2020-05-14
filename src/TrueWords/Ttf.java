/**
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
 *
 *  expanded for Cmap format 12 (UTF32)
 *  whats a font without linear-b?
 *
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


import processing.core.PApplet;
import processing.core.PGraphics;
//mport processing.core.PVector;
//mport processing.core.PConstants;




public class Ttf  extends TTFont {

   static public PApplet me;
   static public PGraphics g; // set this or a shack...

  static final HashMap<String, Ttf> fontCache=
    new HashMap<String, Ttf>();
  
    
  static String beatNick;
  static Ttf beat;
  
  public Ttf(PApplet _me){ 
    super("whocares");
    setup(_me);
  }
  
  static public void setup(PApplet _me){
    me=_me;
    g=me.g;
  }
  
  
  static public Ttf createFont(String nick, String filename) {
    if (fontCache.containsKey(nick)) {
      return fontCache.get(nick);
    }
    Ttf nf=new Ttf(filename); 
    nf.nick=nick;
    fontCache.put(nick, nf);
    beat=nf;
    beatNick=nick;
    return nf;
  }
  
static public Ttf createFont(String nick, byte[] b) 
{
    if (fontCache.containsKey(nick)) {
      return fontCache.get(nick);
    }
    Ttf nf;
    
    nf=new Ttf(ByteBuffer.wrap(b)); 
    nf.nick=nick;
    fontCache.put(nick, nf);
    beat=nf;
    beatNick=nick;
    return nf;
  }


  static public Ttf get(String nick) {
    if (fontCache.containsKey(nick)) {
      return fontCache.get(nick);
    }
    return null;// loadFont(nick, nick);
  }
 static public void remove(String nick) {
    if (fontCache.containsKey(nick)) {
       fontCache.remove(nick);
    }
  }
  
  static public Ttf get() {
    
    return beat;//get(beatNick);
  }

  public static void textFont(String nick) { 
    beatNick=nick;
    beat=get(nick);
  }
  
  public static void textFont(Ttf t){
    beat=t;
    beatNick=t.nick;
  }
  
 

  //@Override 
  public Ttf(String name) { 
    //
    // handle loading from assets
    // see mapFile
    super(name);
    
    //set(mapFile(name));
  }

   
  //public
   Ttf(ByteBuffer file) {
      super(file);
  }

  Ttf(InputStream imp)
  throws IOException
  {
    super(imp);
   // set(mapStream(imp));
  }

   
  

 // I would prefer the other way round, but for
  // PApplet compstibility...
  /* mayb @override ?
  public float fontSize(float t) {
    float o=textsize;
    textsize=t;
    return o;
  }
  
  public static float textSize(float t) {
    float o=globaltextsize;
    if(t>0) globaltextsize=t;
    return o;
  }*/
    
    
    public int bmap(){return bestmap().format();}
  
    
  @Override 
  public  ByteBuffer mapFile(String name) {
    
    ByteBuffer nb=super.mapFile(name);
    if(nb==null) // maybe our applet knows
      return ByteBuffer.wrap(me.loadBytes(name));
    return nb;
    /**** /// super.. *** /
    RandomAccessFile memoryFile;
    try {
      PApplet.println("map: "+name);
      
      memoryFile = new RandomAccessFile(name, "rw");
      long fsize=memoryFile.length();
      FileChannel mapp=
        memoryFile
        .getChannel();
      return mapChannel(mapp,fsize);
      
    } 
    catch (IOException e) {
      PApplet.println("mem: no file "+name);
      //e.printStackTrace();
      //throw e;
    }
    return null;
    /*** ***/
  }
  
  //@Override
  
  
}
