#!/bin/bash

# Function to generate a secure random password
generate_password() {
    local length=$1
    # Define the character set: letters, numbers, underscores, equal signs, and hyphens
    local charset="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_=-"

    # Use /dev/urandom to generate secure random bytes, then filter using the charset
    password=$(LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$length")
    echo "$password"
}

# Default password length if not provided
DEFAULT_LENGTH=16

# Get the length from the user, or use the default
read -p "Enter password length (default $DEFAULT_LENGTH): " input_length
length=${input_length:-$DEFAULT_LENGTH}

# Generate the password
secure_password=$(generate_password "$length")

# Display the password
echo "Generated Password: $secure_password"

# Copy to clipboard
if command -v xclip &> /dev/null; then
    echo -n "$secure_password" | xclip -selection clipboard
    echo "Password copied to clipboard (using xclip)."
elif command -v pbcopy &> /dev/null; then
    echo -n "$secure_password" | pbcopy
    echo "Password copied to clipboard (using pbcopy)."
elif command -v xsel &> /dev/null; then
    echo -n "$secure_password" | xsel --clipboard --input
    echo "Password copied to clipboard (using xsel)."
else
    echo "Clipboard utility not found. Install xclip, xsel, or use pbcopy (macOS)."
fi
