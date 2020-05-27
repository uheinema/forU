
import android.content.*;
import android.app.*;//Activity;
       
@Override void onActivityResult(int requestCode, int resultCode, Intent result)
 { 
   switch(requestCode) {
  case FILE_SELECT_CODE:
    if (resultCode == Activity.RESULT_OK) {
      String temp_path = result.getData().getPath();
      println("got "+temp_path);
      int last_index =  temp_path.lastIndexOf(':');
      temp_path = temp_path.substring(last_index+1);
      String path = new String(Environment.getExternalStorageDirectory().getAbsolutePath() +"/"+ temp_path);
      last_index = path.lastIndexOf('.');
      String ext = path.substring(last_index+1);
      break;
    }
  }
 super.onActivityResult(requestCode, resultCode, result); 
  
  
UI.toast("ti; ");//+result.getData());
// println("ti; "+result.getData());
}

String chooser=
  // "com.android.documentsui";
 ///  "com.rootzero.graphite/
 "com.nononsenseapps.filepicker.FilePickerActivity";
//"com.google.android.apps.docs";
    // "com.ghisler.android.TotalCommander"

private static final int FILE_SELECT_CODE = 3450; 
 void showFileChooser() { 
  final Activity act = getActivity(); 
 //Intent intent = new Intent(Intent.ACTION_PICK);
   Intent intent = new Intent(Intent.
 // ACTION_OPEN_DOCUMENT);
    ACTION_GET_CONTENT); 
    intent.putExtra(EXTRA_ALLOW_CREATE_DIR, true);
   //  intent.putExtra(EXTRA_ALLOW_MULTIPLE, false); 
  //   intent.putExtra(EXTRA_MODE, mode); 
   //  if (!StringUtils.isEmpty(startPath) && new File(startPath).exists())
   
 /// intent.setType("text/plain");
 
  // intent.setClassName(chooser,chooser+".DirBrowseActivity2");
    // intent.setPackage(chooser);
  // intent.addCategory(Intent.CATEGORY_OPENABLE);
 // intent.addCategory(Intent.CATEGORY_APP_FILES);
   intent.putExtra(EXTRA_START_PATH, sex());
//  startActivityForResult(i, FILE_CODE); 


  try { 
    act. startActivityForResult ( 
      Intent.createChooser(intent, "Was hamma?"), 
      FILE_SELECT_CODE);
  } 
  catch (android.content.ActivityNotFoundException ex) { 
    // Potentially direct the user to the Market with a Dialog 
   UI. toast("Please install a File Manager.")
      ;
  }
}

public static final String EXTRA_START_PATH = "nononsense.intent" + ".START_PATH";
    public static final String EXTRA_MODE = "nononsense.intent.MODE";
    public static final String EXTRA_ALLOW_CREATE_DIR = "nononsense.intent" + ".ALLOW_CREATE_DIR";
    public static final String EXTRA_SINGLE_CLICK = "nononsense.intent" + ".SINGLE_CLICK";
    // For compatibility
    public static final String EXTRA_ALLOW_MULTIPLE = "android.intent.extra" + ".ALLOW_MULTIPLE";
    public static final String EXTRA_ALLOW_EXISTING_FILE = "android.intent.extra" + ".ALLOW_EXISTING_FILE";
    public static final String EXTRA_PATHS = "nononsense.intent.PATHS";
    

import java.util.*;
import android.content.pm.ResolveInfo;
import android.content.pm.PackageManager;
void showR(){
 
//  public abstract List<ResolveInfo> queryIntentActivities (Intent intent, int flags)
 
/// ddIntentOptions(int groupId, int itemId, int order, ComponentName����������������caller, Intent[] specifics, Intent intent, int flags, MenuItem[] outSpecificItems)
final Activity act = getActivity(); 
 //Intent intent = new Intent(Intent.ACTION_PICK);
   Intent intent = new Intent(Intent.
  //ACTION_OPEN_DOCUMENT);
    ACTION_GET_CONTENT); 
  //intent.setType("text/plain");
  //setSourceBounds
  String cn= "com.ghisler.android.TotalCommander";
  //intent.setClass( "");
 // com.android.documentsui/.
 if(false)try{
  // println("try");
  // Class<?> cl=  Class.forName(cn+ ".DirBrowseActivity2");
 // println("try cfg");
   intent.setClassName(cn,cn+".DirBrowseActivity2");
  // println("svnj");
 }catch (Exception ignore) {
   intent.setPackage(cn);
 };
  
  // intent.addCategory(Intent.CATEGORY_OPENABLE);

   List<ResolveInfo> li;
   PackageManager pm =getContext().getPackageManager();
   li=pm.queryIntentActivities(intent,0);
   for(ResolveInfo info:li){
     println(info.toString());
   }
   
 }
