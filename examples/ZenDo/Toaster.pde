
import android.widget.Toast;


class Toaster implements Runnable {
  String t;
  Toaster(String _t){t=_t;}
  public void run(){
    Toast.makeText(getActivity(),
     t,1).show();
  }
}

void toast(String msg){
  getActivity().runOnUiThread(new Toaster(msg));  
}

