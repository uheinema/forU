#version 310 es

#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D texMap;

uniform vec2 texOffset; // is ignored??..

uniform int lightCount;

uniform int lightNr; // special effects

 in vec4 vertColor;
 in vec4 backVertColor;

 in vec4 vertTexCoord; 

in flat int hasTex; // texture width

in vec3 ambientPart;

in vec4 obj_position;  // for material !

 out vec4 was_gl_FragColor;
// why they changed that, I can't say ...

vec4 packDepth(float depth) {
   float depthFrac = fract(depth * 255.0);
    return vec4(depth - depthFrac / 255.0, depthFrac, 1.0, 1.0);
}

#define TEX3D_GOES_HERE 1

vec4 mainc(void)
{
   if(lightNr-2>=lightCount) // depth map etc.
   {
      return ((lightNr&1)==0)?
         packDepth(gl_FragCoord.z): // 16 bit res
         vec4(gl_FragCoord.zzz,1.0); // visual
      
   }
  
     vec4 vFragColor = gl_FrontFacing ? vertColor : backVertColor;
     if(hasTex>1)
    {
#ifdef TEXGEN
        vec4 t=texelColor(0);

        if(toByte(t.r)==11
          &&toByte(t.g)==8
          &&toByte(t.b)==60)
        { // magic  color

         t=texelColor(1);

         return texture3D(vFragColor,toByte(t.b));
        }
       else // default  texlight shader behaviour
 #endif
         return vFragColor*texture(texMap,vertTexCoord.st);
    }
    return vFragColor;
 
}

 
void main(void)
{
    was_gl_FragColor=mainc();
}







