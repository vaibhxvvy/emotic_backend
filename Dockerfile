# Use a baseline Python image
FROM python:3.11-slim

# Install system dependencies needed for audio, building wheels, and common libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    wget \
    libsndfile1 \
    libsndfile1-dev \
    portaudio19-dev \
    libasound2-dev \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install first to leverage Docker cache
COPY requirements.txt ./
RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt || (echo "pip install failed; retrying with --use-deprecated=legacy-resolver" && pip install --no-cache-dir -r requirements.txt --use-deprecated=legacy-resolver)

# Copy the rest of the app
COPY . .

# Create a non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser && chown -R appuser:appgroup /app
USER appuser

ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Use gunicorn to run the app. Replace app:app if your app module/name is different.
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
