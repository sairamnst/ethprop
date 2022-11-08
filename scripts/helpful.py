from brownie import config, accounts, network
import yaml
import json
import os
import shutil


def get_account():
    dev = network.show_active()
    if dev in ["mainnet-fork-ganache", "developments"]:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def update_front_end():
    with open("./brownie-config.yaml") as brownie_config:
        config_dict = yaml.load(brownie_config, Loader=yaml.FullLoader)
        with open("./front_end/src/brownie-config.json", "w") as json_config:
            json.dump(config_dict, json_config)

    copy_build_to_front_end("./build", "./front_end/src/chain-info")


def copy_build_to_front_end(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)
