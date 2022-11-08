import { useEthers } from "@usedapp/core";

export const Main = () => {
    const { chainId, error } = useEthers();
    const network = chainId;
    console.log(network);

    return (
        <p>{network}</p>
    )
}