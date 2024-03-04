precision highp float;
uniform sampler2D texture_Y;
uniform sampler2D texture_U;
uniform sampler2D texture_V;
varying vec2 v_texcoord;

void main()
{
    highp float y = texture2D(texture_Y, v_texcoord).r;
    highp float u = texture2D(texture_U, v_texcoord).r;
    highp float v = texture2D(texture_V, v_texcoord).r;
    highp float r = y + 1.402 * v;
    highp float g = y - 0.344 * u - 0.714 * v;
    highp float b = y + 1.772 * u;
    gl_FragColor = vec4(r, g, b, 1.0);
}


