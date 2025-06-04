#!/bin/bash

# Absolute path to packages.yaml
YAML_FILE="$HOME/.spack/packages.yaml"

# Check if the file exists
if [ ! -f "$YAML_FILE" ]; then
    echo "❌ Error: File not found at $YAML_FILE"
    exit 1
fi


package_names=$(grep -E '^[[:space:]]{2}[a-zA-Z0-9_-]+:' packages.yaml| sed 's/^[[:space:]]*//;s/://')

echo "📦 Found packages:"
for pkg in $package_names; do
    echo "- $pkg"
done

echo ""

for pkg in $package_names; do
    echo "🔍 spack external find $pkg"
    spack external find "$pkg"
done


spack find openmpi@5.0.7
