from brownie import config, network, accounts, GovtMock, LandContract, NFTMinter
from .helpful import get_account, update_front_end


def main():
    account = get_account()
    if len(GovtMock) == 0:
        govt = GovtMock.deploy(
            config["networks"][network.show_active()]["gasreserve"], {"from": account}
        )
        govt.transfer(100000000000000000)
    update_front_end()
