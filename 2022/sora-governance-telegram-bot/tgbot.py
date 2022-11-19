# SORA TELEGRAM DEMOCRACY BOT
# built using https://python-telegram-bot.org/
# https://github.com/python-telegram-bot/python-telegram-bot

import os
import logging
from urllib import request
import asyncio
from substrateinterface import SubstrateInterface
from scalecodec.type_registry import load_type_registry_file
from scalecodec.base import ScaleBytes, RuntimeConfigurationObject
from telegram import ParseMode
import json
from telegram.ext import Updater, MessageHandler, Filters

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

# Grab whitelist.json
URL = 'https://raw.githubusercontent.com/sora-xor/polkaswap-token-whitelist-config/master/whitelist.json'
response = request.urlopen(URL)
whitelist = json.loads(response.read())

# Grab custom_types.json and write to file (load_type_registry_file only reads local files for some reason)
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

#testnet and mainnet
RPC_NET = os.environ['RPC_NET']
if RPC_NET == "mainnet":    #set to mainnet
    RPC_NET = 'wss://mof2.sora.org'
else:
    RPC_NET = 'wss://ws.stage.sora2.soramitsu.co.jp'    #set to testnet for any other input

# Setup Substrate
substrate = SubstrateInterface(
    url=RPC_NET,
    ss58_format=69,
    type_registry_preset='default',
    type_registry=load_type_registry_file('./custom_types.json'),
)

# Create subscription_handler to grab block at finalization
def subscription_handler(obj, update_nr, subscription_handler):
    if update_nr == 1:  # required to get finalized block
        return obj['header']['number']


# Get recent block hash
def grab_updated_block_hash():
    # Set block_hash to None for chaintip
    current_block = substrate.subscribe_block_headers(subscription_handler, include_author=True, finalized_only=True)
    current_block_hash = substrate.get_block_hash(current_block)
    print(current_block_hash)
    # Retrieve extrinsics in block
    result = substrate.get_block(block_hash=current_block_hash)
    return result


# Get keys and values from call
def get_info(decoded):
    info = {}

    call_arguments = decoded['call_args']

    for i in range(len(call_arguments)):
        info.update({call_arguments[i]['name']: call_arguments[i]['value']})

    # Append each argument onto a separate line
    msg = []
    for (key, value) in info.items():
        if key != "amount":
            msg.append(str("{0}: <pre language='c++'>{1}</pre>".format(key, value)))
        if key == "asset_id" or key == "currency_id":
            msg.append("currency: <pre language='c++'>" + (get_currency(decoded) + "</pre>"))
        if key == "amount":
            value = get_amount(decoded)
            msg.append(str("{0}: <pre language='c++'>{1}</pre>".format(key, value)))
    msg = '\n'.join(msg)
    return msg


# Get amount after decimal conversion
def get_amount(decoded):
    call_arguments = decoded['call_args']
    for i in range(len(call_arguments)):
        if call_arguments[i]['name'] == "amount":
            address = get_address(decoded)
            for j in range(len(whitelist)):
                if address in whitelist[j].values():
                    precision_of_token = whitelist[j]['decimals']
                    amount = call_arguments[i]['value'] / 10 ** precision_of_token
                    return amount


# Get currency symbol
def get_currency(decoded):
    call_arguments = decoded['call_args']
    for i in range(len(call_arguments)):
        if 'currency_id' in call_arguments[i].values():
            for j in range(len(whitelist)):
                if whitelist[j]['address'] == call_arguments[i]['value']:
                    currency = whitelist[j]['symbol']
                    return currency


def get_address(decoded):
    call_arguments = decoded['call_args']
    for i in range(len(call_arguments)):
        if call_arguments[i]['name'] == 'currency_id':
            currency_address = call_arguments[i]['value']
            return currency_address


# Create runtime_config
runtime_config = RuntimeConfigurationObject()


# Print messages
def print_statement(result, dp):

    for extrinsic in result['extrinsics']:
        call_function = extrinsic.value["call"]["call_function"]
        call_arguments = extrinsic.value["call"]["call_args"]
        if call_function == 'note_preimage' or call_function == 'propose':
            if call_function == 'note_preimage':
                encoded = call_arguments[0]["value"]
                decoded = substrate.decode_scale('Call', ScaleBytes(encoded))
                arguments = get_info(decoded)
                dp.bot.send_message("@sora_tracker",
                    "<b>⚠ New Preimage Submitted ⚠</b>\n<b>------------------------------------------------</b>\n<b>Subscan:</b> <a href='https://sora.subscan.io/extrinsic/{}'>Link</a>\n\n<b>Event Information:</b> \n{}.{}\n\n<b>Arguments:</b>\n{}\n\n<b>Details:</b> <a href='https://polkadot.js.org/apps/?rpc={}#/extrinsics/decode/{}'>Link</a>".format(
                        extrinsic.value["extrinsic_hash"],
                        decoded['call_module'],
                        decoded['call_function'],
                        arguments,
                        RPC_NET,
                        encoded
                    ), parse_mode=ParseMode.HTML, disable_web_page_preview=True)

            # Print statement for proposal submissions
            if call_function == 'propose':
                callinfo = substrate.query('Democracy', 'Preimages', [call_arguments[0]["value"]])
                decoded = substrate.decode_scale('Call', ScaleBytes(str(callinfo[1]['data'])))
                arguments = get_info(decoded)
                dp.bot.send_message("@sora_tracker",
                    "<b>⚠ New <u>Proposal</u> Submitted ⚠</b>\n<b>------------------------------------------------</b>\n<b>Subscan:</b> <a href='https://sora.subscan.io/extrinsic/{}'>Link</a>\n\n<b>Event Information:</b> \n{}.{}\n\n<b>Arguments:</b>\n{}\n\n<b>Details:</b> <a href='https://polkadot.js.org/apps/?rpc={}#/extrinsics/decode/{}'>Link</a>".format(
                        extrinsic.value["extrinsic_hash"],
                        decoded['call_module'],
                        decoded['call_function'],
                        arguments,
                        RPC_NET,
                        callinfo[1]['data']
                    ), parse_mode=ParseMode.HTML, disable_web_page_preview=True)

# Start bot
def start(dp):
    while True:
        try:
            result = grab_updated_block_hash()
            print_statement(result, dp)
        except Exception as e:
            print("Failed to send: {}".format(e))

async def main():
    """Start the bot."""
    # Create the Updater and pass it your bot's token.
    # Make sure to set use_context=True to use the new context based callbacks
    updater = Updater(TG_KEY, use_context=True)

    # Get the dispatcher to register handlers
    dp = updater.dispatcher
    dp.add_handler(MessageHandler(Filters.update, start, pass_update_queue=True))
    # Start the Bot
    updater.start_polling()
    start(dp)
    
if __name__ == '__main__':
    TG_KEY = os.environ['TG_API_KEY']
    asyncio.run(main())