require('dotenv').config()
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  contracts_build_directory: "./client/src/build",
  networks: {
    development: {
     host: "127.0.0.1",
     port: 7545,
     network_id: "*",
    },

    rinkeby: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, "wss://rinkeby.infura.io/ws/v3/de941405831444d594597bdbdd2e0381")
      },
      network_id: 4,
      websockets: true,
    },
  },

  mocha: {
  },

  compilers: {
    solc: {
      version: "0.7.4",
    }
  },

  db: {
    enabled: false
  }
};
