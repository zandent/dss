with import (fetchGit "https://github.com/makerdao/makerpkgs") {};

with dappPkgsVersions.seth-0_8_4;

mkShell {
  buildInputs = [
    (dapp.override { inherit solc; })
  ];
}
