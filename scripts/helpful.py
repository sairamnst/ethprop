from brownie import config, accounts, network


def get_account():
    dev = network.show_active()
    if dev in ["mainnet-fork-ganache", "developments"]:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])
