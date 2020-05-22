

package forU.I;


import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.PopupMenu;
import android.widget.PopupMenu.OnMenuItemClickListener;
import android.widget.TextView;
import android.app.Activity;
import android.content.Context;
import android.widget.FrameLayout;
import android.view.ViewGroup.LayoutParams;
import android.view.Gravity;
import android.R;
import android.widget.RelativeLayout;
import processing.android.CompatUtils;
import android.graphics.Color;
import android.view.WindowManager;
import android.support.v7.widget.Toolbar;
import android.content.ContextWrapper;
//import android.widget.AppCompat;
import android.support.v7.view.ContextThemeWrapper;
import android.os.Bundle;
import android.view.SubMenu;

// are we through, yet?
import forU.I.UI;
import forU.I.Actor;
import forU.I.Button;


public class MenuBar extends Actor {

// use android intrrface as a singleton
// 
//ctivity act; 
static int menuanchorId;
static int menubarId;
static boolean toggle;
static TextView menubar;
static public boolean transparent=false;

public MenuBar(String t){
  super();
  txt=t;
  backcolor=Color.rgb(70, 70, 120);
  this.setup();
}


public void  setup() {
me.getActivity().runOnUiThread(
    new Runnable() {
    public void run() {
      runStartup();
    }
    }
    );
 }    
      
public void setTitle(String t){
  menubar.setText(txt);
}

public void show() {
   show(true);
}

 public void hide() {
   show(false);
}

public boolean visible() {
  return toggle;
}
       
public boolean show(boolean vis) {
  toggle=vis;
  me.getActivity().runOnUiThread(
    new Runnable() {
    public void run() {
      TextView tv = (TextView)me.getActivity().findViewById(menuanchorId);
      TextView tvv = (TextView)me.getActivity().findViewById(menubarId);
      if (toggle) {
        tv.setVisibility(View.VISIBLE);
        tvv.setVisibility(View.VISIBLE);
      } else {
        tv.setVisibility(View.GONE);
        tvv.setVisibility(View.GONE);
      }
    }
  }
  );
  ///toggle =! toggle;
  //toggle=true;
  return toggle;
}

public  void runStartup() {
  final Context mC;
  final FrameLayout fl;
  final Activity act = //this.
     me.getActivity();
  int width = me.width;
  mC= act.getApplicationContext();
  // To prevent status bar showing up
  act.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
  int mbts=ts/3;
  
  menubar = new TextView(act);
  menubar.setLayoutParams(new RelativeLayout.LayoutParams(width-width/12, width/12));
  menubar.setTextSize(mbts); //pts per pix???
  menubar.setX(0);
  menubar.setY(0);
 // menubar.setGravity(Gravity.CENTER);
  if(!transparent) menubar.setBackgroundColor(backcolor);// Color.rgb(70, 70, 120));
  menubar.setTextColor(Color.WHITE);
  menubar.setText(txt);
  menubar.setVisibility(View.GONE);
  //menubarId=CompatUtils.getUniqueViewId();
  menubarId = View.generateViewId();
  menubar.setId(menubarId);

  TextView menuanchor = new TextView(act);
  menuanchor.setLayoutParams(new RelativeLayout.LayoutParams(width/12, width/12));
  menuanchor.setTextSize(mbts);
  menuanchor.setTextColor(Color.WHITE);
  menuanchor.setX(width-width/12);
  menuanchor.setY(0);
  if(!transparent) menuanchor.setBackgroundColor(backcolor);
  menuanchor.setGravity(Gravity.CENTER);
  menuanchor.setText("⋮");
  menuanchor.setVisibility(View.GONE);
  menuanchorId = View.generateViewId();
  menuanchor.setId(menuanchorId);
  
  menuanchor.setOnClickListener(new View.OnClickListener() {
    public void onClick(View view) {
      
      TextView menuanchor = (TextView) act.findViewById(menuanchorId);
      PopupMenu popupMenu = new PopupMenu(mC, menuanchor);
      // we are an actor, so we have a bunch of buttons, hopefully
      int i=0;
      for(Button b:buttons){
        popupMenu.getMenu().add(Menu.NONE, i+1, i, b.displayText());
        i++;
      }
      
      popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
        public boolean onMenuItemClick(MenuItem item) {
          // UI.flash(action);
         int id=item.getItemId()-1;
         if(id>=0&&id<buttons.size()){
           return buttons.get(id).mousePressed();
         }
          UI.flash("menu: erratic id "+id);
          return false;
         
        }
      }
      );
      popupMenu.show();
    }
  }
  );

  fl = (FrameLayout)act.findViewById(R.id.content);
  fl.addView(menubar);
  fl.addView(menuanchor);
}


}