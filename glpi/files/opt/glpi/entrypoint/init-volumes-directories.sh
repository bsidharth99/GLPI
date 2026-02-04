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
    # NEW LOGIC: Check if directory is missing OR exists but is empty
    # (We ignore lost+found which is common on K8s volumes)
    IS_EMPTY=$(ls -A "$dir" 2>/dev/null | grep -v "lost+found" | wc -l)

    if [ ! -d "$dir" ] || [ "$IS_EMPTY" -eq 0 ]; then
        folder_name=$(basename "$dir")
        
        if [ -d "$SRC_ROOT/$folder_name" ] && [ "$(ls -A "$SRC_ROOT/$folder_name" 2>/dev/null)" ]; then
            echo "Empty mount detected. Initializing $dir from image source..."
            mkdir -p -- "$dir"
            cp -rp "$SRC_ROOT/$folder_name/." "$dir/"
        else
            [ ! -d "$dir" ] && echo "Creating empty $dir..." && mkdir -p -- "$dir"
        fi
    else
        echo "Directory $dir already contains data, skipping sync."
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
