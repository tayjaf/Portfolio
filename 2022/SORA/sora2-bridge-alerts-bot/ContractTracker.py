import telebot
from datetime import datetime, timedelta
from etherscan import Etherscan
import requests
import json


TOKENS_BLACKLIST = {
    '0x6f259637dcd74c767781e37bc6133cd6a68aa161': "HuobiToken",  # Sora 0x009749fbd2661866f0151e367365b7c5cc4b2c90070b4f745d0bb84f2ffb3b33
    '0x8eb24319393716668d768dcec29356ae9cffe285': "AGI",  # Sora 0x005e152271f8816d76221c7a0b5c6cafcb54fdfb6954dd8812f0158bfeac900d
    '0xba9d4199fab4f26efe3551d490e3821486f135ba': 'CHSB',  # 0x007d998d3d13fbb74078fb58826e3b7bc154004c9cef6f5bccb27da274f02724
    '0x0d8775f648430679a709e98d2b0cb6250d2887ef': "BAT",  # 0x00e16b53b05b8a7378f8f3080bef710634f387552b1d1916edc578bda89d49e5

}


TORNADO_CASH_ADDRESSES = ['0x12d66f87a04a9e220743712ce6d9bb1b5616b8fc',  # Tornado.Cash: 0.1 ETH
                          '0xd90e2f925da726b50c4ed8d0fb90ad053324f31b',  # Tornado.Cash Router
                          '0x910cbd523d972eb0a6f4cae4618ad62622b39dbf',  # Tornado.Cash: 10 ETH
                          '0x722122df12d4e14e13ac3b6895a86e84145b6967',  # Tornado.Cash: Proxy
                          '0x47ce0c6ed5b0ce3d3a51fdb1c52dc66a7c3c2936',  # Tornado.Cash: 1 ETH
                          '0xa160cdab225685da1d56aa342ad8841c3b53f291',  # Tornado.Cash: 100 ETH
                          '0x07687e702b410fa43f4cb4af7fa097918ffd2730',  # Tornado.Cash: 10,000 DAI 2
                          '0x23773e65ed146a459791799d01336db287f25334',  # Tornado.Cash: 100,000 DAI
                          '0x4736dcf1b7a3d580672cce6e7c65cd5cc9cfba9d',  # Tornado.Cash: 1,00 USDC
                          '0xd96f2b1c14db8458374d9aca76e26c3d18364307',  # Tornado.Cash: 1,000 USDC
                          '0xbb93e510bbcd0b7beb5a853875f9ec60275cf498',  # Tornado.Cash: 10 WBTC
                          '0xfd8610d20aa15b7b2e3be39b396a1bc3516c7144',  # Tornado.Cash: 1,000 DAI
                          '0x169ad27a470d064dede56a2d3ff727986b15d52b',  # Tornado.Cash: 100 USDT
                          '0xd4b88df4d29f5cedd6857912842cff3b20c8cfa3',  # Tornado.Cash: 100 DAI
                          '0x610b717796ad172b316836ac95a2ffad065ceab4',  # Tornado.Cash: 1 WBTC
                          '0x0836222f2b2b24a3f36f98668ed8f0b38d1a872f',  # Tornado.Cash: 1,000 USDT

                          ]


