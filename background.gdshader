shader_type canvas_item;

// 這裡可以手動調整「去背強度」
uniform float threshold : hint_range(0.0, 1.0) = 0.2; 
uniform float softness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 計算像素的亮度 (灰階值)
    float brightness = (tex_color.r + tex_color.g + tex_color.b) / 3.0;
    
    // 根據亮度決定透明度
    // 如果亮度低於 threshold，就會變透明
    // softness 則決定了邊緣是否平滑
    float alpha = smoothstep(threshold, threshold + softness, brightness);
    
    // 將計算出的透明度應用到圖片上
    tex_color.a *= alpha;
    
    COLOR = tex_color;
}