from brownie import config, network, accounts, GovtMock, LandContract, NFTMinter
from .helpful import get_account, update_front_end


def main():
    account = get_account()
    if len(GovtMock) == 0:
        GovtMock.deploy(
            config["networks"][network.show_active()]["gasreserve"], {"from": account}
        )
    update_front_end()
