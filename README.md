# heroypt

dApp that communicates with the SmartContract deployed.

Metamask was used to create a wallet to communicate with the Ethereum blockchain. Now problem comes as we cannot use MainNet for testing or transactions which infact requires little money

We use RinkebyTestNet and use Test Faucet to get some test ethers for somedays using social media.

We can use this ether as gas for transactions we make and to create a contract we use
Solidity

Now the missing link is a server that connects our App and BlockChain.
We can use a local server or we can use
GANACHE or Infuria

# Instructions

Refer constants/keys.dart.

1st ) Add your metamask account Address and Private key from Account details option in the chrome extension
2nd ) Get your deployed address of the smart contract from remix ethereum
3rd ) Get your infuria project url for rinkeby test net

- More detailed Instructions will be provided

# Bugs to Solve

Since the changes the wallet are reflected after sometime, UI needs to be updated using the refresh button. Somehow use of stream needs to be done to update UI as soon as the value is changed in the wallet.
 
# features pending

Sqflite support to store transaction logs is pending.







