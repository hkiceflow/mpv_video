//!MAGPIE EFFECT
//!VERSION 3
//!OUTPUT_WIDTH INPUT_WIDTH
//!OUTPUT_HEIGHT INPUT_HEIGHT
//!SORT_NAME SMAA_3

//!TEXTURE
uniform sampler2D INPUT;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R16G16_FLOAT
uniform sampler2D edgesTex;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R16G16B16A16_FLOAT
uniform sampler2D blendTex;

//!TEXTURE
//!SOURCE AreaTex.dds
//!FORMAT R8G8B8A8_UNORM
uniform sampler2D area Tex;

//!TEXTURE
//!SOURCE SearchTex.dds
//!FORMAT R8_UNORM
uniform sampler2D searchTex;

//!SAMPLER
//!FILTER NEAREST
uniform sampler2D PointSampler;

//!SAMPLER
//!FILTER LINEAR
uniform sampler2D LinearSampler;


//!COMMON

#define SMAA_RT_METRICS vec2(vec2(0.5), vec2(textureSize(INPUT, 0))) // Adjusted for GLSL
#define SMAA_LINEAR_SAMPLER LinearSampler
#define SMAA_POINT_SAMPLER PointSampler
#ifdef SMAA_PRESET_ULTRA
    #define SMAA_TEXEL_SIZE_X (1.0 / INPUT_WIDTH)
    #define SMAA_TEXEL_SIZE_Y (1.0 / INPUT_HEIGHT)
#else
    #define SMAA_TEXEL_SIZE_X (1.0 / ceil(SMAA_RT_METRICS.x))
    #define SMAA_TEXEL_SIZE_Y (1.0 / ceil(SMAA_RT_METRICS.y))
#endif
#include "SMAA.glsl"

//!PASS 1
//!DESC Luma Edge Detection
//!STYLE PS
//!IN INPUT
//!OUT edgesTex

vec2 Pass1(vec2 pos) {
    return SMAALumaEdgeDetectionPS(pos, INPUT);
}

//!PASS 2
//!DESC Blending Weight Calculation
//!STYLE PS
//!IN edgesTex, areaTex, searchTex
//!OUT blendTex

vec4 Pass2(vec2 pos) {
    return SMAABlendingWeightCalculationPS(pos, edgesTex, areaTex, searchTex, 0);
}

//!PASS 3
//!DESC Neighborhood Blending
//!STYLE PS
//!IN INPUT, blendTex

vec4 Pass3(vec2 pos) {
    return SMAANeighborhoodBlendingPS(pos, INPUT, blendTex);
}