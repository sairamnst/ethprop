import json

from web3 import Web3

# In the video, we forget to `install_solc`
# from solcx import compile_standard
from solcx import compile_standard, install_solc
import os
from dotenv import load_dotenv
from web3.middleware import geth_poa_middleware


def verify_address():
    with open("./build/contracts/GovtMock.json") as abi_file:
        abi = json.load(abi_file)

    load_dotenv()

    w3 = Web3(
        Web3.HTTPProvider(
            "https://goerli.infura.io/v3/20c07747b68346968b281c3091efa984"
        )
    )
    chain_id = 5

    private_key = os.environ["PRIVATE_KEY"]
    address = os.environ["PUBLIC_KEY"]
    govt = os.environ["GOVT_ADDRESS"]
    nonce = w3.eth.getTransactionCount(address)

    govtmock = w3.eth.contract(address=govt, abi=abi)
    txn = govtmock.functions.get_verified().buildTransaction(
        {
            "chainId": chain_id,
            "gasPrice": w3.eth.gas_price,
            "from": address,
            "nonce": nonce,
        }
    )
