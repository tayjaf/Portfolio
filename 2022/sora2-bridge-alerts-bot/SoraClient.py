import requests
import telebot
import base58
from typing import Optional, Union
from hashlib import blake2b
from scalecodec.type_registry import load_type_registry_file
from substrateinterface import SubstrateInterface


TOKENS_BLACKLIST = {
    '0x009749fbd2661866f0151e367365b7c5cc4b2c90070b4f745d0bb84f2ffb3b33': "HuobiToken",
    '0x005e152271f8816d76221c7a0b5c6cafcb54fdfb6954dd8812f0158bfeac900d': "AGI",
    '0x007d998d3d13fbb74078fb58826e3b7bc154004c9cef6f5bccb27da274f02724': 'CHSB',
    '0x00e16b53b05b8a7378f8f3080bef710634f387552b1d1916edc578bda89d49e5': "BAT"

}

DOT_WALLETS_BLACKLIST = ['5EJHfPrm6vHFzZVuELTYqD3rUfkepuPzSoyCPK4dN4w9wW1t',
                     '5DCPS1KWvjUv5sotz4Fc8VonwDQp17NrsBzweeUdgE3FdCA2',
                     '5HCKwN4zx5oXB6RvxDYKq1tBmgNHSu4V8hGBAcvsU9d4J5T4',
                     '5CP58MfUbNJfzetTarkoLiqNY2c8bCqE5Hj1Wy81gi8U1EF2',
                     '5F9d7S3fc2QtV9DMkqaGnLv2t3PkWCSheR5cx1EMZ6tSGyFk',
                     '5G74yPW53rteWvbkyRUP8dg1bngX2PVErudqjtwB2jGbiyyX',
                     '5DaTntmxDYNjgzdYMpEKzW33VQm8G55E6pSZu3w8Fj2GnQ6i',
                     '5FLKdG4y8AT8ZYzqezxuiEH6eLWzuqs4QhA187P7Xg6PCUsD',
                     '5C81CY8iVLqH6TK6aKuvqQkLtvrVxcjMXT5ESCXVLwXMqFNQ',
                     '5DoYUNN23Ldqo5DCatkgTVE7qfhJgCT4fPPiQu3iTBsgqHmB',
                     '5H6jCGHrnz18f8Mz3xnpTQ6KwfoEdNHXaoKd5FmLVciJGY7r',
                     '5FEJpEfH19uVkgQMMbcyzkndUbcbyLcyBCjk8sekW2s3YAxi',
                     '5Dsd1mYhcMPY33TYEes3mmsFpV9HPhWrhV3jdpwXqHdGzJ4R',
                     '5F1DsofkDLLYYxhSAGPHgwVoxsxdMsgEBdnYgKtTKxnXQFwv',
                     '5D8KnghnbbZQwtRia7rinSYQAUdXGeKgKf14DvGge1yDojua',
                     '5CoDeChJdNcwGjsNJNJcC4CWRUAHdkQpwLdiVL4Ba6uZ3s2b',
                     '5Ecnrjowpw1ynHXN3Kswd5Qh3gU8dUFEooPx9tREfq3eDPQJ',
                     '5HYLyvnA94YQPYn8bfLa3tBrboDakRT5VgMF1godCGEcb8yX',
                     '5ChZxeHXRkijv61C5ottArJt46GwJ4EzJyWGLmERaiBZrpME',
                     '5HTk6ypN3UzrAUgEdAwTKizrfMYsBfF4Uf6rvLNFiwGGJyLP',
                     '5EWtrCDSyFk71FCuxeDNVLnQsSpyyZE2uoZRoWXN2ovPexn6',
                     '5Cw6K3mQyh6Te7jfnNMAx2RqgFuFuBnxXFAR9Fo8ii8sknpo',
                     '5CUKnuisLgkEwGYSYQM72ir1enP6TwRVpGnB4UvCWwX4XW4k',
                     '5CXvjtUv54DM4Ko3ZAEuHHukr66LaqKMPpouDQRBAUzNd8AC',
                     '5DAkypZDFZy9WiXaFDhpqXcU1mweSkKErbXKTuPoxGERFFnw',
                     '5Dnd47D6nqG6XevP68ub4BqeJJ6szmXyMDKSAxXwR5T6Yyx7',
                     '5Ec8LgaGS7FjD3wrbge2oaX3bswpf4Qfiuoi9jJyMvVWEDHE',
                     '5EWoiFV79xuYjY4jeCCdH14n2smZokDUAFVyzh15cBHZbVUh',
                     '5DCGhSPs4BLd4GjXQFNVTTTbpMFiA79ZyuAVk5wJ5tHHALY3',
                     '5EP8K1ATaWETkfMYo4tr3bsiFqVhqXp86uxEuZwEgAnvJFwf',
                     '5HGL3VjeaFkConu1BENNULzeRRrXQhUxYDQ57LX8kmp3h25H',
                     '5EUzaMEcJX7Y7bajME8VVcGvNGUWEmou5sSKmDJhqGariL6B',
                     '5HjSMpXGo1cAsRx6YD4Zt1GENagT7S282wb2Q5TvNV3nTenF',
                     '5EvwoB3Uea76Mu4vmvkxP8ViVWUJ77jNJuMNZrNVkfTnLCpq',
                     '5C5EPStkLAjJF3bQexg3A8Hb689mPAbNBDTe7nZmjCgN5zLo',
                     '5ECeRHi4qXGNqvPYPT3i1YxM3TnHif8N7dxNEnkqQjb5sS5z',
                     '5Cvxdp5XVgoMqFWt8VJaWuZjqHdbz1R5gGmEbPef9eVVkLfH',
                     '5CyUX3rwcsJY2v1hfiXjnmT3bf4wPe51DnrmbU9ESdarEjpW',
                     '5H5zd4WSeCoGNB1nJncjH7KNqzNrScDhXDSUkCw3PjgtJLWy',
                     '5EHHKmBa7wK4zh2Cfvbv6jtMtjUDsUMdM41qTAe6Hy8shCWq',
                     '5GqJKM56pKquSH82G9ZsqiNsYk3RpHEhbVbYQScQNcSkQjsM',
                     '5D2zA4WwDZgNWZwNitNLgkgcsMRAGXeFSJ9qespDjVTMP5z8',
                     '5EqoPW4aXACLbtoNQqPcoXextTxZncnx4HYGZFBen1qr4KoU',
                     '5DwGbEWxB8x7zerspSbT2TJan6F4RLWSwAd5kQPjfYUWJnQs',
                     '5G6doJbNk2LdXoxnvABxN2dLEC2yeYknwn8Td9T9fk8dCjKF',
                     '5Dw8FTrcxVUEjZRq5fWH2WqGFcU2vnviWczBRffL2bFJ4BZK',
                     '5GjKatsRKPzicNnvMP1WsiHCQ8keEiVbN5Ns7Rny1ZKiuQzT',
                     '5FHxDcSPoUALmJnmgGMLrfoGbvZmhdTZkBwhZmHd87UDPVGc',
                     '5DkqCFqJeMitUkJX8EtHVFtjh7PP2Hf4JNTE16TyqJq4oRZf',
                     '5FYfdEzdJSe3TrkNCPBynoeWurHcRm7NCA3R7t6U9wWoUdZR',
]


