# Use Python 3.9.19 as the base image for the build stage
FROM python:3.9.19-slim

# Set the working directory
WORKDIR /app

# Install system dependencies and Rust
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    lame \
    git \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
    espeak-ng && \
    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env && \
    rustc --version && \
    cargo --version && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install Python dependencies
COPY requirement.txt requirements.txt
RUN . $HOME/.cargo/env && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir SudachiPy==0.6.7

# Copy the application code
COPY . .

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"

# Not sure tbh
RUN pip install -e .

# Expose the port the app runs on
EXPOSE 5002

# Run the application
CMD ["tts-server", "--model_name", "tts_models/en/vctk/vits"]