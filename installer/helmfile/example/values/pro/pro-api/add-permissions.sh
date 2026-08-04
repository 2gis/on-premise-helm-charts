#!/bin/bash
#
# Скрипт для добавления разрешений из файла add-permissions.json для указного в параметре ID пользователя.

# Check if USER_ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <user_id>"
  exit 1
fi

# Define variables
USER_ID="$1"                          # User ID passed as a parameter
API_ENDPOINT="https://api.example.com" # Replace with the actual API endpoint
API_TOKEN="your_api_token"            # Replace with the actual API token
PERMISSIONS_FILE="add-permissions.json" # Permissions JSON file

# Check if the permissions JSON file exists
if [ ! -f "$PERMISSIONS_FILE" ]; then
  echo "Error: Permissions file $PERMISSIONS_FILE not found!"
  exit 1
fi

# Read the permissions JSON file and embed into complete JSON
complete_json=$(cat <<EOF
{
  "org_account_id": "$USER_ID",
  "user_id": "$USER_ID",
  "permissions": $(cat "$PERMISSIONS_FILE")
}
EOF
)

# Log the JSON structure (optional for debugging, remove if not needed)
echo "Generated JSON:"
echo "$complete_json"

# Send the API request
response=$( curl -X 'PUT' \
  --connect-timeout 5 \
  --max-time 10 \
  --retry 3 \
  --retry-delay 1 \
  --retry-max-time 30 \
  "$API_ENDPOINT/api/user/permissions" \
  -H 'Content-Type: application/json' \
  -H 'accept: application/json' \
  -H "X-Auth-Token: $API_TOKEN" \
  -d "$complete_json")

# Check for success or error in the response
if [ $? -eq 0 ]; then
  echo "Request sent successfully. Response:"
  echo "$response"
else
  echo "Error sending request. Response:"
  echo "$response" >&2
  exit 2
fi

echo "Script execution completed."
