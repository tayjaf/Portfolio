# Sora Governance Telegram Bot

This bot posts a message to a telegram channel whenever a preimage or proposal is submitted on the SORA network.

It prints out information (when applicable) as:
- Preimage/Proposal Notification
- Subscan Link to Event
- Event Information
- Arguments in Event
- Details Link to polkadot.js

# Steps to Run:
``` 
Edit RPC node to mainnet or testnet in tgbot.py

docker build . -t  tgbot
docker run -e "TG_API_KEY={TG_KEY}" tgbot

Type /start in the channel to begin polling (feel free to delete msg after) in the channel
```
