#include "COMMON.h"
#include "pic.h"

#include <math.h>

// LCD参数
#define LCD_WIDTH 800
#define LCD_HEIGHT 480
#define BYTES_PIXEL 2

//==================== 渲染参数 ====================//
#define DONUT_W      250
#define DONUT_H      250
#define THETA_STEP   0.05f
#define PHI_STEP     0.02f

#define R1  1.0f
#define R2  2.0f
#define K2  5.0f
#define PI  3.14159f
#define K1  (DONUT_W * K2 * 3 / (8 * (R1 + R2)))

//==================== 工具函数 ====================//
static inline uint16_t gray_to_rgb565(uint8_t gray)
{
    uint8_t r = gray >> 3;
    uint8_t g = gray >> 2;
    uint8_t b = gray >> 3;
    return (r << 11) | (g << 5) | b;
}

//==================== 渲染核心 ====================//
void render_frame_LCD(float A, float B)
{
    float cosA = cos(A), sinA = sin(A);
    float cosB = cos(B), sinB = sin(B);

    float zbuffer[DONUT_W * DONUT_H];
    uint8_t brightness[DONUT_W * DONUT_H];

    // 清空缓存
    memset(zbuffer, 0, sizeof(zbuffer));
    memset(brightness, 0, sizeof(brightness));

    // 主渲染循环
    for (float theta = 0; theta < 2 * PI; theta += THETA_STEP) {
        float costheta = cos(theta), sintheta = sin(theta);
        for (float phi = 0; phi < 2 * PI; phi += PHI_STEP) {
            float cosphi = cos(phi), sinphi = sin(phi);
            float circlex = R2 + R1 * costheta;
            float circley = R1 * sintheta;

            float x = circlex * (cosB * cosphi + sinA * sinB * sinphi) - circley * cosA * sinB;
            float y = circlex * (sinB * cosphi - sinA * cosB * sinphi) + circley * cosA * cosB;
            float z = K2 + cosA * circlex * sinphi + circley * sinA;
            float ooz = 1.0f / z;

            int xp = (int)(DONUT_W / 2 + K1 * ooz * x);
            int yp = (int)(DONUT_H / 2 - K1 * ooz * y * 0.5);

            float L = cosphi * costheta * sinB - cosA * costheta * sinphi
                    - sinA * sintheta + cosB * (cosA * sintheta - costheta * sinA * sinphi);

            if (L > 0 && xp >= 0 && yp >= 0 && xp < DONUT_W && yp < DONUT_H) {
                int idx = xp + yp * DONUT_W;
                if (ooz > zbuffer[idx]) {
                    zbuffer[idx] = ooz;
                    brightness[idx] = (uint8_t)(L * 255);
                }
            }
        }
    }

    // 将亮度写入LCD缓冲
    uint8_t *frame = (uint8_t*)FrameBuffer_Addr;
    for (int y = 0; y < DONUT_H; y++) {
        for (int x = 0; x < DONUT_W; x++) {
        	uint16_t color = gray_to_rgb565(brightness[x + y * DONUT_W]);
            int lcd_x = (LCD_WIDTH - DONUT_W) / 2 + x;
            int lcd_y = (LCD_HEIGHT - DONUT_H) / 2 + y;
            int pos = BYTES_PIXEL * (lcd_x + LCD_WIDTH * lcd_y);
            frame[pos] = color >> 8;
            frame[pos + 1] = color & 0xFF;
        }
    }

    LCD_Refresh();
}

// RGB565 颜色宏
#define RGB565(r, g, b)  (((r & 0x1F) << 11) | ((g & 0x3F) << 5) | (b & 0x1F))
void LCD_ShowColorBars(void)
{
    uint16_t colors[8] = {
        RGB565(31, 0, 0),    // 红
        RGB565(0, 63, 0),    // 绿
        RGB565(0, 0, 31),    // 蓝
        RGB565(31, 63, 0),   // 黄
        RGB565(0, 63, 31),   // 青
        RGB565(31, 0, 31),   // 品红
        RGB565(31, 63, 31),  // 白
        RGB565(0, 0, 0)      // 黑
    };

    uint8_t *frame = (uint8_t*)FrameBuffer_Addr;
    for (int y = 0; y < LCD_HEIGHT; y++) {
        for (int x = 0; x < LCD_WIDTH; x++) {
            int pos = BYTES_PIXEL * (x + LCD_WIDTH * y);
            frame[pos]     = colors[(x / (LCD_WIDTH / 8)) % 8] >> 8;    // 高字节
            frame[pos + 1] = colors[(x / (LCD_WIDTH / 8)) % 8] & 0xFF;  // 低字节
        }
    }

    // 更新LCD显示
    LCD_Refresh();
}

int main(void)
{
	LCD_Init();
	xil_printf("LCD_Init\r\n");

//	LCD_ShowColorBars();
//	xil_printf("LCD_ShowColorBars\r\n");
//	LCD_DisplayPic(0,0,gImage_pic);
//	xil_printf("LCD_DisplayPic\r\n");

    float A = 0, B = 0;
    while (1) {
        render_frame_LCD(A, B);
        A += 0.07;
        B += 0.03;
//        usleep(10000);
//        xil_printf("Render once\r\n");
    }
    return 0;
}
