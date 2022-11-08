from brownie import config, network, accounts, GovtMock, LandContract, NFTMinter
from .helpful import get_account, update_front_end


def main():
    account = get_account()
    tmp = accounts.add("0xDF657F101E588A4348e74a8Af1411b44c1C8132b")
    print(tmp.balance())
    if len(GovtMock) == 0:
        govt = GovtMock.deploy(
            config["networks"][network.show_active()]["gasreserve"], {"from": account}
        )
        account.transfer(govt, 10**17)
