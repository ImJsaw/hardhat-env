#deploy
yarn hardhat --network bsc deploy --tags 1123

#verify

yarn hardhat --network bsctest sourcify

npx hardhat verify --network mainnet DEPLOYED_CONTRACT_ADDRESS "Constructor argument 1"

#run script
npx hardhat run --network eth scripts/verifyCore.ts

#test
npx hardhat test

#coverage
npx hardhat coverage

#vyper comflict
npx hardhat clean
npx hardhat compile