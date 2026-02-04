#!/bin/bash
set -e -u -o pipefail

# Define where the 'baked-in' source is in the image
SRC_ROOT="/var/www/glpi"

roots=(
    "${GLPI_CONFIG_DIR}"
    "${GLPI_VAR_DIR}"
    "${GLPI_MARKETPLACE_DIR}"
    "${GLPI_LOG_DIR}"
)
vars=(
    "${GLPI_VAR_DIR}/_cache"
    "${GLPI_VAR_DIR}/_cron"
    "${GLPI_VAR_DIR}/_dumps"
    "${GLPI_VAR_DIR}/_graphs"
    "${GLPI_VAR_DIR}/_locales"
    "${GLPI_VAR_DIR}/_lock"
    "${GLPI_VAR_DIR}/_pictures"
    "${GLPI_VAR_DIR}/_plugins"
    "${GLPI_VAR_DIR}/_rss"
    "${GLPI_VAR_DIR}/_sessions"
    "${GLPI_VAR_DIR}/_tmp"
    "${GLPI_VAR_DIR}/_uploads"
    "${GLPI_VAR_DIR}/_inventories"
)

all_dirs=("${roots[@]}" "${vars[@]}")

for dir in "${all_dirs[@]}"
do
    if [ ! -d "$dir" ]; then
        # 1. Get the folder name (e.g., 'marketplace')
        folder_name=$(basename "$dir")
        
        # 2. Check if the image has content for this folder (like your SAML plugin)
        if [ -d "$SRC_ROOT/$folder_name" ] && [ "$(ls -A "$SRC_ROOT/$folder_name" 2>/dev/null)" ]; then
            echo "Initializing $dir from image source..."
            mkdir -p -- "$dir"
            # Copy contents from image to the empty volume
            cp -rp "$SRC_ROOT/$folder_name/." "$dir/"
        else
            echo "Creating empty $dir..."
            mkdir -p -- "$dir"
        fi
    fi
done

# Check permissions
for dir in "${roots[@]}"
do
    if [ ! -w "$dir" ]; then
        echo "ERROR: Directory $dir is not writable by current user (UID $(id -u))."
        echo "Please ensure that the mounted volume is writable by UID $(id -u) (usually www-data)."
        exit 1
    fi
done
