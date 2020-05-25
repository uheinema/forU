#version 310 es

#ifdef GL_ES
precision mediump int;
#endif

uniform mat4 transformMatrix;
uniform mat4 texMatrix;

in vec4 position;
in vec2 texCoord;

out vec4 vertTexCoord; // keep at 4 for minimal 110 compat
// and gl_Position...

void main() {
  gl_Position = transformMatrix * position; // must be
    
  vertTexCoord = 
    texMatrix *  // leave out to turn upside down...why not
         vec4(texCoord, 1.0, 1.0);
}