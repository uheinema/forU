
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ClipDescription;
import android.content.Context;
import android.app.Activity;
import android.os.Looper;

void setClip(String str) {
  // Copy to clipboard
  // Tnx to https://github.com/EmmanuelPil/Android-java-code-utilities-widgets-for-Processing-for-Android
  Activity act;
  Context cnt;
  act = this.getActivity();
  cnt = act.getApplicationContext();
  // Looper.prepare(); ??? must we..no ???
  android.content.ClipboardManager clipboard = (android.content.ClipboardManager) cnt.getSystemService(Context.CLIPBOARD_SERVICE);
  android.content.ClipData clip = android.content.ClipData.newPlainText("text", str);
  clipboard.setPrimaryClip(clip);
}

