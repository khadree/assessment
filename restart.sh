#!/bin/bash

# Set the CPU usage threshold
CPU_THRESHOLD=80
SERVICE_NAME="laravel-backend"
# Function to check CPU usage
check_cpu_usage() {
  # Get current CPU usage
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')

  # Check if CPU usage exceeds threshold
  if [[ $(echo "$cpu_usage > $CPU_THRESHOLD" | bc) -eq 1 ]]; then
    echo "CPU usage exceeds $CPU_THRESHOLD%"
    return 0
  fi

  return 1
}

# Function to restart the Laravel service
restart_laravel() {
  echo "Restarting Laravel service..."
 
  sudo systemctl restart $SERVICE_NAME
}

while true; do
  if ! check_cpu_usage; then
    restart_laravel
  fi
  sleep 60 # Check CPU usage every 60 seconds
done
