#Description.

wallet.sh (./wallet.sh)

This script is suitable for quick deployment of a wallet from scratch. Performing the necessary actions before receiving tokens and after.

The process takes about a minute (not counting the waiting time for tokens for Step2) and you will receive a ready-made wallet.

The script automatically performs all the necessary actions with the wallet, you only need to get tokens.

1. Download used files.
2. Unzip and create folders.
3. Actions with the wallet.
4. Saving keys and logs.
5. Creating the hostname.addr and msig.keys.json files that are needed for the node to work.
6. Create a wallet link (ton.live).
7. Performing a test transaction for 5 tokens (5,000,000,000) to the address -1: 2e66c896772a6a936d4077ca3472af27bc80bb307b920c8d87b48e6bd066c46d

Step 1 - Perform the initial operations before receiving the raw address.

Next, you need to get tokens.

For convenience, you can use the balance check.

Step 2 requires a positive balance!

Step 2 - The rest of the wallet.

The scripts are raw, use strictly in the order: D

sw.sh (./sw.sh)

Small wallet to simplify the sending of tokens.

Current Functions:
1. Balance check
2. Sending tokens (the number of tokens and the address are indicated in the pop-up windows)
3. Link to account (ton.live)
 
Uses the files created by wallet.sh:

/ tonos-cli / tonos-cli

/tonos-cli/SafeMultisigWallet.abi.json

/tonos-cli/data/rawaddr.txt - your raw address

/tonos-cli/data/phrase.txt - your seed phrase

It is better to run scripts from the root directory, first allow the execution of chmod + x wallet.sh and chmod + x sw.sh

Everything was done quickly, there may be errors, check the log files

Tested on Ubuntu 18.04
