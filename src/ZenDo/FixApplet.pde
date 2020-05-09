



// to detect preview mode, create a textfile
// sketch/data/I/i.exist
// due to a bug(?) in PApplet
// this can only be loaded by an app, not a preview in APDE.
// nb: files in data/ itself always work
//
// How do they get there? And why not subdirs?
// By some magic (to be explained by calsign :)
// In PreviewActivity.java the assets are
// copied to local storage context.getFilesDir()) by
// PreviewUtil.copyAssets(this, dataFolder);
// ...and it DOES copy
// subdirs, and File(sketchPath("") +"/"+filepath) works
// (ok, nice to memmap them, and later be sorry in the app...)
// So PApplet.createInputRaw(), which most
// loadXYZ() functions use, should work, too.
// but it doesnt? Yep,. tries too much magic.
// In the end, sketchPath() throws up..
// Include the @Override sketchPath() below in your sketch to
// activate a workaround, should work in app and preview



// and if your curious or need to know
///  import android.content.Intent;
boolean isReallyPreview(){
 //// Intent intent = getActivity().getIntent();			
 /// String dataFolder = intent.getStringExtra("SKETCH_DATA_FOLDER");
 /// no ntk for Intent
 String dataFolder = 
    getActivity()
      .getIntent()
      .getStringExtra("SKETCH_DATA_FOLDER");
  
   // println("data :"+dataFolder);
  // if so, we have a local temporary(!) copy
  // of all assets in data/* already
  // use transparent or like solo(han)
  // if returning false, an app
  // might want to copy files to be mapped
  // (or otherwise not channeled through 
  // PApplet.createInputRaw())
  // to either solo() or even sex()
  return dataFolder!=null; // or empty..
}


/* testing */
/* // off
boolean isPreview =false;
boolean testedPreview=false;

// results depend on @Override sketchPass
@Deprecated
boolean isPreview() {
  final String exist="I/i.exist";
  if(testedPreview)
  return isPreview;
  else
  testedPreview=true;
  try {
    if (loadStrings( exist )!=null) {
      flash("App(like), found "+exist+" in assets.");
    } else
      flash("Oops, loadStrings() returned null?");
  }
  catch(Exception e) {
    // flash("Preview");
    isPreview=true; // or there was no i.exist
    // but see whether calsign signed this.
    try {
      //println(sketchPath(exist)); // kaboom...not even an exception?
      if (loadStrings( sketchPath("") +"/"+exist)!=null) {
        flash("Preview, found in local storage");
      } else
        flash("Ahbah..never happens?");
    }
    catch(Exception ee)
    {
      toast("No "+exist+" in assets or "+sketchPath("")+"/"+exist+
      "\nDid you put it in data/"+exist+"?");
    }
  }
  return isPreview;
}
/* ----- */



// sketchPath() is the real culprit.
// wont mess with createInputRaw hodgepodge
// ..for now.

@Override public String sketchPath(String where) {
  // just asking, not creating or checking permissions or existence...
  // ... by using File dependencies with unknown side effects.
  if (sketchPath != null&&where.length()>1)
  {
    // println("sp: "+where+" "+sketchPath); 
    if ('/'==where.charAt(0))
      return where;
    return sketchPath+"/"+where;
  }
  // nonsense, bwtf...
  return super.sketchPath(where);
  /* which is (stinking dead code...) this:
    // isAbsolute() could throw an access exception, but so will writing
   // to the local disk using the sketch path, so this is safe here.
   // for 0120, added a try/catch anyways.
   try {
   if (new File(where).isAbsolute()) return where;
   } catch (Exception e) { }
   
   return surface.getFileStreamPath(where).getAbsolutePath();
   
   */
}

// PApplet.createFont() is insisting on loading from assets
// uncool if in APDEpreview (where it was moved to local storage)
// or when trying to load from a specified path (eg. external)
// todo: how about webref?? test it..
import android.graphics.Typeface;
import processing.core.PFont; // just to mention

@Override public PFont createFont(String name, float size) {
  // if we want to load from a file, no
  // point in forceful redirecting to an asset or system font!
  // just do it...and forget xxxAbsolutexx unless it is Vodka
  //println("cf: "+name);
  if (name.charAt(0)=='/'){     
    Typeface baseFont = Typeface.createFromFile(name);
    return new PFont(baseFont, round(size), true, null);
  }
  // so far...but this is not using createInputRaw resolution,
  // for preview..is it worth a fix?
  try{
    // While i am at it.. will also find fonts previously installed locally
    // ?? its a feature ...better explicit for nonoverridden sketchPath
    // call ourself
    PFont loco=createFont(sketchPath("")+"/"+name,size);
    if(loco!=null) return loco;
  } catch ( Exception ignore ){
    // dhoild be more specific
  }
  // native or asset
  return super.createFont(name, size);
  // you dont want to know what that is. really.
}
