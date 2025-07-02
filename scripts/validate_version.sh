#!/usr/bin/env bash

# Verify that the crate version is not a pre-release version. We must extract
# it from alire.toml, from `version = "x.y.z"` line.

set -o errexit
set -o nounset

if [[ ! -f alire.toml ]]; then
    echo "Error: alire.toml not found in the current directory."
    exit 1
fi

version=$(grep -oP 'version\s*=\s*"\K[^"]+' alire.toml)
if [[ -z "$version" ]]; then
    echo "Error: Version not found in alire.toml."
    exit 1
fi

if [[ "$version" == *"-"* ]]; then
    echo "Error: Pre-release version detected: $version"
    exit 1
fi

echo "Version $version is valid and not a pre-release."