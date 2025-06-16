def generate_color_bar_data_rgb888(hs, vs):
    """按Y方向（纵向）生成RGB888彩条图像，每像素一个RGB元组"""
    colors = [
        (255, 0, 0),     # 红
        (0, 255, 0),     # 绿
        (0, 0, 255),     # 蓝
        (255, 255, 0),   # 黄
        (255, 0, 255),   # 品红
        (0, 255, 255),   # 青
        (255, 255, 255), # 白
        (128, 128, 128), # 灰
    ]
    num_colors = len(colors)
    bar_width = max(hs // num_colors, 1)
    bar_height = max(vs // num_colors, 1)

    data = []
    for y in range(vs):
        # color_idx = min(y // bar_height, num_colors - 1)
        # r, g, b = colors[color_idx]
        for x in range(hs):
            color_idx = min(x // bar_width, num_colors - 1)
            r, g, b = colors[color_idx]
            data.append((r, g, b))
    return data


def write_pixel_hex_files(rgb_data, filename_base):
    """写入4个HEX文件：全部像素、红分量、绿分量、蓝分量"""
    with open(f"{filename_base}.hex", 'w') as f, \
         open(f"{filename_base}.mi", 'w') as fmi, \
         open(f"{filename_base}_ram0.hex", 'w') as f_r, \
         open(f"{filename_base}_ram1.hex", 'w') as f_g, \
         open(f"{filename_base}_ram2.hex", 'w') as f_b:

        fmi.write(f"#File_format=Hex\n")
        fmi.write(f"#Address_depth={len(rgb_data)}\n")
        fmi.write(f"#Data_width=24\n")

        # 全部像素
        for r, g, b in rgb_data:
            f.write(f"{r:02x}{g:02x}{b:02x}\n")
            fmi.write(f"{r:02x}{g:02x}{b:02x}\n")
            f_r.write(f"{r:02x}\n")
            f_g.write(f"{g:02x}\n")
            f_b.write(f"{b:02x}\n")


if __name__ == "__main__":
    hs = 240  # 图像宽度（像素）
    vs = 135  # 图像高度（像素）
    base_filename = "init"

    rgb_data = generate_color_bar_data_rgb888(hs, vs)
    write_pixel_hex_files(rgb_data, base_filename)
    print(f"生成完成：{base_filename}.hex、{base_filename}.mi、{base_filename}_ram0.hex、{base_filename}_ram1.hex、{base_filename}_ram2.hex")
    print(f"总像素数：{len(rgb_data)}")