def ss58_decode(address: str, valid_ss58_format: Optional[int] = None) -> str:
    """
    Decodes given SS58 encoded address to an account ID
    Parameters
    ----------
    address: e.g. EaG2CRhJWPb7qmdcJvy3LiWdh26Jreu9Dx6R1rXxPmYXoDk
    valid_ss58_format
    Returns
    -------
    Decoded string AccountId
    """

    # Check if address is already decoded
    if address.startswith('0x'):
        return address

    if address == '':
        raise ValueError("Empty address provided")

    checksum_prefix = b'SS58PRE'

    address_decoded = base58.b58decode(address)

    if address_decoded[0] & 0b0100_0000:
        ss58_format_length = 2
        ss58_format = ((address_decoded[0] & 0b0011_1111) << 2) | (address_decoded[1] >> 6) | \
                      ((address_decoded[1] & 0b0011_1111) << 8)
    else:
        ss58_format_length = 1
        ss58_format = address_decoded[0]

    if ss58_format in [46, 47]:
        raise ValueError(f"{ss58_format} is a reserved SS58 format")

    if valid_ss58_format is not None and ss58_format != valid_ss58_format:
        raise ValueError("Invalid SS58 format")

    # Determine checksum length according to length of address string
    if len(address_decoded) in [3, 4, 6, 10]:
        checksum_length = 1
    elif len(address_decoded) in [5, 7, 11, 34 + ss58_format_length, 35 + ss58_format_length]:
        checksum_length = 2
    elif len(address_decoded) in [8, 12]:
        checksum_length = 3
    elif len(address_decoded) in [9, 13]:
        checksum_length = 4
    elif len(address_decoded) in [14]:
        checksum_length = 5
    elif len(address_decoded) in [15]:
        checksum_length = 6
    elif len(address_decoded) in [16]:
        checksum_length = 7
    elif len(address_decoded) in [17]:
        checksum_length = 8
    else:
        raise ValueError("Invalid address length")

    checksum = blake2b(checksum_prefix + address_decoded[0:-checksum_length]).digest()

    if checksum[0:checksum_length] != address_decoded[-checksum_length:]:
        raise ValueError("Invalid checksum")

    return address_decoded[ss58_format_length:len(address_decoded)-checksum_length].hex()


