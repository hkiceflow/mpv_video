#ifdef GL_ES
precision mediump float;
#endif

// Include the necessary definitions and helper functions from vort_Defs.fxh
struct PSInput {
    vec2 texCoord;
};

uniform sampler2D textureSampler;

// Replace this with the actual contents of vort_ColorChanges.fxh
void adjustContrast(inout vec3 color, float contrast) {
    color = (color - 0.5) * contrast + 0.5;
}

void main() {
    PSInput input;
    input.texCoord = gl_FragCoord.xy / screenSize.xy;
    
    // Sample the source texture
    vec4 color = texture2D(textureSampler, input.texCoord);
    
    // Adjust contrast
    adjustContrast(color.rgb, 1.2); // Example value
    
    // Set output color
    gl_FragColor = color;
}