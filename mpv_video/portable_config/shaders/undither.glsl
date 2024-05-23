#version 330 core

uniform int iPS;
uniform int iRadius;
uniform bool bKeepHue;
uniform float fHueMaxDistance;
uniform float fSatMaxDistance;
uniform float fLumMaxDistance;
uniform float hueImportance;
uniform float satImportance;
uniform float lumImportance;

in vec2 vUV;
out vec4 oColor;

vec3 RGBtoHSL(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec3 p = c.gzx * (K.wzx + K.www) + c.rbx * K.yyw;
    vec3 q = c.ggx * (K.xxw + K.zzz) - (p.x + p.y) * K.xyz;
    float d = q.x * q.w - q.y * q.z;
    return vec3(q.y + (q.x - q.y) * (d >= 0.0 ? 1.0 : -1.0) / (2.0 * sqrt(d * d + 0.0001)), p + q);
}

float hueDistance(vec3 hsl1, vec3 hsl2)
{
    float h1 = hsl1.x * 6.0;
    float h2 = hsl2.x * 6.0;
    float h = min(abs(h1 - h2), 2.0 - abs(h1 - h2));
    return h + abs(hsl1.yz - hsl2.yz);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = texture(iChannel0, uv).rgb;
    vec3 ncol = col;
    vec3 hsl = RGBtoHSL(ncol);

    for (int x = -iRadius; x <= iRadius; ++x)
    {
        for (int y = -iRadius; y <= iRadius; ++y)
        {
            vec2 offset = vec2(float(x), float(y)) / iResolution.xy;
            vec3 sampleCol = texture(iChannel0, uv + offset).rgb;
            vec3 sampleHSL = RGBtoHSL(sampleCol);

            float hueDiff = abs(hsl.x - sampleHSL.x) * hueImportance;
            float satDiff = abs(hsl.y - sampleHSL.y) * satImportance;
            float lumDiff = abs(hsl.z - sampleHSL.z) * lumImportance;
            float distSum = hueDiff + satDiff + lumDiff;

            if (distSum <= fHueMaxDistance * hueImportance + fSatMaxDistance * satImportance + fLumMaxDistance * lumImportance)
            {
                float weight = smoothstep(distSum, 0.0, 1.0);
                ncol = mix(ncol, sampleCol, weight);
            }
        }
    }

    if (bKeepHue)
    {
        vec3 keepHueHSL = RGBtoHSL(col);
        ncol.x = keepHueHSL.x;
        ncol = HSLtoRGB(keepHueHSL.xyz) * pow(ncol.yzw, vec3(1.0 / iPS));
    }
    else
    {
        ncol = pow(ncol.yzw, vec3(1.0 / iPS));
    }

    oColor = vec4(ncol, 1.0);
}

void main()
{
    mainImage(oColor, gl_FragCoord.xy);
}