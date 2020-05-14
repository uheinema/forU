void ssdrtcopy(){
  String fontdir="";

//copyAssets("pre.gcode"); // copy known&existing file from data, works in preview
  // as preview can't handle asset subdirs by default
 
 //sex();// trigger explicit permission
   
 // copyAssets(""); // fine, but copys spyware junk
  // try it or
 // 
  // for(String s:listAssets("")){ println("asset: "+s); };
   // you will be surprised
   
  fontdir="fonts/";
  if (isPreview())
  {
    fontdir=solo(fontdir);
    // in local storage already, use them
    // memmapped
    // 
    //sketchPath("")+"/"+"fonts" +"/";
  
  } else {
    // can i memmap assets?
    // copuing to local instead of sd would do
    // or have sex...
    copyAssets(solo(),"fonts", CHECK); 
    // all from data/fonts, will not work for preview..
    // ..but has already happened.
    fontdir=solo(fontdir);
  }
  
}