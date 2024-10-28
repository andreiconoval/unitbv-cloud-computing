#!/bin/bash

# Function to check if systemd is running
check_systemd() {
  if [ "$(ps -p 1 -o comm=)" == "systemd" ]; then
    return 0  # System is using systemd
  else
    return 1  # System is not using systemd
  fi
}

# Function to generate SSH host keys if they are missing
generate_ssh_host_keys() {
  echo "Checking for missing SSH host keys..."
  sudo ssh-keygen -A
  if [ $? -eq 0 ]; then
    echo "SSH host keys generated successfully."
  else
    echo "Failed to generate SSH host keys."
    exit 1
  fi
}

# Function to start and enable sshd with systemd
start_and_enable_sshd_systemd() {
  echo "Starting and enabling sshd using systemd..."

  # Enable sshd service
  sudo systemctl enable sshd
  if [ $? -eq 0 ]; then
    echo "sshd service enabled successfully."
  else
    echo "Failed to enable sshd service."
  fi

  # Start sshd service
  sudo systemctl start sshd
  if [ $? -eq 0 ]; then
    echo "sshd service started successfully using systemd."
  else
    echo "Failed to start sshd using systemd."
  fi
}

# Function to start sshd without systemd
start_sshd_non_systemd() {
  # Check if the service command exists
  if command -v service >/dev/null 2>&1; then
    echo "Detected service command, starting sshd using service..."
    sudo service ssh start
  elif [ -f "/usr/sbin/sshd" ]; then
    echo "System not using systemd, starting sshd manually..."
    generate_ssh_host_keys  # Ensure host keys are available
    /usr/sbin/sshd
    if [ $? -eq 0 ]; then
      echo "sshd service started successfully."
    else
      echo "Failed to start sshd."
    fi
  else
    echo "sshd command not found. Ensure OpenSSH server is installed."
  fi
}

# Main script logic
if check_systemd; then
  generate_ssh_host_keys  # Ensure host keys are available
  start_and_enable_sshd_systemd
else
  start_sshd_non_systemd
fi
