{ dappPkgs ? (
    import (fetchGit "https://github.com/makerdao/makerpkgs") {}
  ).dappPkgsVersions.seth-0_8_4
}:

with dappPkgs;

let
  dapp' = dapp.override {
    solc = solc-versions.solc_0_5_12;
  };
in mkShell {
  buildInputs = [ dapp' ];
}
