

import android.os.*;
import java.lang.reflect.*;

import com.jsyn.*;



void sg()
{
   Synthesizer synth = JSyn.createSynthesizer();
}


ListButton li;


String [] theList;
void addli(Actor a) {
  String mett= "com.jsyn.JSyn";//java.lang.reflect.Method";
  //println( android.R.style.Theme_Translucent_NoTitleBar);
  //java.lang.reflect.Field";
  
  li= new ListButton(mett, "tt", 
    theList=printMethods(mett)
    , 10);
  //li.oddcol=202;
 // li.backcolor=250;
  a.add(li);
  //li.collapse(true);
}

void tt(int i){
  UI.flash("had "+i);
}

String[] printMethods(String cn) {
  try {
    //"processing.core.PApplet"); 
    System.out.println("Methods for "+cn+" =");
    //returns the array of Method objects representing the methods of this class 
    Method m[] = Class.forName(cn).getDeclaredMethods();//Methods();
    String[] ret=new String[(m.length)];
    for (int i = 0; i < m.length; i++) { 
      System.out.println(m[i]);
      ret[i]=m[i]//.toString();//
        // .getName();
        .toGenericString();
    }
    return ret;
  } 
  catch (Exception e)
  { 
    System.out.println("Exception: " + e);
    e.printStackTrace();
  };
  return new String[]{};
}

String[]
  printFields(String cn) {
  try {
    /// Class cls = Class.forName(cn);

    //"processing.core.PApplet"); 
    System.out.println("Methods for "+cn+" =");
    //returns the array of Method objects representing the methods of this class 
    Field m[] = Class.forName(cn).getDeclaredFields();//Methods();
    String[] ret=new String[(m.length)];
    for (int i = 0; i < m.length; i++) { 
      System.out.println(m[i]);
      ret[i]=m[i]//.toString();//
        // .getName();
        .toGenericString();
    }
    return ret;
  } 
  catch (Exception e)
  { 
    System.out.println("Exception: " + e);
    e.printStackTrace();
  };
  return new String[]{};
}


