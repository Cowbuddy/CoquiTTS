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

# Set up SSH for GitHub (assuming you're using a private repository)
# RUN mkdir -p -m 0700 ~/.ssh && \
#    ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone the repository
RUN git clone https://github.com/Cowbuddy/CoquiTTS.git

# Copy and install dependencies
RUN . $HOME/.cargo/env && \
    pip install --upgrade pip

RUN RUN pip install -e .

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"

# Expose the port the app runs on
EXPOSE 5002

# Run the application
CMD ["tts-server", "--model_name", "tts_models/en/vctk/vits"]
