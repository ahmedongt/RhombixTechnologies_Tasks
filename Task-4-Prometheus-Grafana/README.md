# Task 4: Monitoring & Observability with Prometheus & Grafana

## Overview
Infrastructure observability setup using Prometheus, Grafana, and Node Exporter containerized via Docker Compose.

## Architecture & Components
- **Prometheus**: Scrapes and stores time-series system metrics on port `9090`.
- **Node Exporter**: Exposes host hardware metrics (CPU, RAM, Disk, Network) on port `9100`.
- **Grafana**: Visualizes metrics on port `3000` using provisioned Node Exporter dashboards.
- **Docker Compose**: Orchestrates multi-container setup.
