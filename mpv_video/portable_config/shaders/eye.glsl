/*--- Constants ---*/
const mediump vec3 LumCoeff = vec3(0.212656, 0.715158, 0.072186);

/*--- Uniform variables ---*/
uniform lowp float uAdp_Delay;
uniform lowp float uAdp_TriggerRadius;
uniform lowp float uAdp_YAxisFocalPoint;
uniform lowp float uAdp_Equilibrium;
uniform lowp float uAdp_Strength;
uniform lowp float uAdp_BrightenHighlights;
uniform lowp float uAdp_BrightenMidtones;
uniform lowp float uAdp_BrightenShadows;
uniform lowp float uAdp_DarkenHighlights;
uniform lowp float uAdp_DarkenMidtones;
uniform lowp float uAdp_DarkenShadows;

/*--- Functions ---*/

/**
* Calculates the delta between desired luminosity level and the actual one
* @param luma Actual luminosity
* @param strengthMidtones Brightening/darkening factor for midtones
* @param strengthShadows Brightening/darkening factor for shadows
* @param strengthHighlights Brightening/darkening factor for highlights
* @return Total calculated delta
*/
vec3 calcDelta(lowp float luma, lowp float strengthMidtones, lowp float strengthShadows, lowp float strengthHighlights)
{
    float midtones = (4.0 * strengthMidtones - strengthHighlights - strengthShadows) * luma * (1.0 - luma);
    float shadows = strengthShadows * (1.0 - luma);
    float highlights = strengthHighlights * luma;
    return vec3(midtones, shadows, highlights);
}

/**
* Performs adaptation calculations and updates the input pixel values accordingly
* @param outputPixel Output pixel being processed
* @param luma Current pixel's luminosity
* @param avgLumaAdj Average adjusted luminosity value
* @param curve Curve multiplier applied to the calculation
*/
void performAdaptation(inout vec3 outputPixel, lowp float luma, lowp float avgLumaAdj, lowp float curve)
{
    float delta = 0.;

    if (avgLumaAdj < 0.5) {
        vec3 deltas = calcDelta(luma, uAdp_BrightenMidtones, uAdp_BrightenShadows, uAdp_BrightenHighlights);
        delta = deltas.r + deltas.g + deltas.b;
    } else {
        vec3 deltas = calcDelta(luma, uAdp_DarkenMidtones, uAdp_DarkenShadows, uAdp_DarkenHighlights);
        delta = -(deltas.r + deltas.g + deltas.b);
    }

    delta *= curve;
    outputPixel.rgb += delta;
}

/**
* Stores the current frame's average luminosity
* @param result Result variable passed down from the calling scope
* @param fragCoord Coordinates of the fragment currently processed
*/
void storeAvgLuma(out vec4 result, in vec2 fragCoord)
{
    result = texture(TexAvgLuma, vec2(0., 0.));
}

/*--- Main entry point ---*/
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    ivec2 coord = ivec2(fragCoord.xy);
    vec4 color = texture(RESHADER_TEXTURE_BACKBUFFER, fragCoord.xy);
    float luma = dot(color.rgb, LumCoeff);

    // Calculate adapted brightness
    float avgLumaCurrFrame = texture(TexAvgLuma, vec2(uAdp_YAxisFocalPoint, uAdp_TriggerRadius)).r;
    float avgLumaLastFrame = texture(TexAvgLumaLast, vec2(0., 0.)).r;
    float delay = clamp((sign(uAdp_Delay) * (0.815 + uAdp_Delay / 10.0 - iTime)), 0., 1.);
    float avgLuma = mix(avgLumaCurrFrame, avgLumaLastFrame, delay);

    // Perform adaptations
    vec3 outputPixel = color.rgb;
    performAdaptation(outputPixel, luma, uAdp_Equilibrium, uAdp_Strength * 10.0 * pow(abs(avgLuma - 0.5), 4.0));

    // Set final color
    fragColor = vec4(pow(clamp(outputPixel, 0., 1.), vec3(2.2)), 1.);

    // Store current frame average luminosity
    storeAvgLuma(result, fragCoord);
}