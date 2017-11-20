{ fetchFromGitHub, runCommand, jq, buildCask, lib }:

let
  homebrew-cask = fetchFromGitHub {
    owner = "caskroom";
    repo = "homebrew-cask";
    rev = "82e33b4c7a58e282fb4658ffa10b00df6ef282a4";
    sha256 = "1fpxc3ck17fgz8yk7xhig8mmb5q1sg58av7x8yg9gw7frrdmscl6";
  };

  all-casks = runCommand "all-casks" {
    buildInputs = [ jq ];
  } ''
    ls ${homebrew-cask}/Casks | jq -R '[.]' | jq -s -c 'add' > $out
  '';
in
  builtins.listToAttrs (map
    (path: rec {
      name = (lib.removeSuffix ".rb" path);
      value = buildCask homebrew-cask name;
    }) (builtins.fromJSON (builtins.readFile all-casks)))
