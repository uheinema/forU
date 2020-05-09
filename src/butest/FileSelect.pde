
import android.content.*;
import android.app.*;//Activity;
/*  does not exist here
import androidx.activity.result.*;//ActivityResultCallback<O>;


class myc extends ActivityResultCallback<Uri> {
   @Override
    public void onActivityResult(Uri uri) {
        // Handle the returned Uri
      println("urin"); 
    toast("Butter");   
           
  }
}

vood lainch() {
  ActivityResultLauncher<String> mGetContent = 
    registerForActivityResult(new GetContent(), 
        new myc());
  mGetContent.launch("image/*");
}
*/


@Override void onActivityResult(int requestCode, int resultCode, Intent result)
 { 
     super.onActivityResult(requestCode, resultCode, result); 
  /*
  switch(requestCode) {
     case AuthenticationActivity.AUTH_REQUEST_COMPLETE:
      if(resultCode==RESULT_OK) { 
        access_token =authActivityResult;
     }
*/
toast("ti; "+result.getData());
 println("ti; "+result.getData());
}

private static final int FILE_SELECT_CODE = 3450; 
private void showFileChooser() { 
  final Activity act = getActivity(); 
 //Intent intent = new Intent(Intent.ACTION_PICK);
   Intent intent = new Intent(Intent.
  //ACTION_OPEN_DOCUMENT);
    ACTION_GET_CONTENT); 
  intent.setType("text/plain");
  intent.setPackage( "com.ghisler.android.TotalCommander");
  //intent.setClass("com.ghisler.android.TotalCommander.files");
  
     
  intent.addCategory(Intent.CATEGORY_OPENABLE);
 // intent.addCategory(Intent.CATEGORY_APP_FILES);
  try { 
    act. startActivityForResult ( 
      Intent.createChooser(intent, "Was hamma?"), 
      FILE_SELECT_CODE);
  } 
  catch (android.content.ActivityNotFoundException ex) { 
    // Potentially direct the user to the Market with a Dialog 
    toast("Please install a File Manager.")
      ;
  }
}
