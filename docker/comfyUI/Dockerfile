# 阶段 1：使用官方最新 ROCm 10.1 基础镜像
FROM rocm/dev-ubuntu-24.04:10.1-complete

# 设置环境变量，防止安装过程中的交互弹窗
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 关键：针对 Strix Halo (Ryzen AI Max+ 395) 的 GPU 架构变量
ENV HSA_OVERRIDE_GFX_VERSION=11.5.1
ENV HIP_VISIBLE_DEVICES=0

WORKDIR /app

# 安装基础依赖与 Python 3.12 工具
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    python3-venv \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 【修正 1】克隆最新的 ComfyUI 官方迁移仓库
RUN git clone https://github.com/Comfy-Org/ComfyUI.git .

# 【修正 2】使用正确的 PyTorch 官方 ROCm 源下载路径
# 提示：由于 ROCm 10.1 属于最新前沿演进，推荐采用配套的 rocm 测试/预览级 URL 进行拉取
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir torch torchvision torchaudio \
    --index-url https://pytorch.org && \
    pip3 install --no-cache-dir -r requirements.txt

# 暴露 ComfyUI 默认端口
EXPOSE 8188

# 启动命令：利用 --highvram 选项完全压榨 128G 统一内存
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--highvram"]
