#!/bin/bash

CLI_NAME="migraine"
REPO_OWNER="tesh254"
REPO_NAME="migraine"

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
CHECK="✓"
CROSS="˟"

if command -v jq &> /dev/null
then
    echo -e "${BOLD}${GREEN}:::bash::: jq is installed ${CHECK}${RESET}"
    # Get OS and convert to lowercase
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    
    # Determine CPU architecture
    ARCH=$(uname -m)
    
    # Get release version without spaces
    VERSION=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | jq -r '.tag_name' | tr -d '[:space:]')
    RELEASE_VERSION="${VERSION:1}"
    echo -e "${BOLD}${BLUE}:::bash::: ${CLI_NAME} latest version $RELEASE_VERSION${RESET}"
    
    # Get release URL
    RELEASE_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$RELEASE_VERSION/${CLI_NAME}_${RELEASE_VERSION}_${OS}_${ARCH}.tar.gz"
    echo -e "${BOLD}${GREEN}:::bash::: binary archive URL: $RELEASE_URL ${CHECK}${RESET}"
    
    echo -e "${BOLD}${BLUE}:::bash::: creating a temporary directory for downloading and extracting $CLI_NAME${RESET}"
    TMP_DIR=$(mktemp -d)
    
    echo -e "${BOLD}${BLUE}:::bash::: starting download...${RESET}"
    curl -L -o "$TMP_DIR/$CLI_NAME-$RELEASE_VERSION.tar.gz" "$RELEASE_URL"
    
    echo -e "${BOLD}${BLUE}:::bash::: extraction started...${RESET}"
    tar -xzf "$TMP_DIR/$CLI_NAME-$RELEASE_VERSION.tar.gz" -C "$TMP_DIR"
    
    echo -e "${BOLD}${BLUE}:::bash::: moving binary to a system bin directory"
    if [ "$OS" == "darwin" ] || [ "$OS" == "linux" ]; then
        INSTALL_DIR="/usr/local/bin"
        sudo mv "$TMP_DIR/$CLI_NAME" "$INSTALL_DIR/$CLI_NAME"
        echo -e "${BOLD}${BLUE}:::bash::: making migraine executable...${RESET}"
        sudo chmod +x "$INSTALL_DIR/$CLI_NAME"
        echo -e "${BOLD}${GREEN}:::bash::: making file executable ${CHECK}${RESET}"
    else
        echo -e "${BOLD}${RED}:::bash::: $OS operating system is not supported  ${RESET}"
        exit 1
    fi
    
    echo -e "${BOLD}${BLUE}:::bash::: cleaning up the temporary directory...${RESET}"
    rm -rf "$TMP_DIR"
    
    echo -e "${BOLD}${GREEN}:::bash::: $CLI_NAME installed successfully $RELEASE_VERSION ${CHECK}${RESET}"
else
    echo -e "${BOLD}${RED}:::bash::: jq is not installed;${RESET} please refer to ${BOLD}${GREEN}https://github.com/tesh254/migraine#readme${RESET} on how to install it"
    exit 1
fi

