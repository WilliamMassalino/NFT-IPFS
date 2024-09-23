# LW3Punks NFT Collection

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Build](#build)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Smart Contract Overview](#smart-contract-overview)
- [Website Setup](#website-setup)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Deploying your dApp](#deploying-your-dapp)
- [License](#license)


## Introduction

Welcome to the LW3Punks NFT collection project! This project allows you to build and deploy your own NFT collection on the Ethereum Sepolia testnet, with metadata stored securely on IPFS. The LW3Punks NFT collection consists of 10 unique NFTs, and each user can mint one NFT per transaction. This guide will walk you through setting up the smart contract, deploying it, and creating a web interface to mint NFTs.

## Prerequisites
Before starting, ensure you have completed the following prerequisites:

* Basic knowledge of NFTs and IPFS.
* Installed Foundry, an Ethereum development environment for Solidity smart contracts.
* Signed up for Pinata to upload images and metadata to IPFS.
* Created a test Ethereum wallet (using MetaMask) with Sepolia ETH for testing.

## Build

IPFS

First, we need to upload our images and metadata on to IPFS. We'll use a service called [Pinata](https://app.pinata.cloud/) which will help us upload and pin content on IPFS. Once you've signed up, go to the [Pinata Dashboard](https://app.pinata.cloud/pinmanager) and click on 'Upload' and then on 'Folder'.

Download the [LW3Punks folder](https://github.com/LearnWeb3DAO/IPFS-Practical/tree/master/my-app/public/LW3punks) to your computer and then upload to it Pinata, name the folder LW3Punks

Now you should be able to see a CID for your folder, Awesome!

![LW3Punks CID](https://lw3-misc-images.s3.us-east-2.amazonaws.com/d522e12d-6dfb-4c18-9c8a-b96f7e6c61eb)

The images for your NFT's have now been uploaded to IPFS but just having images is not enough, each NFT should also have associated metadata

We will now upload metadata for each NFT to IPFS, each metadata file will be a json file. Example for metadata of NFT 1 has been given below:
```json
{
  "name": "1",
  "description": "NFT Collection for LearnWeb3 Students",
  "image": "ipfs://QmQBHarz2WFczTjz5GnhjHrbUPDnB48W5BM2v2h6HbE1rZ/1.png"
}
```
There are pre-generated files for metadata for you, you can download them to your computer from [here](https://github.com/LearnWeb3DAO/IPFS-Practical/tree/master/my-app/public/metadata), upload these files to pinata and name the folder metadata

Now each NFT's metadata has been uploaded to IPFS and pinata should have generated a CID for your metadata folder.
![LW3Metadata](https://lw3-misc-images.s3.us-east-2.amazonaws.com/e1f90520-3a00-4565-a2a1-92216145239f)

## Installation

To set up the project, follow these steps:

1. **Clone the Repository**  
   First, clone the project repository from GitHub:

   ```bash
   git clone https://github.com/WilliamMassalino/NFT-IPFS.git
   cd NFT-IPFS

2. **Set up the Smart Contract**
  Navigate to the foundry-app directory and install the necessary dependencies:
    ```bash
     cd foundry-app
     forge install OpenZeppelin/openzeppelin-contracts
     forge remappings > remappings.txt
    ```
3. **Configure Environment Variables**
  Create a .env file in the foundry-app directory and add your QuickNode endpoint,MetaMask private key and CID metadata:
    ```bash
      QUICKNODE_HTTP_URL="your-quicknode-url"
      PRIVATE_KEY="your-private-key"
      CID_METADATA="your-cid-metadata"
    ```
4. **Deploy the Smart Contract**
  Compile the contract:
    ```bash
      forge compile
    ```
  Deploy the contract to the Sepolia testnet:
  
      ```bash
        forge create --rpc-url $RPC_URL --constructor-args $CID_METADATA --private-key $PRIVATE_KEY src/LW3Punks.sol:LW3Pun
      
## Usage

Once deployed, users can mint NFTs via the website or interact with the smart contract directly.

**Step 1: Minting an NFT**
Users can mint an NFT by sending 0.01 ether to the contract. Only one NFT can be minted per transaction, and a total of 10 unique NFTs can be minted.

**Step 2: View the NFT Metadata**
NFT metadata is stored on IPFS. You can retrieve an NFT’s metadata using the tokenURI function of the contract, which returns the IPFS link to the metadata.

## Features

* **IPFS Integration:** Metadata and images for NFTs are stored on IPFS for decentralized access.
* **Minting Limit:** Each user can mint only one NFT per transaction, with a maximum of 10 NFTs in the collection.
* **Sepolia Testnet:** The NFT contract is deployed on the Ethereum Sepolia testnet for testing purposes.
* **Wallet Integration:** Connect popular wallets like MetaMask using RainbowKit for a seamless user experience.

## Smart Contract Overview

* **ERC721Enumerable:** Keeps track of all token IDs and allows enumeration of token holders.
* **Ownable:** Only the contract owner can perform certain privileged operations, such as pausing the contract or withdrawing funds.
* **Minting Mechanism:** Users can mint an NFT by paying 0.01 ether. The mint function ensures no more than 10 NFTs are minted.

## Website Setup

**Step 1: Create a React App**
1. Create a Next.js app for the website:
   ```bash
   cd my-app
   npx create-next-app@latest
   ```
2. Install dependencies:
   ```bash
   npm install @rainbow-me/rainbowkit wagmi viem@2.x @tanstack/react-query
    ```
3. Set up wallet connection and contract interaction using RainbowKit and Wagmi.

**Step 2: Connect the Frontend with the Smart Contract**

Use the contract ABI and address to enable the website to interact with the LW3Punks smart contract. Users can mint NFTs directly from the website.

```bash
export const NFT_CONTRACT_ADDRESS = "address of your NFT contract";
export const abi = "---your abi---";
```
Now in your terminal which is pointing to `my-app` folder, execute
```bash
npm run dev
```
You should see a webpage like this:

![image](https://github.com/user-attachments/assets/c2d4676a-49de-4174-944f-30a8e9bd60fb)

## Dependencies

* **Solidity:** ^0.8.25
* **OpenZeppelin:** ERC721 and Ownable contracts
* **IPFS:** For storing metadata and images
* **Foundry:** Ethereum development environment
* **Next.js:** React framework for the website
* **RainbowKit:** Wallet connection for dApps

## Troubleshooting

**IPFS Issues:** Ensure that the CID is correctly formatted and accessible.
**Smart Contract Deployment:** Verify that your private key and QuickNode URL are correctly configured in the .env file.
**Website Not Running:** Check that all dependencies are installed and the Next.js app is correctly configured.

## Deploying your dApp

Make sure before proceeding you have pushed all your code to github.
We will now deploy your dApp, so that everyone can see your website and you can share it with all of your LearnWeb3 DAO friends.

* Go to https://vercel.com/ and sign in with your GitHub

* Then click on `New Project` button and then select your IPFS-Practical repo

* When configuring your new project, Vercel will allow you to customize your `Root Directory`

* Click `Edit` next to `Root Directory` and set it to my-app

* Select the Framework as `Next.js`

* Click `Deploy`


## License

This project is licensed under the MIT License - see the LICENSE file for details.








