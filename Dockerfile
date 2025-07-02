# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Install pip dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install uv package manager (safe curl method)
RUN apt-get update && apt-get install -y curl build-essential && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ln -s /root/.local/bin/uv /usr/local/bin/uv

# Expose port for Flask web UI
EXPOSE 5000

# Environment variables for Dremio URI and PAT will be passed in via docker-compose
ENV DREMIO_URI=""
ENV DREMIO_PAT=""

# Entry point
CMD bash -c "/root/.local/bin/uv run --directory /app/dremio-mcp dremio-mcp-server config create dremioai --uri \$DREMIO_URI --pat \$DREMIO_PAT && python webui.py"
