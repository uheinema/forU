

class Label extends Button {
  
   @Override
   public void drawBack(){;}; // nothing
    
    Label(String t) {
      super(t, "");
      textcol=0xffffff99; // todo
    };
    
    public Label setText(String t){
       String r="";
       while(t.length()>15){
         int i=t.lastIndexOf("/");
         if(i>0){
           r=t.substring(i)+"\n  "+r;
           t=t.substring(0,i);
         }
         else
          break;
       }
       r=t+r;
       txt=r;
       return this;
    }
    
    @Override
    
    public void draw(){
      int ots=ts;
      ts=40; // temp override ts
      super.draw();
      ts=ots;
    }
}

