# Table of contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Getting started](#getting-started)
   1. [Running Nodes](#running-nodes)
      1. [Pocket Network](#pocket-network)
      2. [Ethereum](#ethereum)
   2. [Nginx Setup](#nginx-setup)
   3. [Monitoring](#monitoring)
   4. [Alert](#alert)
4. [Usage](#usage)
5. [Help and Support](#help-and-support)
6. [License](#license)


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

To deploy a node, navigate to the node's respective directory and start the type of node you wish to run. They are generally classified as the following:

`Mainnet`: A mainnet blockchain node, such as one running an Erigon client, operates on the primary network where actual transactions take place. It validates and propagates transactions and blocks in the live, operational blockchain.

`Archival`: An archival node stores the full history of the blockchain, including all historical states and transactions, unlike a mainnet node which may only store recent states. Due to this comprehensive data retention, archival nodes tend to be more resource-intensive and require significantly more storage. This makes them essential for tasks requiring access to historical blockchain data, such as data analysis and historical audits.

### Pocket Network

#### 1. Requirement

A Pocket node requires the following ports to be open to the internet. Ensure the Tendermint port is reachable so your node can effectively communicate and participate in the network:

| port          | type    | firewall allow |
| ------------  | ------- | -------------- |
| 8081          | TCP     | N              |
| 8082          | TCP     | N              |
| 8083          | TCP     | N              |
| 26656         | TCP     | Y              |
| 26657         | TCP     | N              |

#### 2. Hardware Sizing and Limits
   
For best performance, we do not recommend adding any memory or CPU limits to the containers. If you would like to add limits, see the hardware sizing section of the Pocket Network documentation.

To set limits, include the following section in your docker-compose.yml file:
```
pocket-node:
    <<: *logging
    image: poktscan/pocket-core:BETA-MESH-RC-0.5.0-RC-0.11.1
    container_name: pocket-node
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '16'    # Limit the container to 16 CPU cores
          memory: 32G   # Limit the container to 32 GB of RAM

```

<details>
<summary>Method 1 - Primary Site (Region)</summary>
<br> </br> 
For your <b>primary site</b>, use the `servicer-mesh.yml` deployment strategy to deploy two node instances. You can deploy a validator node or a servicer node to service any region. However, it is strongly recommended to deploy a mesh node in front of your servicer node to minimize relay processing time. In this setup, the mesh node will handle all the relays, while the servicer nodes process them.
<br></br>
   
Change Directory to `pokt`
```sh
cd docker/blockchains/pokt
```

If necessary, ensure correct permissions on the `pokt` folder:
```sh
sudo chown -R 1005:1005 mesh/.pocket
sudo chown -R 1005:1005 node/.pocket
```

Ensure you have the latest `addrbook.json` for the servicer node:
```sh
sudo wget -O node/.pocket/config/addrbook.json https://pocket-snapshot-us.liquify.com/files/addrbook.json
```

Using your preferred text editor, modify the `node/.pocket/config/config.json` file with your node's IP address and Tendermint port (26656).
```
"ExternalAddress"="tcp://YOUR_NODE_IP_ADDRESS:26656"
```
**Note:** Set `"generate_token_on_start"` to `true`(Required) 

Using your preferred text editor, update `node/.pocket/lean_nodes_keys.json` with your pocket node wallet private key(s). 
```
[
   {
      "priv_key":""
   }
]
```

Again, using your preferred text editor, update `mesh/.pocket/key/key.json` with your pocket node wallet private key(s).
```
[
  {
    "name": "",
    "url": "http://pocket-node:8081",
    "keys": [
      ""
    ]
  }
]
```
**Note:** It's advisable to begin by launching the servicer node with the command `docker-compose -f servicer-mesh.yml up -d pocket-node`, and subsequently, copy the `auth.json` file to the servicer node directory. After the copy, set `"generate_token_on_start"` to `false`

```sh
sudo cp node/.pocket/config/auth.json mesh/.pocket/auth/servicer.json
sudo cp node/.pocket/config/auth.json mesh/.pocket/auth/mesh.json
```
</details>

<details>
<summary>Method 2 - Multi-Region</summary>
<br> </br> 
Use `mesh.yml` specifically for statelite node deployment in other regions. Before initiating the mesh node, ensure that all your supported blockchain infrastructure is deployed and ready, with the chain nodes fully synchronized to the latest block heights. Additionally, refer to this deployment guide to properly configure the node for production use.
<br></br>
   
Change Directory to `pokt`
```sh
cd docker/blockchains/pokt
```

If necessary, ensure correct permissions on the `pokt` folder:
```sh
sudo chown -R 1005:1005 mesh/.pocket
```

Again, using your preferred text editor, update `mesh/.pocket/key/key.json` with your pocket node wallet private key(s). Also replace the pocket `URL` to reflect the `IP:PORT` or `FQDN` of your servicer node running in your primary site.
```
[
  {
    "name": "",
    "url": "http://servicer.us.exmaple",
    "keys": [
      ""
    ]
  }
]
```

Again, using your preferred text editor, create and/or update the following `auth` to match your servicer node in your primary site.  
```
mesh/.pocket/auth/mesh.json
mesh/.pocket/auth/servicer.json
```
</details>

<details>
<summary>Method 3 - Single Validator</summary>
<br> </br>
   
To deploy a single instance of Pocket, utilize the `validator.yml` file. This scenario is uncommon, as most node runners opt for the LeanPocket feature to run multiple servicers and validators within a single instance, thereby reducing hardware costs.

Change Directory to `pokt`
```sh
cd docker/blockchains/pokt
```

If necessary, ensure correct permissions on the `pokt` folder:
```sh
sudo chown -R 1005:1005 node/.pocket
```

Make a copy of the `example.env` to `.env`
```sh
sudo cp example.env .env
```

Ensure you have the latest `addrbook.json` for the servicer node:
```sh
sudo wget -O node/.pocket/config/addrbook.json https://pocket-snapshot-us.liquify.com/files/addrbook.json
```

Update the contents of the `.env` file
```
POCKET_CORE_PASSPHRASE=""
POCKET_CORE_KEY=""
POCKET_CORE_ADDRESS=""
```

Using your preferred text editor, modify the `node/.pocket/config/config.json` file to disable LeanPocket by finding the lines below and set them from `true` to false`, as well as the updating `ExternalAddress` with your node's IP address and Tendermint port (26656).
```
"ExternalAddress"="tcp://YOUR_NODE_IP_ADDRESS:26656"
"lean_pocket": false,
"mesh_node": false,
```
</details>

#### 3. Snaphshot download 

Using a snapshot to deploy your node can significantly reduce the time required for initial synchronization. Instead of downloading and verifying all historical blocks, the snapshot provides a recent state of the blockchain, allowing your node to quickly catch up to the current network state. Copy and paste the following commands to download and extract the latest [snapshot](https://pocket-snapshot-us.liquify.com/#/).

```
sudo wget -O downloaded_snap.tar https://pocket-snapshot-us.liquify.com/files/pruned/$(curl -s https://pocket-snapshot-us.liquify.com/files/pruned/latest.txt) && tar -xvf downloaded_snap.tar -C node/.pocket/ && rm downloaded_snap.tar
```


## Nginx Setup

## Monitoring

## Alert

# Usage

To manage a node, use the following command, replacing file path with the path to your YAML file:

**Start a node**

```sh
docker-compose -f /path/to/your/file.yml up -d
```

### View logs

```sh
docker-compose -f /path/to/your/file.yml logs -f
```

### Stop

```sh
docker-compose -f /path/to/your/file.yml down
```

### Restart

```sh
docker-compose -f /path/to/your/file.yml restart
```

# Help and Support
**Development of the project is currently underway, and we welcome participants. If you encounter any issues or would like to report a problem, please open a GitHub [issue](https://github.com/stakenodes-unchained/node-deployment-accelerator/issues) detailing the steps to replicate it, the current, and the expected behavior.**

# License
MIT License

For more information, see the [LICENSE.md](LICENSE.md) file.
