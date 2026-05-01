// country_gradient.fx

Texture2D CountryColorTex : register(t0);   // 国家颜色
Texture2D DistanceFieldTex : register(t1);  // 距离场（0边缘 → 1中心）

SamplerState LinearSampler : register(s0);

float GradientPower;     // 渐变强度（1~3）
float EdgeSoftness;      // 边缘过渡（0~0.3）
float DarkStrength;      // 中心加深程度

struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float2 UV  : TEXCOORD0;
};

float4 PS_Main(VS_OUTPUT input) : SV_Target
{
    float2 uv = input.UV;

    // 原始国家颜色
    float4 baseColor = CountryColorTex.Sample(LinearSampler, uv);

    // 距离值（0=边缘，1=中心）
    float dist = DistanceFieldTex.Sample(LinearSampler, uv).r;

    // 调整曲线（让中心更集中变深）
    float gradient = pow(dist, GradientPower);

    // 由浅 → 深（中心更暗）
    float3 darkColor = baseColor.rgb * (1.0 - DarkStrength);

    float3 finalColor = lerp(baseColor.rgb, darkColor, gradient);

    // 边缘柔化（避免硬边）
    float edgeFade = smoothstep(0.0, EdgeSoftness, dist);

    return float4(finalColor, baseColor.a * edgeFade);
}