class User:
    def __init__(self, address, eth):
        self.eth = eth
        self.address = address
        self.trx = []
        self.internal_trx = []

    def get_normal_trx(self, days=2):
        days_ago = (datetime.today() - timedelta(days=days))
        timestamp = int(datetime.timestamp(days_ago))
        try:
            block_number = self.eth.get_block_number_by_timestamp(timestamp=timestamp, closest='before')
            data = self.eth.get_normal_txs_by_address_paginated(address=self.address, sort='desc', startblock=block_number,
                                                           endblock=999999999999, page=0, offset=0)
            return data
        except Exception as err:
            print(err)
            return []

    def get_internal_trx(self, days=2):
        days_ago = (datetime.today() - timedelta(days=days))
        timestamp = int(datetime.timestamp(days_ago))
        try:
            block_number = self.eth.get_block_number_by_timestamp(timestamp=timestamp, closest='before')
            data = self.eth.get_internal_txs_by_address_paginated(address=self.address, sort='desc', startblock=block_number,
                                                             endblock=999999999999, page=0, offset=0)
            return data
        except Exception as err:
            print(err)
            return []

    def search_tornado(self):
        for trx_info in self.trx:
            from_address = trx_info['from']
            to_address = trx_info['to']
            tx = trx_info['hash']
            if from_address.lower() in TORNADO_CASH_ADDRESSES or to_address.lower() in TORNADO_CASH_ADDRESSES:
                print(trx_info)
                return tx

        for trx_info in self.internal_trx:
            from_address = trx_info['from']
            to_address = trx_info['to']
            tx = trx_info['hash']
            if from_address.lower() in TORNADO_CASH_ADDRESSES or to_address.lower() in TORNADO_CASH_ADDRESSES:
                print(trx_info)
                return tx

        return None

    def search_contract_creation(self):
        for trx_info in self.trx:
            to_address = trx_info['to']
            contract = trx_info['contractAddress']
            if not to_address:
                print(trx_info)
                return contract
        else:
            return None

    def check_trx(self, days=3):
        self.trx = self.get_normal_trx(days=days)
        self.internal_trx = self.get_internal_trx(days=days)
        trx = self.search_tornado()
        if trx:
            return trx, 'used Tornado'

        trx = self.search_contract_creation()
        if trx:
            return trx, 'made a Contract'

        return False, None


