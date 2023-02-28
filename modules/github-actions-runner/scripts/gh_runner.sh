#!/bin/bash

# https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service
# https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners

sudo su - ghrund -c "mkdir actions-runner"
sudo su - ghrund -c "cd actions-runner && curl -o actions-runner-linux-x64-2.301.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.301.1/actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - ghrund -c "cd actions-runner && tar xzf ./actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - ghrund -c "cd actions-runner && ./config.sh --url https://github.com/gutt02/<REPRO> --token <TOKEN>"
