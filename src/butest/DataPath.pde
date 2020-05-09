/** * Copy the asset at the specified path to this app's data directory. 
 If th
 * asset is a directory, its contents are also copied.
 * * @param path
 * Path to asset, relative to app's assets directory. 
 */

// package 
import android.os.Environment;
import android.content.res.*; //getAssrt
import android.app.*; 
import java.io.*;//FileOutputStream;
//import java.util.stream.*;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager; 


String sketchName() {
  return this.getClass().getSimpleName();
}

PrintWriter log;
boolean logging=false;


void logprintln(String s) {
  // PApplet.println(s);
  if (!logging)return;
  if (log==null) 
    log=createWriter(sex(sketchName()+".log"));///,true); //autoflush
  log.println(s);
  log.flush();
}


String solo(String name) {
  return sketchPath(name);
  
}
String solo() {
  return solo("")+"/";
}

// static
//
File mySD;

String sex() {
  return sex("")+"/";
};

String sex(String name) {
  if (mySD==null) 
  {
    getRWPermission(); //?? or crash later
    File externalDir = Environment.getExternalStorageDirectory();
    if ( externalDir == null ) {
      return null;
    }
    mySD = new File(externalDir, sketchName());
    mySD.mkdirs(); // no use if not existent
    println("External is : " +mySD);
  }
  File finalDir =  new File(mySD,name);
  String fd=finalDir.getAbsolutePath() ;
  // so far..but if name terminayed in /, so should we?
  //return agha(name,fd);;
  if(name.equals("") || name.charAt(name.length()-1)=='/')
   return fd+"/";
  else
   return fd;

}

boolean getRWPermission() {
  if (getP(Manifest.permission.WRITE_EXTERNAL_STORAGE))
    return getP(Manifest.permission.READ_EXTERNAL_STORAGE);
  return false;
} 


boolean hasP(String p) {
  //println("has "+p);
  return
    getContext().checkSelfPermission(
    p)
    == 
    PackageManager.PERMISSION_GRANTED;
}

boolean getP(String p) {
  if (hasP(p)) return true;
  try { 
    // Request user to grant write external storage permission. 
    getActivity().requestPermissions(
      new String[]{p}, 1);// REQUEST_CODE_WRITE_EXTERNAL_STORAGE_PERMISSION);
    //android will popup a confirm dialog which let you allow or deny the required permissions.
  }
  catch(Exception e) {
    toast("Keine Arme, keine Kekse!");
  };
  return hasP(p);
}


final int OVERWRITE = 4, 
  STOPFIRST=2, 
  CHECK=0;

boolean copyAssets(String path) {
  return copyAssets( path, STOPFIRST);
};

boolean copyAssets(String path, int b) {
  return copyAssets(sex(), path, b);
};

boolean copyAssets(String target, String path) 
{ 
  return copyAssets(target, path, STOPFIRST);
}

// target could be eg. SD()+"myfiles/"..
boolean copyAssets(String target, String path, int stop) 
{ 
  // Activity a=getActivity();
  AssetManager manager = getContext().getAssets();

  try { 
    logprintln("copyassets: trying "+path);
    String[] contents = manager.list(path); 

    if (contents == null || contents.length == 0) {

      logprintln(" list "+(contents==null?"null":"empty"));
      if (!copyFileAsset(target, path, stop)) {
        if (stop==STOPFIRST) return true;
      }
      return false;
    }
    //new File(target).mkdirs();
    File dir = new File(target+  path);
    dir.mkdirs();
    for (String entry : contents) { 
      String s=entry;
      if (!path.equals("")) {
        s=path + "/" + entry;
      }
      if (copyAssets(target, s, stop)&&stop==STOPFIRST)
        return true;
    }
  }  
  catch (IOException e) {
    logprintln("ioerror on list()");
    //throw e;
    return true;
  }
  return false;
}




/** *
 * Copy the asset file specified by path to app's data directory.
 
 // NOT Assumes * parent directories have already been created. 
 * * @param path * Path to asset, 
 * relative to app's assets directory. */

private boolean copyFileAsset(String target, String assetPath, int stop) 
  //throws DoneException 
{ 
  logprintln("target: "+target);
  logprintln("assetP: "+assetPath);

  // Activity a=getActivity();
  File file = 
    new File(target+assetPath); 
  if (file.exists()) {
    logprintln("cfa: already there: "+file);
    if (stop!=OVERWRITE) return false;
  }
  try { 
    logprintln("cfa: copying "+assetPath);
    InputStream in = createInput(assetPath);
    if (in==null) return false;
    logprintln(" input open...");
    logprintln(" mkdir "+target);
    new File(target).mkdirs();
    OutputStream out= new FileOutputStream(file); 
    logprintln(" output open..."+file.getName()+" at "+file.getPath());
    byte[] buffer = new byte[8*1024]; 
    int r=0;
    int read = in.read(buffer);
    while (read != -1) {
      out.write(buffer, 0, read); 
      r+=read;
      read = in.read(buffer);
    } 
    out.close(); 
    in.close();
    logprintln("copied "+ r+" bytes");
    return true;
  } 
  catch (IOException e)
  { 
    logprintln("Can't copy "+assetPath+" to external "+target);
    return false;
  }
}

boolean hadLocal = false;


String [] loadLocalStrings(String s) {
  // try local dir first.
  String [] ss=null;
  try {
    ss=loadStrings(sex(s));
    // hack...had copy. 
    hadLocal=true;
    return ss;
  } 
  catch(Exception e) {
    // .. or something else.
  }
  try {
    ss=loadStrings(s);
    // that seemed to work..save for later user mod
    saveStrings(sex(s), ss);
  }
  catch (Exception e) {
    // now really, what else?
    logprintln("throw up "+s);
  }
  return ss;
}

String [] listAssets(String path) {
  StringList sl=new StringList();
  listAssets(path, sl);
  println("la: total "+sl.size());
  return sl.array();
}

void listAssets(String path, StringList sl) 
{ 
  Activity a=getActivity();

  AssetManager manager = a.getAssets();
  try { 
    // println("la: trying "+path);
    String[] contents = manager.list(path); 

    if (contents == null || contents.length == 0)
      throw new IOException();
    sl.append(""+path +"/");
    for (String entry : contents) 
    { 
      if (path.equals("")) {
        listAssets(entry, sl);
      } else listAssets(path + "/" + entry, sl);
    }
  }
  catch (IOException e) 
  {//println("f: "+path);
    sl.append(path);
  }
}


