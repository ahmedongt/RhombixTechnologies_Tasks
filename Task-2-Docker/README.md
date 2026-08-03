# Task 2: Containerization with Docker

## Overview
Demonstrating Docker application packaging, image builds, container lifecycle management, and port binding.

## Execution Steps
- Built custom Python web app Docker image: `docker build -t rhombix-docker-app .`
- Verified local container execution: `docker run -d -p 8000:8000 --name rhombix-app rhombix-docker-app`
- Tested port mapping via `http://localhost:8000`