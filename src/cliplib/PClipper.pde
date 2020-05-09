

import de.lighti.clipper.* ;
import PClipper.*;

// clipper uses LongPoint internally (why???)



 public
    Paths makeTile(float dist, 
    float maxx) {
    Paths pa=new Paths();
    ;
    maxx+=dist;
    maxx*=ClipDrawer.k1000;
    dist*=ClipDrawer.k1000;
    pa.add(dist, dist);
    pa.add(dist, maxx);
    pa.add(maxx, maxx);
    pa.add(maxx, dist);
  //  return pa;
   // theClip=
    return  ClipDrawer.inflateRound(pa, dist);
   // return theClip;
  }





