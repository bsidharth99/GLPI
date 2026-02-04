#!/bin/bash
set -e -u -o pipefail

# Create `config`, `marketplace` and `files` volume (sub)directories that are missing
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
        echo "Creating $dir..."
        mkdir -p -- "$dir"
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

# --------------------------------------------------
# Seed marketplace plugins from image if missing
# --------------------------------------------------

IMAGE_MARKETPLACE="/var/www/glpi/marketplace"
PVC_MARKETPLACE="${GLPI_MARKETPLACE_DIR}"

if [ -d "$IMAGE_MARKETPLACE" ]; then
    for plugin in "$IMAGE_MARKETPLACE"/*; do
        plugin_name="$(basename "$plugin")"

        if [ ! -d "$PVC_MARKETPLACE/$plugin_name" ]; then
            echo "Seeding marketplace plugin: $plugin_name"
            cp -R "$plugin" "$PVC_MARKETPLACE/"
            chown -R "$(id -u):$(id -g)" "$PVC_MARKETPLACE/$plugin_name"
        fi
    done
fi
