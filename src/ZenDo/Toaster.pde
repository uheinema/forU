
import android.widget.Toast;


class Toaster implements Runnable {
  String t;
  int l;
  Toaster(String _t,int _l){t=_t;l=_l;}
  public void run(){
    Toast.makeText(getActivity(),
     t,l).show();
  }
}

void toast(String msg){
  getActivity().runOnUiThread(new Toaster(msg,1));  
}
void flash(String msg){
  getActivity().runOnUiThread(new Toaster(msg,0));  
}

