
float hash12(in vec2 _st) {
    return fract(sin(
         dot(_st.xy,
                         vec2(12.9898,78.233)
         )
     )*
        43758.5453123);
}


//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(vec3 p3)
{
	p3  = fract(p3 * .1031);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}



// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise2 (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = hash12(i);
    float b = hash12(i + vec2(1.0, 0.0));
    float c = hash12(i + vec2(0.0, 1.0));
    float d = hash12(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}


//? uhm jack
float noise3 (in vec3 _xyz) {
    vec3 i = floor(_xyz);
    vec3 f = fract(_xyz);

    // Four corners in 2D of a tile
    float a = hash13(i);
    float b = hash13(i + vec3(1.0, 0.0,0.0));
    float c = hash13(i + vec3(0.0, 1.0,1.0));
    float d = hash13(i + vec3(1.0, 1.0,1.0));

    vec3 u = f * f * (3.0 - 2.0 * f);

    return 
       mix(a, b, u.x) +   
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
       //// ,(c-b+a)*u.z);  // uhm
}


#define NUM_OCTAVES 5

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise2(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

float fbm3 ( in vec3 _xyz) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100.0);
    // Rotate to reduce axial bias
    mat3 rot = mat3(cos(0.5), sin(0.5),0.10,
                    -sin(0.5), cos(0.50),-0.30,
                   0.30,-0.40,0.10);
    for (int i = 0; i < NUM_OCTAVES; ++i) {
       vec3 n=vec3(noise3(_xyz),0.0,0.0);
        v += a * length(n);
        _xyz = rot * _xyz * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

vec4 fbm3(in vec4 v)
{
    return vec4(
      fbm(v.yz),
      fbm(v.zx),
      fbm(v.xy),0.0);
}

/*
const mat2 m = mat2(0.8,-0.6,0.6,0.8);

 float terrain( in vec2 p ) {
    float a = 0.0; float b = 1.0;
    vec2 d = vec2(0.0); 
    for( int i=0; i<15; i++ ) { 
     vec3 n = noise(p);
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



