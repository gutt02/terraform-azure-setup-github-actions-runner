#!/bin/bash

# https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
# https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service

sudo su - gharund -c "mkdir actions-runner-<project>"
sudo su - gharund -c "cd actions-runner-<project> && curl -o actions-runner-linux-x64-2.301.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.301.1/actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && tar xzf ./actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && rm -f ./actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && ./config.sh --url https://github.com/gutt02/<REPO> --token <TOKEN>"
sudo su -c "cd /home/gharund/actions-runner-<project> && ./svc.sh install gharund"
sudo su -c "cd /home/gharund/actions-runner-<project> && ./svc.sh start"
