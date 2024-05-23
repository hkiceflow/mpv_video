#version 330 core

uniform sampler2D inputTexture;
uniform int ClarityRadius;
uniform float ClarityOffset;
uniform int ClarityBlendMode;
uniform int ClarityBlendIfDark;
uniform int ClarityBlendIfLight;
uniform bool ClarityViewBlendIfMask;
uniform float ClarityStrength;
uniform float ClarityDarkIntensity;
uniform float ClarityLightIntensity;
uniform bool ClarityViewMask;

out vec4 FragColor;

void main()
{
    const vec2 resolution = vec2(640.0, 360.0); // Assuming the video resolution is 640x360
    vec2 uv = gl_FragCoord.xy / resolution;
    
    if (ClarityRadius >= 0 && ClarityRadius <= 4)
    {
        float color = texture(inputTexture, uv).r;
        
        float kernelRadius = float(ClarityRadius) + 1.0;
        float kernelsize = 2.0 * kernelRadius + 1.0;
        float totalWeight = 0.0;
        float offset[] = float[kernelsize]{-kernelRadius, -kernelRadius + 1.0, ..., kernelRadius - 1.0, kernelRadius};
        float weights[] = float[kernelsize];

        switch (ClarityRadius)
        {
            case 0:
                weights = float[kernelsize]{0.39894, 0.2959599993, 0.0045656525, 0.0};
                break;
            case 1:
                weights = float[kernelsize]{0.13298, 0.23227575, 0.1353261595, 0.0511557427, 0.01253922};
                break;
            case 2:
                weights = float[kernelsize]{0.06649, 0.1284697563, 0.111918249, 0.0873132676, 0.0610011113, 0.0381655709, 0.0213835661, 0.0107290241, 0.0048206869, 0.0019396469};
                break;
            case 3:
                weights = float[kernelsize]{0.0443266667, 0.0872994708, 0.0820892038, 0.0734818355, 0.0626171681, 0.0507956191, 0.0392263968, 0.0288369812, 0.0201808877, 0.0134446557, 0.0085266392, 0.0051478359, 0.0029586248, 0.0016187257, 0.0008430913};
                break;
            case 4:
                weights = float[kernelsize]{0.033245, 0.0659162217, 0.0636705814, 0.0598194658, 0.0546642566, 0.0485871646, 0.0420045997, 0.0353207015, 0.0288880982, 0.0229808311, 0.0177815511, 0.013382297, 0.0097960001, 0.0069746748, 0.0048301008, 0.0032534598, 0.0021315311, 0.0013582974};
                break;
        }

        vec4 sum = vec4(0.0);
        for (int i = 0; i < kernelRadius; i++)
        {
            sum += texture(inputTexture, uv + offset[i] * ClarityOffset) * weights[i];
            sum += texture(inputTexture, uv - offset[i] * ClarityOffset) * weights[i + kernelRadius];
            totalWeight += 2.0 * weights[i];
        }

        color = sum.r / totalWeight;
    }

    float sharpness = clamp((uv.x + uv.y) * 0.5, 0.0, 1.0);
    sharpen(sharpness, color, ClarityStrength, ClarityDarkIntensity, ClarityLightIntensity);

    blendIf(ClarityBlendIfDark, ClarityBlendIfLight, ClarityViewBlendIfMask, ClarityBlendMode, sharpness, color);

    if (ClarityViewMask)
    {
        FragColor = vec4(vec3(sharpness), 1.0);
    }
    else
    {
        applyBlendMode(ClarityBlendMode, color);
        FragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
    }
}

void sharpen(float sharpness, inout float r, float strength, float darkIntensity, float lightIntensity)
{
    float sharp = (sharpness + r) * 0.5;
    float sharpMin = smoothstep(0.0, 1.0, sharp);
    float sharpMax = sharpMin;
    sharpMin = mix(0.0, sharpMin, darkIntensity);
    sharpMax = mix(sharp, sharpMax, lightIntensity);
    sharp = mix(sharpMin, sharpMax, step(0.5, sharp));
    r = mix(sharpness, sharp, strength);
}

void blendIf(int thresholdDark, int thresholdLight, bool viewBlendIfMask, int mode, float& color, out float result)
{
    if (thresholdDark > 0 || thresholdLight < 255 || viewBlendIfMask)
    {
        float tD = max(0.0, min(1.0, (thresholdDark / 255.0)));
        float tL = max(0.0, min(1.0, ((255.0 - thresholdLight) / 255.0)));
        float mixValue = dot(vec3(color), vec3(0.333333));
        float mask = 1.0;

        if (thresholdDark > 0)
        {
            mask = mix(0.0, 1.0, smoothstep(tD - (tD * 0.2), tD + (tD * 0.2), mixValue));
        }

        if (thresholdLight < 255)
        {
            mask = mix(mask, 0.0, smoothstep(tL - (tL * 0.2), tL + (tL * 0.2), mixValue));
        }

        result = mix(color, mask, mask);

        if (viewBlendIfMask)
        {
            result = mask;
            color = mask;
        }
    }
    else
    {
        result = color;
    }
}

void applyBlendMode(int mode, inout float rgba[])
{
    switch (mode)
    {
        case 0:
            softLight(rgba);
            break;
        case 1:
            overlay(rgba);
            break;
        case 2:
            hardLight(rgba);
            break;
        case 3:
            multiply(rgba);
            break;
        case 4:
            vividLight(rgba);
            break;
        case 5:
            linearLight(rgba);
            break;
        case 6:
            addition(rgba);
            break;
    }
}

void softLight(inout float rgb[])
{
    float L = dot(rgb, vec3(0.32786885, 0.655737705, 0.0163934436));
    rgb = mix(2 * L * rgb + L * L * (1.0 - 2 * rgb), 2 * L * (1.0 - rgb) + pow(L, 0.5) * (2 * rgb - 1.0), step(0.49, rgb));
}

void overlay(inout float rgb[])
{
    rgb = mix(2 * rgb, 1.0 - 2 * (1.0 - rgb) * (1.0 - rgb), step(0.5, rgb));
}

void hardLight(inout float rgb[])
{
    rgb = mix(2 * rgb, 1.0 - 2 * (1.0 - rgb) * (1.0 - rgb), step(0.5, rgb));
}

void multiply(inout float rgb[])
{
    rgb = saturate(2 * rgb * rgb);
}

void vividLight(inout float rgb[])
{
    rgb = mix(2 * rgb, rgb / (2 * (1 - rgb)), step(0.5, rgb));
}

void linearLight(inout float rgb[])
{
    rgb = rgb + 2.0 * rgb - 1.0;
}

void addition(inout float rgb[])
{
    rgb = clamp(rgb + (rgb - 0.5), 0.0, 1.0);
}