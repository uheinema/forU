
package forU.I;


import processing.core.PApplet;
import processing.core.*;

import java.lang.reflect.*;
import java.util.List;

import android.content.Context;

public class Action extends I //
  // implements Interact, PConstants
{

  public String action, txt;
  public int param;

  public Action(String text, String action, int param) {
    this.action=action;
    this.txt=text;
    this.param=param;
  }

  public Action(String text) {
    this(text, null, 0);
  }
  
  public Action(String text, String ac) {
    this(text, ac, 0);
  }

  private Method maction ;
  private boolean hasParam=false;
  private Object owner;

  public Action(String _name, String a, Object _owner) {
    this(_name, a);
    // maction=_maction;
    owner=_owner;
  }

  public Action bind(Object _owner) {
    owner=_owner;
    return this;
  }

  public Action setMethod(Method m) {
    maction=m;
    return this;
  }

  public Action setMethodI(Method m) {
    maction=m;
    hasParam=true;
    return this;
  }

  public boolean act(String action) {
    return act(action, param);
  }

  public boolean act() {
    return act(param);
  }

  public boolean act(int param) {
    return act(action, param);
  }

  public boolean act(String action, int param)
  {

    if (action==null||action=="") {
      if (maction==null) return false;
    }

    // PApplet.println("Trying to call "+action+" from "+txt);

    if (action.charAt(0)=='@') {
      // action=action.substring(1);
      UI.schedule(this);// action+"#"+param));
      return true;
    }
    String []acts=action.split("#");
    if (acts.length>1) {
      param=Integer.parseInt(acts[1]);
    }
    Method aMethod=maction;

    if (owner==null) owner=me; // from I
 
    if (aMethod==null) try {
      aMethod =
        owner.getClass().getMethod(acts[0], new Class[] {});
      hasParam=false; // defensive
    } 
    catch (Exception e) {
      // no such method, or has parameters
      // .. which is fine, just ignore
    }
    if (aMethod==null) try {
      aMethod =
        owner.getClass().getMethod(acts[0], new Class[] {int.class});
      hasParam=true;
    } 
    catch (Exception e) {
      UI.toast("No method '"+action+"' on '"+owner.getClass().getName());
      return true;
    }

    if (aMethod != null) {
      try {
        if (hasParam)
          aMethod.invoke(owner, new Object[] {(int)param});
        else
          aMethod.invoke(owner, new Object[] {});
        return true;
      } 
      catch (Exception e) {
        // wrong type?
        UI.toast("Oops, problem on method invoke? Caused by '"+action+"' on '"+owner.getClass().getName());
        e.printStackTrace();
        return true;//return false;
      }
    } // if method
    return true ; //:never happens?
  } // handlepressed
} // class button
