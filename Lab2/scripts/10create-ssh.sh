#!/bin/bash

# Check if the .ssh directory exists, create it if it doesn't
if [ ! -d "$HOME/.ssh" ]; then
    echo "Creating .ssh directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Generate an RSA key pair without a passphrase
echo "Generating RSA key pair..."
ssh-keygen -t rsa -P '' -f "$HOME/.ssh/id_rsa"

# Append the public key to the authorized_keys file
echo "Adding the public key to authorized_keys..."
cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"

# Set the correct permissions for the authorized_keys file
echo "Setting permissions for authorized_keys..."
chmod 600 "$HOME/.ssh/authorized_keys"

echo "SSH key setup complete."