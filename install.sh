#!/bin/bash

# Prompt for the WoW _retail_ directory
read -p "Enter the path to your WoW _retail_ directory: " wow_retail_path

# Check if the provided path exists and is correct
if [ ! -d "$wow_retail_path" ]; then
    echo "The provided path does not exist. Please ensure you have the correct path."
    exit 1
fi

# Define the path to the Interface and WTF directories
interface_dir="$wow_retail_path/Interface"
wtf_dir="$wow_retail_path/WTF"

# Creating symlinks for Interface and WTF directories
ln -sfn $(pwd)/Interface "$wow_retail_path"
ln -sfn $(pwd)/WTF "$wow_retail_path"

echo "Symlinks for Interface and WTF directories have been created."

# Check if the ToxiUI repository already exists
if [ ! -d "ToxiUI" ]; then
    git clone https://github.com/Toxicom/toxiui.git "./ToxiUI"
    echo "ToxiUI repository has been cloned."
else
    echo "ToxiUI repository already exists."
fi

# Check if the ElvUI repository already exists
if [ ! -d "ElvUI" ]; then
    git clone https://github.com/tukui-org/ElvUI.git "./ElvUI"
    echo "ElvUI repository has been cloned."
else
    echo "ElvUI repository already exists."
fi

# Creating symlinks for ToxiUI and ElvUI directories inside the Interface folder
ln -sfn $(pwd)/ToxiUI "$(pwd)/Interface/AddOns/ElvUI_ToxiUI"
ln -sfn $(pwd)/ElvUI/ElvUI "$(pwd)/Interface/AddOns/ElvUI"
ln -sfn $(pwd)/ElvUI/ElvUI_Libraries "$(pwd)/Interface/AddOns/ElvUI_Libraries"
ln -sfn $(pwd)/ElvUI/ElvUI_Options "$(pwd)/Interface/AddOns/ElvUI_Options"

echo "Symlinks for ToxiUI and ElvUI addons have been created in the Interface directory."

echo "Installation complete."

