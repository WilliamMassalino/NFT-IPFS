"use client";
import Image from "next/image";
import { Courier_Prime } from "next/font/google";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount, useReadContract, useWriteContract } from "wagmi";
import { useState } from "react";
import { NFT_CONTRACT_ADDRESS, abi } from "@/constants";
import { parseEther } from "viem";

//importing a font we need
const courier = Courier_Prime({ subsets: ["latin"], weight: ["400", "700"] });

export default function Home() {
  //loading state for when our app is loading something
  const [isLoading, setIsLoading] = useState(false);

  //this hook returns true if the user has connected their wallet and false when they haven't
  const account = useAccount();

  //this executes the tokenIds function in our deployed contract
  const numOfTokensMinted = useReadContract({
    abi,
    address: NFT_CONTRACT_ADDRESS,
    functionName: "tokenIds",
  }).data;

  //hook for writing to a smart contract. It returns a promise that can be awaited
  const { writeContractAsync } = useWriteContract();

  //function for minting a token
  const mintToken = async () => {
    // set isLoading to true
    setIsLoading(true);
  
    try {
      // Log wallet connection status before proceeding
      console.log("Wallet connection status:", account.isConnected);
  
      // Check if the wallet is actually connected
      if (!account.isConnected) {
        window.alert("Please connect your wallet before minting.");
        setIsLoading(false);
        return;
      }
  
      console.log("Starting the minting process...");
  
      const result = await writeContractAsync({
        abi,
        address: NFT_CONTRACT_ADDRESS,
        functionName: "mint",
        value: parseEther("0.01"),
      });
  
      console.log("Minting result:", result);
  
      if (result) {
        // shows an alert indicating that the NFT was successfully minted
        window.alert("Successfully minted!");
      } else {
        console.error("No result from minting");
        window.alert("Minting failed: No result from contract.");
      }
    } catch (error) {
      console.error("Minting error:", error);
      // shows an alert indicating that the NFT could not be minted
      window.alert(`Could not mint NFT :( ${error.message}`);
    }
  
    // set isLoading to false
    setIsLoading(false);
  };

  return (
    <main
      className={
        courier.className +
        " flex text-white min-h-screen flex-col items-center justify-center p-24 bg-gray-900"
      }
    >
      <div className="flex w-full">
        <div className="flex flex-col gap-2  w-[60%]">
          <h1 className={"text-4xl"}> Welcome to LW3Punks</h1>
          <h2 className={"text-lg"}>
            It is an NFT collection for LearnWeb3 students.
          </h2>

          <div>
            {/* numOfTokensMinted is of type BigInt and needs to be converted to integer */}
            {numOfTokensMinted != undefined ? parseInt(numOfTokensMinted) : ""}
            /10 have been minted
          </div>

          <div className="mt-1">
            {account ? (
              // if the user has connected their wallet
              <button
                className="bg-blue-500 px-4 py-2 font-sans rounded-md disabled:cursor-not-allowed disabled:bg-blue-900"
                disabled={isLoading}
                onClick={mintToken}
              >
                {isLoading ? "Loading..." : "Mint!"}
              </button>
            ) : (
              //if the user hasn't connected their wallet
              <ConnectButton />
            )}
          </div>
        </div>

        <div className="flex border-2 w-[40%]">
          <Image
            src="/learnweb3punks.png"
            alt="Learn Web3 Punks"
            width={500}  // adjust width as needed
            height={500} // adjust height as needed
            priority={true} // optional: loads the image faster
          />
        </div>
      </div>

      <footer className="absolute bottom-0 w-full text-center mb-4 tracking-wider">
        Made with &#10084; by LW3Punks
      </footer>
    </main>
  );
}
