#!/bin/bash

# Configuration file path for Cursor on Linux
STORAGE_FILE="$HOME/.config/Cursor/User/globalStorage/storage.json"

# Generate random ID
generate_random_id() {
    openssl rand -hex 32
}

# Generate random UUID
generate_random_uuid() {
    uuidgen | tr '[:upper:]' '[:lower:]'
}

# Generate new IDs
NEW_MACHINE_ID=${1:-$(generate_random_id)}
NEW_MAC_MACHINE_ID=$(generate_random_id)
NEW_DEV_DEVICE_ID=$(generate_random_uuid)

# Create backup
backup_file() {
    if [ -f "$STORAGE_FILE" ]; then
        cp "$STORAGE_FILE" "${STORAGE_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "Backup file created"
    fi
}

# Ensure directory exists
mkdir -p "$(dirname "$STORAGE_FILE")"

# Create backup
backup_file

# If file doesn't exist, create a new JSON
if [ ! -f "$STORAGE_FILE" ]; then
    echo "{}" > "$STORAGE_FILE"
fi

# Update all telemetry IDs
sed -i 's/"telemetry\.machineId":[[:space:]]*"[^"]*"/"telemetry.machineId": "'$NEW_MACHINE_ID'"/' "$STORAGE_FILE"
sed -i 's/"telemetry\.macMachineId":[[:space:]]*"[^"]*"/"telemetry.macMachineId": "'$NEW_MAC_MACHINE_ID'"/' "$STORAGE_FILE"
sed -i 's/"telemetry\.devDeviceId":[[:space:]]*"[^"]*"/"telemetry.devDeviceId": "'$NEW_DEV_DEVICE_ID'"/' "$STORAGE_FILE"

echo "Successfully modified IDs:"
echo "machineId: $NEW_MACHINE_ID"
echo "macMachineId: $NEW_MAC_MACHINE_ID"
echo "devDeviceId: $NEW_DEV_DEVICE_ID"