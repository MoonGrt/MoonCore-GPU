
## 🚩 目标概括：

* 使用 RISC-V CPU 控制一个 GPU。
* GPU 执行一些并行图像/数据计算。
* 输出结果（如图像缓冲）显示在 OLED/LCD 屏幕上。
* 面向嵌入式系统，资源有限，不能依赖 CUDA 或 OpenCL。

---

## 🧭 第一阶段：GPU 模块目标定义

决定这个“GPU”的功能范围。从图形渲染型 GPU 开始，可以快速驱动 OLED 屏幕看到成果，后续可扩展为 GPGPU。

| 类型            | 描述                | 示例用途             |
| ------------- | ----------------- | ---------------- |
| **计算型 GPU**   | 面向并行数据处理，类似 GPGPU | 图像滤波、FFT、矩阵乘法等   |
| **图形渲染型 GPU** | 面向 2D 图像绘制、像素管线等  | 在 OLED 上绘制点、线、图形 |
| **混合型**       | 图形 + 并行计算         | 小型操作系统 GUI、多功能显示 |

---

## 🏗️ 第二阶段：系统结构设计（Block Diagram）

将系统结构设计为如下：

```
+------------+        +-------------+         +-----------------+
|  RISC-V CPU| <----> |   GPU Core  | ----->  | OLED Controller |
+------------+        +-------------+         +-----------------+
      |                      ↑
      |       Memory Bus     |
      +------> Frame Buffer <+
```

### 模块功能划分：

* **CPU**：运行程序，配置 GPU 寄存器，触发 GPU 执行。
* **GPU Core**：
  * 接收命令（如绘图指令）
  * 执行并行计算（可设计简单指令集）
  * 写入 Frame Buffer
* **Frame Buffer**：共享内存区域，存储图像像素
* **OLED 控制器**：周期性读取 frame buffer，驱动屏幕显示

---

## 🔧 第三阶段：从零构建 GPU 的基本模块

### 1. **设计 GPU ISA（小型指令集）**

定义一个 GPU 专用指令集，例如：

| 指令                  | 功能       |
| ------------------- | -------- |
| `SET_COLOR R, G, B` | 设置当前画笔颜色 |
| `DRAW_PIXEL X, Y`   | 绘制一个像素   |
| `CLEAR`             | 清除屏幕     |
| `FILL_RECT X,Y,W,H` | 画一个矩形    |
| `LOAD_DATA_PTR`     | 加载图像数据地址 |

✅ 实现为一个小型微指令 FSM 或 RISC 控制单元。

---

### 2. **支持并行（GPU 的精髓）**

你可以让 GPU 模块支持**多执行单元并发执行**，例如：

* 每个“GPU 核心”处理一小块图像区域。
* 指令由一个调度器广播，所有并行处理单元一起运行（SIMD）。

---

### 3. **Frame Buffer 设计**

* 用 **BRAM** 或 SRAM 模拟一块 128x64 或 256x64 的灰度 / RGB 位图缓存。
* 每个像素 1\~8 bit。
* GPU 写入，OLED 控制器周期性读取。

---

### 4. **OLED 显示接口**

* 多数 OLED（如 SSD1306）支持 I2C 或 SPI。
* 写一个硬件 SPI 控制器模块，周期性读取 frame buffer 数据并推送给 OLED。

---

## 💻 第四阶段：软件驱动编写（运行在 RISC-V）

CPU 将：

1. 初始化 OLED 显示控制器（通过内存映射 SPI）。
2. 写 GPU 控制寄存器（如命令、参数寄存器、frame buffer 地址）。
3. 发出 `start` 命令。
4. 等待 GPU 完成（通过中断或轮询）。
5. OLED 刷新显示。

可以用类似下面的 C 代码控制 GPU：

```c
#define GPU_CMD_REG    0x80001000
#define GPU_ARG1_REG   0x80001004
#define GPU_START_REG  0x80001008

void draw_pixel(int x, int y) {
    *(volatile int*)GPU_CMD_REG = 0x01; // DRAW_PIXEL
    *(volatile int*)GPU_ARG1_REG = (x << 8) | y;
    *(volatile int*)GPU_START_REG = 1;
}
```

---

## 🧪 第五阶段：验证与调试建议

* ✅ 从仿真环境开始（用 Verilator / ModelSim 仿真 GPU + Frame Buffer 写入行为）
* ✅ 实时将 Frame Buffer 内容以 VGA、HDMI 或 OLED SPI 输出显示
* ✅ 加入性能测试（像素绘制速率、并行核心吞吐）
