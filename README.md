# Table of contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Getting started](#getting-started)
   1. [Running Nodes](#running-nodes)
   2. [Nginx Setup](#nginx-setup)
   3. [Monitoring](#monitoring)
   4. [Alert](#alert)
4. [Help and Support](#help-and-support)
5. [License](#license)



# Overview
Node Deployment Accelerator (NDA) is an innovative GitHub repository designed to simplify the deployment process for various blockchains. It streamlines the setup of blockchain nodes, empowering users to initiate their desired blockchain deployment effortlessly.

The project utilizes Grafana and Prometheus to monitor each node's health, offering real-time visualization and analysis, while seamlessly integrating alarm systems to promptly notify node runners of any status changes, ensuring optimal performance and swift issue resolution.

The solution will include a user-friendly interface that allows for easy monitoring of a node's status, whether it is up or down. The design principle of NDA is not to fully automate the deployment of a blockchain node, but to simplify the process enough for anyone to accomplish it while providing flexibility for users to make modifications as needed.

# Installation
`Docker` and `Docker Compose` are essential dependencies for this project. They must be installed before proceeding. Expand the [Setup](#setup) section for step-by-step instructions on how to install Docker and Docker Compose on the Ubuntu operating system.

## Setup
<details>
<summary>Docker Install</summary>

  ### Step 1: Install Docker

1. **Update the package database**:
    ```sh
    sudo apt-get update
    ```

2. **Install the necessary packages**:
    ```sh
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    ```

3. **Add Docker’s official GPG key**:
    ```sh
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    ```

4. **Set up the stable repository**:
    ```sh
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

5. **Update the package database again**:
    ```sh
    sudo apt-get update
    ```

6. **Install Docker Engine**:
    ```sh
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```

7. **Verify that Docker Engine is installed correctly**:
    ```sh
    sudo docker run hello-world
    ```

### Step 2: Install Docker Compose

1. **Download the current stable release of Docker Compose**:
    ```sh
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```

2. **Apply executable permissions to the binary**:
    ```sh
    sudo chmod +x /usr/local/bin/docker-compose
    ```

3. **Verify the installation**:
    ```sh
    docker-compose --version
    ```

### Step 3: Run Docker as a Non-Root User

1. **Create the `docker` group** (if it doesn't already exist):
    ```sh
    sudo groupadd docker
    ```

2. **Add your user to the `docker` group**:
    ```sh
    sudo usermod -aG docker $USER
    ```

3. **Log out and log back in so that your group membership is re-evaluated**.

4. **Verify that you can run `docker` commands without `sudo`**:
    ```sh
    docker run hello-world
    ```

Now, Docker and Docker Compose should be installed and ready to use on your system.
</details>

# Getting Started

Clone the Repository

```sh
git clone stakenodes-unchained/node-deployment-accelerator.git
```
Change the directory

```sh
 cd node-deployment-accelerator
```
## Running Nodes

## Nginx Setup

## Monitoring

## Alert

# Help and Support
**Development of the project is currently underway, and we welcome participants. If you encounter any issues or would like to report a problem, please open a GitHub [issue](https://github.com/stakenodes-unchained/node-deployment-accelerator/issues) detailing the steps to replicate it, the current, and the expected behavior.**

# License
MIT License

For more information, see the [LICENSE.md](LICENSE.md) file.
