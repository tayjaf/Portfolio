import os
from time import sleep
from SoraClient import SoraClient
from ContractTracker import ContractTracker
from urllib import request


SORAMITSU_ADDRESSES = {"0x1485e9852ac841b52ed44d573036429504f4f602": "Bridge",
                       "0x40fd72257597aa14c7231a7b1aaa29fce868f677": "XOR",
                       "0xe88f8313e61a97cec1871ee37fbbe2a8bf3ed1e4": "VAL",
                       "0xc08edf13be9b9cc584c5da8004ce7e6be63c1316": "Sora: Deployer for XOR",
                       "0xd1eeb2f30016fffd746233ee12c486e7ca8efef1": "Sora: Deployer for VAL"
}

URL = 'https://raw.githubusercontent.com/sora-xor/pricing-server/master/custom_types.json'
BUFFER_SIZE = 8192

u = request.urlopen(URL)
f = open('custom_types.json', 'wb')
while True:
    buffer = u.read(BUFFER_SIZE)
    if not buffer:
        break
    f.write(buffer)
f.close()


if __name__ == "__main__":
    CHAT_ID = os.environ['TG_CHAT_ID']
    TG_KEY = os.environ['TG_API_KEY']
    ETH_KEY = os.environ['ETHERSCAN_API_KEY']
    COVALENT_KEY = os.environ['COVALENT_API_KEY']

    sora_client = SoraClient(tg_chat=CHAT_ID, telegram_key=TG_KEY)

    contracts = []
    for address, name in SORAMITSU_ADDRESSES.items():
        contracts.append(ContractTracker(address, name, covalent_key=COVALENT_KEY, etherscan_key=ETH_KEY,
                                         telegram_key=TG_KEY, tg_chat_id=CHAT_ID, sora_client=sora_client))

    while True:
        for contract in contracts:
            contract.check()

        sora_client.check()
        print("Sleeping for 60 secs...")
        sleep(60)
