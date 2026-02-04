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
    # Check if directory doesn't exist OR is empty (ignoring lost+found)
    if [ ! -d "$dir" ] || [ -z "$(ls -A "$dir" 2>/dev/null | grep -v "lost+found")" ]; then
        
        folder_name=$(basename "$dir")
        
        # Check if the image source actually has files to copy
        if [ -d "$SRC_ROOT/$folder_name" ] && [ "$(ls -A "$SRC_ROOT/$folder_name" 2>/dev/null)" ]; then
            echo "Initializing $dir from image source..."
            mkdir -p -- "$dir"
            cp -rp "$SRC_ROOT/$folder_name/." "$dir/"
        else
            # Only log "Creating" if it doesn't actually exist yet
            if [ ! -d "$dir" ]; then
                echo "Creating empty $dir..."
                mkdir -p -- "$dir"
            fi
        fi
    else
        echo "Directory $dir already exists and is not empty, skipping initialization."
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
