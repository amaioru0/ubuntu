# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set a non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-dev \
    libssl-dev \
    libffi-dev \
    ca-certificates \
    gnupg \
    lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install NVIDIA driver prerequisites (for GPU support)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-driver-470 \
    nvidia-container-toolkit && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install CUDA and cuDNN for GPU support
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && apt-get install -y --no-install-recommends \
    cuda \
    libcudnn8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN python3 -m pip install --upgrade pip
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set working directory
WORKDIR /workspace

# Copy the application code (optional)
# COPY . /workspace/

# Ensure NVIDIA tools and CUDA are available
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Expose a port if necessary (e.g., Jupyter Notebook)
EXPOSE 8888

# Default command (can be overridden)
CMD ["bash"]