def ss58_encode(address: Union[str, bytes], ss58_format: int = 42) -> str:
    """
    Encodes an account ID to an Substrate address according to provided address_type
    Parameters
    ----------
    address
    ss58_format
    Returns
    -------
    """
    checksum_prefix = b'SS58PRE'

    if ss58_format < 0 or ss58_format > 16383 or ss58_format in [46, 47]:
        raise ValueError("Invalid value for ss58_format")

    if type(address) is bytes or type(address) is bytearray:
        address_bytes = address
    else:
        address_bytes = bytes.fromhex(address.replace('0x', ''))

    if len(address_bytes) in [32, 33]:
        # Checksum size is 2 bytes for public key
        checksum_length = 2
    elif len(address_bytes) in [1, 2, 4, 8]:
        # Checksum size is 1 byte for account index
        checksum_length = 1
    else:
        raise ValueError("Invalid length for address")

    if ss58_format < 64:
        ss58_format_bytes = bytes([ss58_format])
    else:
        ss58_format_bytes = bytes([
            ((ss58_format & 0b0000_0000_1111_1100) >> 2) | 0b0100_0000,
            (ss58_format >> 8) | ((ss58_format & 0b0000_0000_0000_0011) << 6)
        ])

    input_bytes = ss58_format_bytes + address_bytes
    checksum = blake2b(checksum_prefix + input_bytes).digest()

    return base58.b58encode(input_bytes + checksum[:checksum_length]).decode()


SORA_WALLETS_BLACKLIST = [ss58_encode(ss58_decode(x), 69) for x in DOT_WALLETS_BLACKLIST]


