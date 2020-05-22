
package forU.I;

public class Switch extends Button {
  //public Boolean state; // yes, uou may change this anytime
 
  public Switch(String name) {this(name,false);}
  public Switch(String name,Boolean init) {this(name,null,init);}
  public Switch(String name, String action,Boolean init){
     super(name,action);    
    // setSmall(true);
     state = init;
     w+=ts;
  }
   
   public boolean mousePressed(){
     state=!state ;
     super.mousePressed(); // action,please
     return true;
 // how can this change the reference? 
   }
   
   @Override public String displayText(){
     return txt.replace("#",state?"x":"");
   }
   
   public void draw(){  
    
    super.draw();
    if(!small){
    int ks=ts/2;
    if(!state){
      g.fill(boffcol);
      ks=ts/3;
    }
    else g.fill(boncol);
  
    g.rect(x+tw+ts+ts/4-ks/2,y+h/2-ks/2,ks,ks);//,ks/4);
   }
  }
  
}


