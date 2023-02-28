#!/bin/bash

echo "Update packages ..."
sudo apt-get -q update
sudo apt-get -yq upgrade

echo "Install unzip"
if [ ! -x /usr/bin/unzip ]
then
    sudo apt-get -yq update
    sudo apt-get -yq install unzip
fi

echo "Install Azure CLI"
if [ ! -x /usr/bin/az ]
then
    # curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    sudo apt-get -q update
    sudo apt-get -yq install ca-certificates curl apt-transport-https lsb-release gnupg

    sudo mkdir -p /etc/apt/keyrings
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list
    
    sudo apt-get -yq update
    sudo apt-get -yq install azure-cli
fi

grep ghrund /etc/passwd > /dev/null
if [ $? -ne 0 ]
then
    sudo adduser --system --home /home/ghrund --shell /bin/bash --disabled-password ghrund
fi
