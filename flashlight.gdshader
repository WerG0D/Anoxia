shader_type canvas_item;

uniform float radius : hint_range(50.0, 2000.0) = 400.0;  // Distância do feixe
uniform float angle : hint_range(10.0, 180.0) = 60.0;     // Abertura do cone (graus)
uniform float softness : hint_range(0.0, 1.0) = 0.5;      // Suavização das bordas
uniform vec4 light_color : source_color = vec4(1.0, 1.0, 0.8, 1.0); // Cor da luz

void fragment() {
    // Coordenadas normalizadas em relação ao centro
    vec2 uv = (FRAGCOORD.xy - SCREEN_UV * SCREEN_PIXEL_SIZE.xy * 0.5) / radius;
    float dist = length(uv);

    // Calcula direção em graus (-180 a 180)
    float dir = degrees(atan(uv.y, uv.x));

    // Cone: apenas dentro do ângulo
    float half_angle = angle * 0.5;
    float cone_mask = smoothstep(half_angle + softness * 50.0, half_angle, abs(dir));

    // Atenuação por distância
    float attenuation = 1.0 - smoothstep(0.8, 1.0, dist);

    // Resultado final
    COLOR = light_color * attenuation * cone_mask;
}
