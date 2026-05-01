uniform sampler2D CountryColorTex;
uniform sampler2D DistanceFieldTex;

uniform float GradientPower;
uniform float EdgeSoftness;
uniform vec3 InnerColorMul;
uniform vec3 OuterColorMul;

in vec2 uv;
out vec4 fragColor;

void main()
{
    vec4 baseColor = texture(CountryColorTex, uv);
    float dist = texture(DistanceFieldTex, uv).r;

    float gradient = pow(dist, GradientPower);

    vec3 innerColor = baseColor.rgb * InnerColorMul;
    vec3 outerColor = baseColor.rgb * OuterColorMul;

    vec3 finalColor = mix(outerColor, innerColor, gradient);

    float edgeFade = smoothstep(0.0, EdgeSoftness, dist);

    fragColor = vec4(finalColor, baseColor.a * edgeFade);
}