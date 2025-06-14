def generate_color_bar_data_rgb888(width, height):
    """生成RGB888彩条图像，每像素一个RGB元组"""
    # 彩条颜色列表（RGB888）
    colors = [
        (255, 0, 0),     # 红
        (0, 255, 0),     # 绿
        (0, 0, 255),     # 蓝
        (255, 255, 0),   # 黄
        (255, 0, 255),   # 品红
        (0, 255, 255),   # 青
        (255, 255, 255), # 白
        (0, 0, 0),       # 黑
    ]
    num_colors = len(colors)
    bar_width = max(width // num_colors, 1)

    data = []
    for y in range(height):
        for x in range(width):
            color_idx = min(x // bar_width, num_colors - 1)
            r, g, b = colors[color_idx]
            data.append((r, g, b))  # 一像素：一个RGB元组
    return data

def write_pixel_hex_file(rgb_data, filename):
    """写入每像素一行的RRGGBB格式HEX文件"""
    with open(filename, 'w') as f:
        for r, g, b in rgb_data:
            f.write(f"{r:02x}{g:02x}{b:02x}\n")


if __name__ == "__main__":
    width = 135   # 图像宽度（像素）
    height = 240  # 图像高度（像素）
    output_file = "init.hex"

    byte_data = generate_color_bar_data_rgb888(width, height)
    write_pixel_hex_file(byte_data, output_file)
    print(f"生成完成：{output_file} （总字节数：{len(byte_data)}）")
