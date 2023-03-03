#!/bin/bash

# https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
# https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service

# ./config.sh --help
# Commands:
#  ./config.sh         Configures the runner
#  ./config.sh remove  Unconfigures the runner
#  ./run.sh            Runs the runner interactively. Does not require any options.

# Options:
#  --help     Prints the help for each command
#  --version  Prints the runner version
#  --commit   Prints the runner commit
#  --check    Check the runner's network connectivity with GitHub server

# Config Options:
#  --unattended           Disable interactive prompts for missing arguments. Defaults will be used for missing options
#  --url string           Repository to add the runner to. Required if unattended
#  --token string         Registration token. Required if unattended
#  --name string          Name of the runner to configure (default BGPF13S59E)
#  --runnergroup string   Name of the runner group to add this runner to (defaults to the default runner group)
#  --labels string        Extra labels in addition to the default: 'self-hosted,Linux,X64'
#  --local                Removes the runner config files from your local machine. Used as an option to the remove command
#  --work string          Relative runner work directory (default _work)
#  --replace              Replace any existing runner with the same name (default false)
#  --pat                  GitHub personal access token with repo scope. Used for checking network connectivity when executing `./run.sh --check`
#  --disableupdate        Disable self-hosted runner automatic update to the latest released version`
#  --ephemeral            Configure the runner to only take one job and then let the service un-configure the runner after the job finishes (default false)

sudo su - gharund -c "mkdir actions-runner-<project>"
sudo su - gharund -c "cd actions-runner-<project> && curl -o actions-runner-linux-x64-2.301.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.301.1/actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && tar xzf ./actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && rm -f ./actions-runner-linux-x64-2.301.1.tar.gz"
sudo su - gharund -c "cd actions-runner-<project> && ./config.sh --unattended --url https://github.com/gutt02/<REPO> --token <TOKEN>"
sudo su -c "cd /home/gharund/actions-runner-<project> && ./svc.sh install gharund"
sudo su -c "cd /home/gharund/actions-runner-<project> && ./svc.sh start"
