# Table of contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Getting started](#getting-started)
   1. [Running Nodes](#running-nodes)
      1. [Pocket Network](#pocket-network)
      2. [Ethereum Mainnet](#ethereum-mainnet)
   2. [NGINX Setup](#nginx-setup)
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

### Ethereum Mainnet

#### 1. Requirement

Ethereum Mainnet running on the Erigon client requires specific ports to be open to facilitate network communication and synchronization. In addition, Ethereum nodes utilizing the Ethereum 2.0 client Lighthouse require port 9000 to be open for inter-node communication and synchronization on the Beacon chain.

| Port          | Type        | Firewall allow | Client     | Purpose                                             |
|---------------|-------------|----------------|------------|---------------------------------------------------- |
| 8545          | TCP         | N              | Erigon     | JSON-RPC API for HTTP connections                   |
| 8551          | TCP         | N              | Erigon     | Engine API                                          |
| 5052          | TCP         | N              | Lighthouse | Ethereum 2.0 Beacon Chain inter-node communication  |
| 9000          | TCP/UDP     | Y              | Lighthouse | Ethereum 2.0 Peer-to-Peer (P2P) communication       |
| 9090          | TCP         | N              | Erigon     | gRPC Server                                         |
| 30303         | TCP/UDP     | Y              | Erigon     | Ethereum peer-to-peer (P2P) communication           |
| 42069         | TCP/UDP     | Y              | Erigon     | Bittorrent                                          |

#### 2. Hardware Sizing and Limits
   
For optimal performance, we advise against imposing memory or CPU limits on the containers. If you choose to set limits, uncomment the `deploy` sections in the YAML file. These sections contain default minimum requirements for each node. For additional information, refer to the [System Requirements](https://github.com/ledgerwatch/erigon/blob/main/README.md#system-requirements) section in the Erigon documentation on GitHub, and for Lighthouse, see the [recommended system requirements](https://lighthouse-book.sigmaprime.io/installation.html#recommended-system-requirements).

#### 3. Deployment 

Change Directory to `eth`
```sh
cd docker/blockchains/eth
```

To ensure proper operation, ensure the necessary ports are open in your firewall. Use the following commands to open these ports:
```sh
sudo ufw allow 9000/tcp
sudo ufw allow 9000/udp
sudo ufw allow 30303/tcp
sudo ufw allow 30303/tcp
sudo ufw allow 42069/tcp
sudo ufw allow 42069/tcp
```

Set the correct permissions on both `erigon` and `lighthouse` folders
```sh
sudo mkdir lighthouse
sudo chown -R 1000:1000 ./erigon
sudo chown -R 1000:1000 ./lighthouse
```

Create the jwt.hex for secure and authenticated communication between different Ethereum clients and components (**Not Required**)
```sh
sudo bash -c 'openssl rand -hex 32 > ./erigon/jwt.hex'
```

The directory contains two YAML files. Start your desired node using `docker-compose up -f <file name> up -d`. See the [Usage](#usage) section of the README.md for additional docker node management tips. 




## NGINX Setup

**NGINX** is essential for running a Pocket Network node as it efficiently manages incoming traffic and distributes it across multiple backend servers. This is crucial for providing reliable relays to the network, as NGINX ensures load balancing, optimizes resource usage, and maintains high availability. Additionally, its robust security features protect the node from potential threats, ensuring seamless and secure relay provision to the network.

The NGINX folder is already deployed with multiple pre-configured `.sample` files that can be used as templates or as is by simply updating the required fields. Ports 80 and 443

First, create DNS records in your registrar for your `domain` or `subdomain` with the IP address of the host you are deploying the configuration on. We recommend using a `subdomain` because it allows the domain to serve multiple purposes. For example, with subdomains like `subdomain.example.com` and `*.subdomain.example.com`, you can isolate different services and environments under the same main domain. This approach improves organization, enhances security by isolating services, and provides greater flexibility for managing and scaling your infrastructure. Additionally, create a third A record for your servicer node, e.g., `servicer.subdomain.example.com`. 

| Hostname             | Type    | Value             |
| -------------------  | ------- | ----------------- |
| subdomain            | A       | 203.25.113.12     |
| *.subdomain          | A       | 203.25.113.12     |
| servicer.subdomain   | A       | 203.25.113.12     |

**Note:** This document will not discuss multi-region DNS deployment strategies. 

The deployment will automatically generate a certificate for the subdomain, including a **Subject Alternative Name (SAN)**. By default, the `number_of_sans` value is set to `50`. It is important to ensure that each POKT node is deployed with a trusted SSL certificate. LetsEncrypt has a limitation of `100` SANs per certificate. For larger node runners with extensive deployments, consider using alternative authentication methods with Cerbot, such as authentication keys, APIs, or DNS challenges, to generate a wildcard certificate (\*).

Change Directory to `proxy`
```sh
cd docker/proxy
```
To ensure proper operation, ensure that ports `80` and `443` for Nginx are open in your firewall. Use the following commands to open these ports:
```sh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

Using your preferred editor, edit `webroot/conf.d/http-redirect-and-acme.conf` and replace `<YOUR_DOMAIN_HERE>` with your subdomain. Use `sudo` if necessary. 
```
server {
    listen 80;
    server_name subdomain.example.com;
```
Again, using your preferred editor, edit `certbot-script.sh` and set the value under the `Basic Configuration` section. Leave all other populated variables as default.

- `prefix:` Matches the name of your POKT nodes. For example, `node`, `pokt`.

- `domain:` Matches your subdomain. For instance, `subdomain.example.com`.

- `number_of_sans:` Update this only if you have more than 50 POKT nodes.

- `email:` Matches your email address. For example, `yourname@example.com`.


Start the docker containers 
```sh
docker-compose up -d
```

Validate Certbot has successfully generate the certificate.
```sh
docker-compose logs -f 
```

In the `/webroot/conf.d` folder, there are two `.sample` files. To proceed, remove the `.sample` extension from the file that corresponds to the deployment strategy in your region using the `cp` command. For example, `cp nginx/conf.d/servicer.conf.sample nginx/conf.d/servicer-mesh.conf`. Then, using your preferred editor, update the `server_name` location in the selected file with the accurate DNS record. Additional instructions are provided within the config file for guidance.

| File                       | Deployment Type          |
| -------------------------  | ------------------------ | 
| servicer-mesh.conf.sample  | Both (Servicer, Mesh)    | 
| mesh                       | Mesh                     | 


See [Pocket Network](#pocket-network) for more information on POKT nodes deployment methods.

Finally, execute the following command to `reload NGINX`
```sh
docker exec -it webserver nginx -s reload
```

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
