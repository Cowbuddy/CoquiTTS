# Use Python 3.9.19 as the base image
FROM python:3.9.19-slim

# Set the working directory
WORKDIR /app

# Install system dependencies including ffmpeg and lame
RUN apt-get update && \
    apt-get install -y ffmpeg lame git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install Python dependencies
COPY requirement.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5002

# Run the application
CMD ["tts-server", "--model_name", "tts_models/en/vctk/vits"]
