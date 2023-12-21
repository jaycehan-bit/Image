attribute vec4 position;
attribute vec2 texturePos;
varying lowp vec2 varyingTexturePos;
void main() {
    varyingTexturePos = texturePos;
    gl_Position = position;
}
