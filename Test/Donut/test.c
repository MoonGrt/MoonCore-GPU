#include <stdio.h>
#include <string.h>
#include <math.h>
#include <unistd.h>

#define screen_width 50
#define screen_height 22

// spacing constants
const float theta_spacing = 0.07;
const float phi_spacing   = 0.02;

const float R1 = 1;
const float R2 = 2;
const float K2 = 5;

const float pi = 3.14159;

// Calculate K1 based on screen size
const float K1 = screen_width * K2 * 3 / (8 * (R1 + R2));

void render_frame(float A, float B) {
    float cosA = cos(A), sinA = sin(A);
    float cosB = cos(B), sinB = sin(B);

    char output[screen_width * screen_height];
    float zbuffer[screen_width * screen_height];

    // clear buffers
    memset(zbuffer, 0, sizeof(zbuffer));
    memset(output, ' ', sizeof(output));

    for (float theta = 0; theta < 2 * pi; theta += theta_spacing) {
        float costheta = cos(theta), sintheta = sin(theta);

        for (float phi = 0; phi < 2 * pi; phi += phi_spacing) {
            float cosphi = cos(phi), sinphi = sin(phi);

            float circlex = R2 + R1 * costheta;
            float circley = R1 * sintheta;

            // 3D coordinates
            float x = circlex * (cosB * cosphi + sinA * sinB * sinphi)
                    - circley * cosA * sinB;
            float y = circlex * (sinB * cosphi - sinA * cosB * sinphi)
                    + circley * cosA * cosB;
            float z = K2 + cosA * circlex * sinphi + circley * sinA;
            float ooz = 1 / z;

            int xp = (int)(screen_width / 2 + K1 * ooz * x);
            int yp = (int)(screen_height / 2 - K1 * ooz * y * 0.5);

            float L = cosphi * costheta * sinB - cosA * costheta * sinphi
                    - sinA * sintheta + cosB * (cosA * sintheta - costheta * sinA * sinphi);

            if (L > 0) {
                int idx = xp + yp * screen_width;
                if (idx >= 0 && idx < screen_width * screen_height) {
                    if (ooz > zbuffer[idx]) {
                        zbuffer[idx] = ooz;
                        int luminance_index = (int)(L * 8);
                        output[idx] = ".,-~:;=!*#$@"[luminance_index > 11 ? 11 : luminance_index];
                    }
                }
            }
        }
    }

    // Move cursor to home position and print
    printf("\x1b[H");
    for (int j = 0; j < screen_height; j++) {
        for (int i = 0; i < screen_width; i++) {
            putchar(output[i + j * screen_width]);
        }
        putchar('\n');
    }
}

int main() {
    float A = 0, B = 0;
    // // render once
    // render_frame(A, B);
    // A += 0.07;
    // B += 0.03;
    // usleep(30000);  // ~30 FPS
    // render continuous
    while (1) {
        render_frame(A, B);
        A += 0.07;
        B += 0.03;
        usleep(30000);  // ~30 FPS
    }
    return 0;
}
