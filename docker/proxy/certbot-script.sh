#!/bin/sh

# Function to print debug messages
debug() {
  if [ "$DEBUG" = "true" ]; then
    echo "$1"
  fi
}

# Print a message to indicate the script is running
echo "Script is running..."

# ##########################################################
#                    Basic Configuration                   #
# ##########################################################

# The prefix used for SAN (Subject Alternative Name) entries
prefix="node"

# The main domain for which the certificates will be issued
domain=""

# The number of SAN entries to include in the certificate.
# LetsEncrypt limits 100 SAN entries per certificate.
number_of_sans=50

# The webroot path used by Certbot for the webroot plugin challenge
webroot_path="/var/www/html"

# The email address used for Certbot registration and recovery contact
email=""

# The path where the live certificates are stored
cert_path="/etc/letsencrypt/live"

# Debugging: Print initial variables if DEBUG is true
debug "prefix: $prefix"
debug "domain: $domain"
debug "number_of_sans: $number_of_sans"
debug "webroot_path: $webroot_path"
debug "email: $email"
debug "cert_path: $cert_path"

# Check if the certificate folder is empty
if [ -z "$(ls -A $cert_path)" ]; then
  echo "Certificate folder is empty. Requesting new certificates..."

  # Build the certbot command
  certbot_command="certbot certonly --webroot --webroot-path $webroot_path -d $domain --expand --non-interactive --agree-tos --email $email"

  # Loop to add all SANs
  i=1
  while [ $i -le $number_of_sans ]; do
    padded_index=$(printf "%02d" $i)
    san="${prefix}-${padded_index}.${domain}"

    # Add SAN to the certbot command
    certbot_command="$certbot_command -d $san"

    i=$((i + 1))
  done

  # Debugging: Print the final command if DEBUG is true
  debug "Running command: $certbot_command"

  # Execute the certbot command
  $certbot_command
else
  echo "Certificate folder is not empty. Skipping certificate request."
fi

# Loop to renew certificates every 12 hours
while true; do
  echo "Attempting to renew certificates..."
  certbot renew --quiet

  # Sleep for 12 hours
  sleep 43200
done

# End of Script
echo "Script completed."