class ContractTracker:
    def __init__(self, address, name, covalent_key, etherscan_key, telegram_key, tg_chat_id, sora_client=None, days=0):
        self.address = address
        self.name = name
        self.gaps = {}
        self.covalent_key = covalent_key
        self.eth = Etherscan(etherscan_key)
        self.bot = telebot.TeleBot(telegram_key)
        self.tg_chat = tg_chat_id

        days_ago = (datetime.now() - timedelta(days=days))
        timestamp = int(datetime.timestamp(days_ago))

        self.top_block_normal = int(self.eth.get_block_number_by_timestamp(timestamp=timestamp, closest='before'))
        self.top_block_internal = self.top_block_normal
        self.top_block_erc = self.top_block_normal

        self.next_balance_update_at = None

        if sora_client:
            self.sora_client = sora_client
        else:
            self.sora_client = None

    def get_assets_balances(self):
        result = {}

        url = f"https://api.covalenthq.com/v1/1/address/{self.address}/balances_v2/?key={self.covalent_key}"
        eth_assets = json.loads(requests.get(url).text)
        update_date = datetime.strptime(eth_assets['data']['updated_at'].split('.')[0], "%Y-%m-%dT%H:%M:%S")
        next_update = datetime.strptime(eth_assets['data']['next_update_at'].split('.')[0], "%Y-%m-%dT%H:%M:%S")
        self.next_balance_update_at = next_update
        print(update_date, next_update)
        for token in eth_assets['data']['items']:
            symbol = token['contract_ticker_symbol']
            eth_balance = int(token['balance']) / 10 ** int(token['contract_decimals'])
            if eth_balance:
                result[symbol] = eth_balance

        return result

    def analyze_gaps(self):
        if self.next_balance_update_at:
            now = datetime.utcnow()
            if now < self.next_balance_update_at:
                print(f"Balance not updated, skipping gaps analyze...\nNext update at {self.next_balance_update_at}")
                return

        print("Cheking gaps...")
        eth_assets_balances = self.get_assets_balances()
        sora_assets_balances = self.sora_client.get_balances()
        for symbol, eth_balance in eth_assets_balances.items():
            last, last_id = None, None
            for asset_id, asset in sora_assets_balances.items():
                if asset['symbol'] == symbol:
                    last_id, last = asset_id, asset
            if last:
                sora_balance = last.get('balance', 0)
                gap = eth_balance - sora_balance

                if self.gaps.get(symbol, None):
                    if self.gaps[symbol] != gap and abs(abs(self.gaps[symbol]) - abs(gap)) >= abs(gap * 0.05): # Disable alerts with <= 5% changes
                        message = f"Alert in contract {self.name}.\n\nGap changed in token {symbol}.\n\nLast gap:{self.gaps[symbol]}\n\nNew gap:{gap}"
                        self.send_alert(message)
                self.gaps[symbol] = gap

    def get_normal_trx(self):
        try:
            contract_trx = self.eth.get_normal_txs_by_address_paginated(address=self.address, sort='desc',
                                                                 startblock=self.top_block_normal + 1, endblock=999999999999,
                                                                 page=0, offset=0)
            self.top_block_normal = int(contract_trx[0]['blockNumber'])
            return contract_trx
        except Exception as err:
            print(err)
            print(f"No new normal trx in contract {self.name}...")
            return []

    def get_internal_trx(self):
        try:
            contract_internal_trx = self.eth.get_internal_txs_by_address_paginated(address=self.address, sort='desc',
                                                                            startblock=self.top_block_internal + 1,
                                                                            endblock=999999999999,
                                                                            page=0, offset=0)
            self.top_block_internal = int(contract_internal_trx[0]['blockNumber'])
            return contract_internal_trx
        except Exception as err:
            print(err)
            print(f"No new internal trx in contract {self.name}...")
            return []

    def get_erc20_trx(self):
        try:
            internal_trx = self.eth.get_erc20_token_transfer_events_by_address(address=self.address, sort='desc', startblock=self.top_block_erc + 1,
                                                             endblock=999999999999)
            self.top_block_erc = int(internal_trx[0]['blockNumber'])
            return internal_trx
        except Exception as err:
            print(err)
            print(f"No new erc20 trx in contract {self.name}...")
            return []

    def analyse_erc20_trx(self, transactions):
        for trx in transactions:
            if trx['from'] != self.address:
                user_address = trx['from']
            else:
                user_address = trx['to']
            hash = trx['hash']
            contract = trx['contractAddress']
            if contract in TOKENS_BLACKLIST:
                message = f"Alert in contract {self.name}.\n\nUser used Blacklisted Token: {TOKENS_BLACKLIST[contract]}\n\nTransaction: https://etherscan.io/tx/{hash}\n\nUser account: https://etherscan.io/address/{user_address}\n\n"
                self.send_alert(message)

    def analyse_user_actions(self, transactions):
        for tx_info in transactions:
            if tx_info['from'] != self.address:
                user_address = tx_info['from']
            else:
                user_address = tx_info['to']

            tx = tx_info['hash']
            print(f"Checking transaction {tx} in contract {self.name}...\n")
            result, status = User(user_address, self.eth).check_trx()

            if result:
                self.sora_client.add_data(tx)

                if status == 'made a Contract':
                    self.sora_client.add_data(result)

                print(status)
                print(f"https://etherscan.io/tx/{tx}")
                message = f"Alert in contract {self.name}.\n\nUser {status}\n\nTransaction: https://etherscan.io/tx/{tx}\n\nUser account: https://etherscan.io/address/{user_address}\n\n"
                self.send_alert(message)

    def analyse_failed_trx(self, transactions):
        for trx in transactions:
            if trx.get('isError', None) == '1':
                hash = trx['hash']
                trx_result = self.eth.get_contract_execution_status(txhash=hash)
                err_description = trx_result['errDescription']
                if err_description != "Out of gas":
                    self.send_alert(f"Alert in contract {self.name}.\n\nTransaction: https://etherscan.io/tx/{hash}\n\nError Description: {err_description}")

    def send_alert(self, message):
        self.bot.send_message(self.tg_chat, message)

    def check(self):
        print(f"Cheking from blocks: {self.top_block_normal, self.top_block_internal, self.top_block_erc}")
        normal_trxs = self.get_normal_trx()
        self.analyse_user_actions(normal_trxs)
        self.analyse_failed_trx(normal_trxs)

        internal_trxs = self.get_internal_trx()
        internal_trxs = [x for x in internal_trxs if x['hash'] not in [y['hash'] for y in normal_trxs]]  # remove duplicates
        self.analyse_user_actions(internal_trxs)
        self.analyse_failed_trx(internal_trxs)

        erc_trxs = self.get_erc20_trx()
        self.analyse_erc20_trx(erc_trxs)
        self.analyse_failed_trx(erc_trxs)

        if self.name == 'Bridge':
            self.analyze_gaps()
