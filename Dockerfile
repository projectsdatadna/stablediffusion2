FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3-pip \
    git \
    wget \
    curl \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Set Python3.10 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN update-alternatives --config python3

# Create and activate virtual environment
WORKDIR /app
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Clone Stable Diffusion 2 repository
RUN git clone https://github.com/projectsdatadna/stablediffusion2.git /app/stablediffusion2
WORKDIR /app/stablediffusion2

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose necessary ports
EXPOSE 7860

# Command to run Stable Diffusion
CMD ["python", "scripts/txt2img.py", "--prompt", "a fantasy landscape", "--plms"]
