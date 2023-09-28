#!/bin/bash

CLI_NAME="migraine"
REPO_OWNER="tesh254"
REPO_NAME="migraine"

BOLD=\e[1m
RESET=\e[0m


if command -v jq &> /dev/null
then
    echo "jq is installed"
else
    echo "jq is not installed"
    exit 1
fi

# Get OS and convert to lowercase
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Determine CPU architecture
ARCH=$(uname -m)

# Get release version without spaces
VERSION=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | jq -r '.tag_name' | tr -d '[:space:]')
RELEASE_VERSION="${VERSION:1}"
echo ":::bash::: latest version $RELEASE_VERSION"

# Get release URL
RELEASE_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$RELEASE_VERSION/${CLI_NAME}_${RELEASE_VERSION}_${OS}_${ARCH}.tar.gz"
echo ":::bash::: binary archive URL: $RELEASE_URL"

echo ":::bash::: creating a temporary directory for downloading and extracting $CLI_NAME"
TMP_DIR=$(mktemp -d)

echo ":::bash::: starting download..."
curl -L -o "$TMP_DIR/$CLI_NAME-$RELEASE_VERSION.tar.gz" "$RELEASE_URL"

echo ":::bash::: extraction started..."
tar -xzf "$TMP_DIR/$CLI_NAME-$RELEASE_VERSION.tar.gz" -C "$TMP_DIR"

echo ":::bash::: moving binary to a system bin directory"
if [ "$OS" == "darwin" ] || [ "$OS" == "linux" ]; then
    INSTALL_DIR="/usr/local/bin"
    sudo mv "$TMP_DIR/$CLI_NAME" "$INSTALL_DIR/$CLI_NAME"
    sudo chmod +x "$INSTALL_DIR/$CLI_NAME"
else
    echo ":::bash::: $OS operating system is not supported"
    exit 1
fi

echo ":::bash::: cleaning up the temporary directory"
rm -rf "$TMP_DIR"

echo ":::bash::: $CLI_NAME installed successfully $RELEASE_VERSION"