class SoraClient:
    def __init__(self, telegram_key, tg_chat):
        self.bot = telebot.TeleBot(telegram_key)
        self.tg_chat = tg_chat

        self.substrate = None
        self.update_websocket()

        self.data = []
        self.assets = {}
        self.new_check = False

        self.low_block = None
        self.low_block_events = None

    def update_websocket(self):
        self.substrate = SubstrateInterface(
            url='wss://mof3.sora.org/',
            type_registry_preset='default',
            type_registry=load_type_registry_file('./custom_types.json'))

    def add_data(self, new_data):
        self.data.append(new_data.lower())
        self.new_check = True

    def get_whitelisted_assets(self):
        assets = requests.get("https://raw.githubusercontent.com/sora-xor/polkaswap-token-whitelist-config/master/whitelist.json").json()
        for x in assets:
            self.assets[x['address']] = {'name': x['name'], 'symbol': x['symbol'], 'precision': x['decimals']}

    def get_balances(self):
        self.update_websocket()
        self.get_whitelisted_assets()
        for x in list(self.substrate.query_map("Tokens", "TotalIssuance")):
            asset_id = str(x[0])
            total_issuance = int(x[1].value)
            try:
                self.assets[asset_id]['balance'] = total_issuance / 10**self.assets[asset_id]['precision']
            except Exception:
                continue

        return self.assets

    def get_last_events(self):
        self.update_websocket()  # without update socket is closing
        block_data = self.substrate.get_block_header(finalized_only=True)['header']
        top_block = block_data['number']
        if not self.low_block_events:
            delta = 300
        else:
            delta = top_block - self.low_block_events

        results = []
        print(top_block, self.low_block_events)
        for block_i in range(0, delta):
            block_number = top_block - block_i
            block = self.substrate.get_block_header(block_number=block_number)['header']
            block_hash = block['hash']
            events = self.substrate.get_events(block_hash)
            for x in events:
                event = x.serialize()
                event['block'] = block_number
                results.append(event)

        self.low_block_events = top_block
        return results

    def get_last_extrinsics(self):
        self.update_websocket()  # without update socket is closing
        block_data = self.substrate.get_block_header(finalized_only=True)['header']
        top_block = block_data['number']
        result = []

        if not self.low_block or self.new_check:
            delta = 300
            self.new_check = False
        else:
            delta = top_block - self.low_block

        print(top_block, self.low_block)
        for block_i in range(0, delta):
            extrinsics = self.substrate.get_block(block_number=top_block - block_i)['extrinsics']
            for extrinsic in extrinsics:
                result.append(extrinsic)

        self.low_block = top_block
        return result

    def get_last_bridge_extrinsics(self):
        extrinsics = self.get_last_extrinsics()
        bridge_extrinsics = []
        for extrinsic in extrinsics:
            if extrinsic['call']['call_module']['name'] == 'EthBridge':
                bridge_extrinsics.append(extrinsic.value)
        return bridge_extrinsics

    def check_blacklisted_tokens(self, extrinsics):
        for extr in extrinsics:
            for asset_id in TOKENS_BLACKLIST.keys():
                if asset_id.lower() in str(extr).lower():
                    self.send_alert(f"Transaction in Sora:\n https://sora.subscan.io/extrinsic/{extr}")

    def check_blacklisted_wallets(self, extrinsics):
        for extr in extrinsics:
            extr_json = extr.serialize()
            extr_hash = extr_json['extrinsic_hash']
            wallet = extr_json.get('address', '')[2:]
            for x in SORA_WALLETS_BLACKLIST:
                if wallet.lower() == x.lower():
                    self.send_alert(f"Alert from dumper Acct: {ss58_encode(ss58_decode(wallet))}\n\nSora Address: {wallet}\n\nTransaction in Sora:https://sora.subscan.io/extrinsic/{extr_hash}")

    def check_extrinsics_info(self, extrinsics):
        if not self.data:
            print("No data to check...")
            return None

        print("Checking extrinsics...")
        for extr in extrinsics:
            for pattern in self.data:
                if pattern in str(extr).lower():
                    self.send_alert(f"Transaction in Sora:\n https://sora.subscan.io/extrinsic/{extr.value['extrinsic_hash']}")

        return None

    def check_failed_events(self):
        events = self.get_last_events()
        skip_fails = [[25, 37], [25, 6], [25, 59], [25, 22], [25, 57], [25, 48], [26, 6], [2, 1], [18, 0], [10, 20], [27, 2], [27, 4], [29, 1], [50, 7], [50, 8], [50, 10]]
        for event in events:
            if event['event']['event_id'] == "ExtrinsicFailed":
                print(event)
                module = event['event']['attributes'][0]['value']['Module']

                skip_flag = False
                for skip in skip_fails:
                    if skip[0] == module['index'] and skip[1] == module['error']:
                        print("Skipping alert of this event...")
                        skip_flag = True

                if not skip_flag:
                    self.send_alert(f"Failed Extrinsic in block:\nhttps://sora.subscan.io/block/{event['block']}")

    def check(self):
        extrinsics = self.get_last_extrinsics()
        self.check_blacklisted_tokens(extrinsics)
        self.check_blacklisted_wallets(extrinsics)
        self.check_extrinsics_info(extrinsics)

        self.check_failed_events()

    def send_alert(self, message):
        self.bot.send_message(self.tg_chat, message)


if __name__ == "__main__":
    # address = "5EJHfPrm6vHFzZVuELTYqD3rUfkepuPzSoyCPK4dN4w9wW1t"
    # print(f"Input: {address}")
    # k = ss58_decode(address)
    # print(f"Output: {k}")
    # print(ss58_encode(k, 69))
    import os
    CHAT_ID = os.environ['TG_CHAT_ID']
    TG_KEY = os.environ['TG_API_KEY']
    test = SoraClient(telegram_key=TG_KEY, tg_chat=CHAT_ID)
    test.check()
