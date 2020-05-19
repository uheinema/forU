
package forU.I;


import processing.core.PApplet;
import android.content.Context;
import android.view.inputmethod.InputMethodManager;

/**
 * The KetaiKeyboard class allows the soft keyboard to be managed.
 */
public 
class Keyboard extends I {

	/**
	 * Toggle.
	 *
	 * @param parent the PApplet/sketch 
	 */
	static public void toggle(PApplet parent) {

		InputMethodManager imm = (InputMethodManager) parent.getActivity()
				.getSystemService(Context.INPUT_METHOD_SERVICE);

		imm.toggleSoftInput(0, 0);
	}

	/**
	 * Show.
	 *
	 * @param parent the PApplet/sketch 
	 */
	static public void show(PApplet parent) {
		InputMethodManager imm = (InputMethodManager) parent.getActivity()
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.showSoftInput(parent.getActivity().getCurrentFocus(), 0);
	}

	/**
	 * Hide.
	 *
	 * @param parent the PApplet/sketch 
	 */
	static public void hide(PApplet parent) {
		InputMethodManager imm = (InputMethodManager) parent.getActivity()
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(parent.getActivity().getCurrentFocus().getWindowToken(),
				0);

	}

// open/closeKeyboard both toggle!
/*

isKeyOpen?
mRootWindow = getWindow(); 
mRootView = mRootWindow.getDecorView().findViewById(android.R.id.content);
 mRootView.getViewTreeObserver().addOnGlobalLayoutListener(
  new ViewTreeObserver.OnGlobalLayoutListener()
   { 
     public void onGlobalLayout(){
        Rect r = new Rect();
         View view = mRootWindow.getDecorView();
          view.getWindowVisibleDisplayFrame(r); 
          // r.left, r.top, r.right, r.bottom 
         } 
   }
   );
   ah wtf
*/
  
  public static void showKeyboard(boolean b){
    if(b)  
     show(me);
    else
    {
     hide(me);
   //  keyTarget=null;
    }
   // keyopen=b; // or not, user may have closed
  }


public interface KeyConsumer {
  void consumeChar(char c);
 // boolean hasFocus(){return this==keyTarget;}
}

static KeyConsumer keyTarget;

public static void show(KeyConsumer k){
  showKeyboard(true);
  keyTarget=k;
}

public static void hide(){
  showKeyboard(false);
  keyTarget=null;
};

public static boolean hasFocus(KeyConsumer k){
  return k==keyTarget;
}
/*
void backPressed(){ /// does not work this way
// override in PApplet
  if(keyTarget!=null)
  {
    showKeyboard(true);
  }
  else
   println("outback!");/// exit();
 }
*/

 public static void keyPressed(char key,int keyCode){
 // println("pressed ("+int(key)+") "+key);
  
  if (key==PApplet.CODED){
    //print("coded: ");
    switch(keyCode){
      case 4:     
          PApplet.println("This is the end.");
          
          return;
         
      case PApplet.SHIFT:
   //       println("no shift wanted");
          return;
      case PApplet.BACKSPACE:
      //    println("juhu, backspace");
          key='\b';
          break;
      default:
        PApplet. println("kcode?? "+keyCode);
         key='¿';
    }
  }
  if(keyTarget!=null) keyTarget.consumeChar(key);
}
}



