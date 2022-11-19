# Bridge Alert Bot
This bot tracks unusual transaction to Soramitsu Eth contracts.

It checks users for:
- deployment of contracts
- using Tornado.Cash

## How to run
```bash
docker build . -t bridgebot
docker run -e "TG_API_KEY={TG_KEY}" -e "TG_CHAT_ID={CHAT_ID}" -e "ETHERSCAN_API_KEY={ETHERSCAN_KEY}" -d bridgebot
```