

  
    
   String [] testing(){
     return testdate;
    }

String[] testmark={ // quarters grimis mark
 ":E b #Text#↑ er ;", 
 
 " *0.89 { xX0.015x ( 6 ) hatch e  } ",
 " :Ke ( \nFrauke Schlegelmilch\n"+
  "Eschstr. 6\n"+
  "48739 Legden ) #Text ;",
 " { xyx10< x4/20 #Font#thin Ke e  }  rect  l ",
 // " { /2xx2 ( 1sign , 0.02 ) warpS }",
// " {  smaller8 b prect e h smaller6 prect er  } ",
  //" #Font#pen#PENUTURE.TTF #Font#pen ",
 //" /8*12 #Font#pen#CODE2001.TTF #Font#pen ",
 " {  #Font#font E er }  ",
   " { ( b grimi c50 , 0.3 ) warpS mark L73e  reserve } ",
  " (  spiro c e ) q2 ",
  " ( smaller8 rect l b grimi dmark er ) q3 ",
   "  ( back ) q0 ",
   " (  ( b grimi e reserve , 0.3 ) warpS  ( ( ) clock , 0.05 ) warpS ) q1 ",
  ""};

/*
//" spiro L39e [ b8 ]  back2",

  
*/

String[] init={
  
  
" :spiro { center /5  bv vx>vx>vxx>vxx>vxxx>v ",
  " xxx>v xxxx>v xxxx>v xxxxx>v ",
  " xxxxx>v   xxxxxx>v  xxxxxx>v   xxxxxxx>v ",
  " xxxxxxx>v  xxxxxxxx>v xxxxxxxx>v  xxxxxxxxx>v ",
  "  } ; :b8 {!1 ( { smaller8 prect [ spiro e ] } )  board8  }  ; ",
  
  
  " :flag2 {!1 /2 { ( {  dart  [  ]  e } y0.4$#second ) 4 } } ; ",
  
  "  :spike { }  ; ",
  
  
  "  :pround4 {  ./2xy .b ( .{xv}>8 ) 8 ( .{xv}>8 ) 3 } ; ", 
  "  :ofci{ { .>6!1 ./2x2 pround4 .ce    ;", 
" :sign { /3xy 1sign } ; :1sign { /3xyx/2 #Font#linear-b #Text#UL\nRI\nCH eiiiiiddddd1.5ei4e reserve } ;",
   ":dmark { ( Y0.3 y-2 dart reserve ) #HereRS } ; ",
 
   ":mark { ( /100 rim rect reserve ) #HereR } ; ",

  " :aurac { smaller2 circle ./8eieieieie } ; "+
  " :blob ofci{ [ ( motiv , srect ) checker ] } ;", 
  ":testc { /9xy*4 b pcircle ./8eieieieieie reserve }  ;", 
  " :ofre { ./5 .xxxyy .*2  .>5  ( .>3 , $ ) rotated srect } ;  "+
  " ", 
  ":dots&circles ( ", 
  "   { smaller8 dart .m10em10ei10e } reserve  ", 
  "  , testc ) chess4 ; ", 
  /*
   ":q0 { /2 prect [ center *0.95 rim rect limit $ ] } ;",
  ":q1 { y2 ( $ ) q0 } ; :q2 { x2 q0 } ; :q3 { x2y2 q0 } ;",
  ":warp{ .{!1 ;",
  ":tback >>  $ >> ; ",
  ":warpT { $ warp{ { ( $ ) tback $1 } } } ;",
  ":warpS { *$ warp{ { /$ $1 } } } ;",
  // ( n , what )
  ":warpN ( $1 , ( $ ) ./$y3*$  ) warpT ;",
  */
  ":sdart { smaller6 b pdart c10e } ; ",

  ""
};




String[] testhorde={ // grimi horde
  "rect limit",
  " :lsign { /3xxyy/4 #Font#linear-b #Text#Ull\nric\nhHe\nine\nmann eiiiiiddddd1.5ei4e reserve } ;",

 " *0.8 lsign  b grimi ce reserve",
  " ( *2 ) central",
  " !1 ( {  *1.5 b grimi  e reserve } , ) chess16"
};


String[] testdate={ // date frame
  // 
   
  "rect  limit ",
  
    
  "frames // smallclock ", 
 //  " { !2 Date }",
  " {!0 *0.6x4 #Font#arkhip #Frame e} ", 
 "      [ dots&circles ] ei67e reserve ",
 " {!0 {!1 b prect cd9 [ back2 ] e }} back"
};



String [] testblub7={
  " :blub {!1  x4y4 .*0.4$#Text#Ω } ; ", 
  " :blab {!0  x6y5 .*0.4$#Text#α } ; ", 
 
  " :blubL blub P80 ; :blabL blab P80 ;", 
  // " Date",
   " b ( 7 ) ppoly ed90e limit #Font#font ",
  "( blubL , blabL ) bla3", 
  
  "  back ", 
  ""};

String[] testbase={
  //  [ ( ) smci limit $ ] ( ) smci reserve
  // " ( smci , dots&circles ) string",
  " :pol7  (  /1.05>$#second ) central  ( 7 ) poly  ;", 
  "  :smci {!3  smaller8 rect $ } ; ", 
  " rect limit frames smallclock ", 

  //" ( >$#second , dart d50ed50e  limit ) rotated ",
  // " smallclock",//
  //"  ( ) ofre [ motiv  ] ",
  " :_ins { d9el", 
  "   ( .>10 , dots&circles ) rotated } ;", 
  " { flag } ", 
  //" ofci{ [ e h64 ] } ",
  "{ x2y4 blob  }", 

  " { pol7 } [ _ins ]  ", 
  "  ( .>65*1.4 , h64 ) rotated ", 
  ""};


