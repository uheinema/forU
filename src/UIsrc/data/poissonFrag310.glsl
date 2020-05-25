#version 310 es

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

in vec4 vertTexCoord;
out vec4 was_gl_FragColor;
uniform sampler2D texMap;

///uniform float sigma;      
   
      // ... play around with this based on what you need :)
float sigma=10.0;



   const vec2 poissonDisk[10] = vec2[] (
      vec2(0.95581, -0.18159), 
      vec2(0.50147, -0.35807), 
      vec2(0.69607, 0.35559),
      vec2(-0.0036825, -0.59150),
      vec2(0.15930, 0.089750), 
      vec2(-0.65031, 0.058189),
      vec2(0.11915, 0.78449),
      vec2(-0.34296, 0.51575), 
      vec2(-0.60380, -0.41527),
      vec2(0.0,0.0) // go to 10 for central sample
  );


void main() {  
 
  vec2 p = vertTexCoord.st;
  
 
  vec4 avgValue = vec4(0.0, 0.0, 0.0, 0.0);

  // Take the central sample first...
  avgValue += texture(texMap, p) ;

  // have a look around..maybe just add( 0 ,0)
  for( int  i=0;i<9;i++)
 {
    avgValue+=texture(texMap,p+sigma*0.001*poissonDisk[i]);
  }

  was_gl_FragColor =max(vec4( 0.091*avgValue.rgb,1.0)
    ,vec4(11.0/255.0,8.0/255.0,60.0/255.0,1.0)
   );
}