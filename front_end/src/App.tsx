import React from 'react';
import logo from './logo.svg';
import './App.css';
import { DAppProvider, ChainId } from "@usedapp/core";
import { Header } from "./components/Header";
import { Main } from "./components/Main";

function App() {
  return (
    <DAppProvider config={{ supportedChains: [ChainId.Goerli, ChainId.Mainnet] }}>
      <Header />
      <Main />
    </DAppProvider>
  );
}

export default App;
