with import <nixpkgs> {};

let
  buildCask = callPackage ./cask2nix.nix {};
in
callPackage ./casks.nix {
  inherit buildCask;
}
