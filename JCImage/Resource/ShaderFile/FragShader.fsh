uniform sampler2D colorMap;
varying lowp vec2 varyingTexturePos;
void main() {
    gl_FragColor = texture2D(colorMap, varyingTexturePos);
}
