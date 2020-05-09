// Tex3D.glsl
// common code included for frag and vert

//uniform vec4 param;
#define UNIFORMS_GO_HERE 1

#define FBM_GOES_HERE 1

#define WORLEY_GOES_HERE 1

/// procedural texture helpers

vec4 checker(vec4 p){
return step(
    mod(p/10.0,  vec4(2.0)),
    vec4(1.0));
}

vec3 wood(vec4 p){
  return vec3((1.0+cos(sqrt(p.x*p.x+p.y*p.y)))*0.5);
}

vec4 tex(vec2 st){
  return texture(texMap,st);
}

vec3 rotateZ(in float phi, vec3 v){
    mat2 rot = mat2(cos(phi), sin(phi),
                    -sin(phi), cos(phi));
   return vec3(rot*v.xy,v.z);
}


/*
const mat2 m = mat2(0.8,-0.6,0.6,0.8);

 float terrain( in vec2 p ) {
    float a = 0.0; float b = 1.0;
    vec2 d = vec2(0.0); 
    for( int i=0; i<15; i++ ) { 
     vec3 n = noise2(p);
     d += n.yz; 
     a += b*n.x/(1.0+dot(d,d));
     b *= 0.5;
     p = m*p*2.0; 
   }
 return a; 
}
*/
/*
// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float Qnoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);


    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}
*/

vec4 f_A(vec4 v,float f) {  return vec4(v.xyz,f);}

vec4 f_Z(vec4 v,float f)
{
  return vec4(v.xy,f,v.a);
}

vec4 f_Y(vec4 v,float f)
{
 v.y=f; return v;
 // return vec4(v.x,f,v.ba);
}
vec4 f_X(vec4 v,float f)
{
  return vec4(f,v.gba);
}

// texture access 

vec4 texelColor(int ofs)
{
 // could use %/div width/height, but for max 2...
 return texelFetch(texMap,ivec2(ofs,0),0);
}

int toByte(float f)
{
  return int(round(f*255.0));
}

float fscalb(float t,float ex){
  return t * exp2(ex);
}

float texelFloat(int i){
  vec4 v=texelColor(i);
  float t= v.r*255.0;
  t+=v.g;
   int ex=toByte(v.b);
   bool sig=(ex>=128);
   if(sig) {ex-=128;t=-t;};
   ex-=64; 
   return t*exp2(float(ex)-7.0);
}

#define TEXGEN_GOES_HERE 1

// bot Tex3D.glsl

