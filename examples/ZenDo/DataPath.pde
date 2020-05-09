/** * Copy the asset at the specified path to this app's data directory. 
 If th
 * asset is a directory, its contents are also copied.
 * * @param path
 * Path to asset, relative to app's assets directory. 
 */

// package garbage.c;
import android.os.Environment;
import android.content.res.*; //getAssrt
import android.app.*; // getActivity
// import android.content.Context; // type Actovity
import java.io.*;//FileOutputStream;
//import java.util.stream.*;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager; 

import android.support.v4.app.ActivityCompat; 
import android.support.v4.content.ContextCompat; 

String sketchName() {
  return this.getClass().getSimpleName();
}

// static
//final
 File mySD;
 
String SD(String relativeFilename) {
  if (mySD==null) 
  {
    getRWPermission();
    File externalDir = Environment.getExternalStorageDirectory();
    if ( externalDir == null ) {
      return null;
    }
  //   println("simple class (sketch) name is : " + externalDir );
    mySD = new File(externalDir, sketchName());
  }
  File finalDir =  new File(mySD, relativeFilename);
  return finalDir.getAbsolutePath();
}

boolean getRWPermission() {
  if (getP(Manifest.permission.WRITE_EXTERNAL_STORAGE))
    return getP(Manifest.permission.READ_EXTERNAL_STORAGE);
  return false;
} 


boolean hasP(String p) {
  //println("has "+p);
  return
    ContextCompat.checkSelfPermission(
    getContext(), p)
    == 
    PackageManager.PERMISSION_GRANTED;
}

boolean getP(String p) {
  // If do not grant permission. 
 // println("get "+p);
  if (hasP(p)) return true;

  try { 
    // Request user to grant write external storage permission. 
    ActivityCompat.requestPermissions(getActivity(), 
      new String[]{p}, 1);// REQUEST_CODE_WRITE_EXTERNAL_STORAGE_PERMISSION);
    //android will popup a confirm dialog which let you allow or deny the required permissions.
  }
  catch(Exception e) {
    toast("Keine Arme, keine Kekse!");
  };
  return hasP(p);
}

// target could be eg. SD()+"myfiles/"..
void copyAssets(String target,String path) 
{ 
  Activity a=getActivity();
  AssetManager manager = a.getAssets();
  // If we have a directory, we make it and recurse.
  // If a file, we copy its
  // contents.
  try { 
    println("copyassets: trying "+path);
    String[] contents = manager.list(path); 
    // The documentation suggests that list throws an IOException, but doesn't 
    // say under what conditions. It'd be nice if it did so when the path was
    // to a file. That doesn't appear to be the case. If the returned array is 
    // null or has 0 length, we assume the path is to a file. 
    // This means empty 
    // directories will get turned into files.
    //
    if (contents == null || contents.length == 0)
      throw new IOException();
    //println("Make the directory. ");
    File dir = new File(target+
      //a.getExternalFilesDir(null),
      path);
    dir.mkdirs(); 
   // println(" Recurse on the contents. ");
    for
    (String entry : 
    contents) 
    { 
      if (path.equals("")) {
        copyAssets(target,entry);
      } else copyAssets(target,path + "/" + entry);
    }
  } 
  catch (IOException e) {
    copyFileAsset(target,path);
  }
}

void listAssets(String path) 
{ 
  Activity a=getActivity();
  AssetManager manager = a.getAssets();

  //File dir = new File(a.getExternalFilesDir(null), "");//path);

  try { 
   // println("la: trying "+path);
    String[] contents = manager.list(path); 

    if (contents == null || contents.length == 0)
      throw new IOException();
    println("la: dir "+path +" ...");
    for (String entry : contents) 
    { 
      if (path.equals("")) {
        listAssets(entry);
      } else listAssets(path + "/" + entry);
    }
  }
  catch (IOException e) 
  {
    println("la: file: "+path);
  }
}

// same as loadString..both will NOT work
// for subdirectories in preview mode
// is APDE copying those subdirs?? seems so..
public String[] loadResStrings(String path)
{
  try {
    InputStream in = getActivity().getAssets().open(""+path); 
    //      InputStreamReader rr = new InputStreamReader(in); 
    //        BufferedReader br = new BufferedReader(rr);
    //  printreader(br);

    return loadStrings(in);
  }
  catch (IOException e)
  { 
    println("lrs: Oops Cant read from "+path);
  } 
  return null;
}

/** *
 * Copy the asset file specified by path to app's data directory.
 
 // Assumes * parent directories have already been created. 
 * * @param path * Path to asset, 
 * relative to app's assets directory. */

private boolean copyFileAsset(String target,String path) { 
  Activity a=getActivity();
  File file = 
    new File(target+
    //a.getExternalFilesDir(null),
    path); 
  try { 
   // println("trying to copy "+path);
    InputStream in = a.getAssets().open(path); 
    // InputStreamReader rr = new InputStreamReader(in); 
    //  BufferedReader br = new BufferedReader(rr);
   // println("open in ...");


    OutputStream out = new FileOutputStream(file); 
  //  println("open out..."+file.getName()+"@"+file.getPath());
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
   // println("copied ", r, " bytes");
    return true;
  } 
  catch (IOException e)
  { 
    println("Cant copy "+path+" to external");
    return false;
  }
}

boolean hadLocal = false;


String [] loadLocalStrings(String s)  {
  // try local dir first.
  String [] ss=null;
  try{
    ss=loadStrings(SD(s));
    // hack...had copy. 
    hadLocal=true;
    return ss;
  } 
  catch(Exception e){
    // .. or something else.
  }
  try {
    ss=loadStrings(s);
    // that seemed to work..save for later user mod
    saveStrings(SD(s),ss);
  }
  catch (Exception e){
    // now really, what else?
    println("throw up "+s);
  }
  return ss;
}


