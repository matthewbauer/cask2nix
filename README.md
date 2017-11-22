# cask2nix

Build Homebrew casks within Nix.

## Usage

You can use this directly from nix-env:

To list all available casks:

``` shell
nix-env -f https://github.com/matthewbauer/cask2nix/archive/v0.1.tar.gz -qa
```

To install a cask:

``` shell
nix-env -f https://github.com/matthewbauer/cask2nix/archive/v0.1.tar.gz -iA CASK-NAME
```

## Develop

``` shell
git clone https://github.com/matthewbauer/cask2nix
```

## Issues

This project doesn't support 100% of Homebrew casks.

## Future

The next step will be trying to get Homebrew formulas to work as well. They may be a little bit harder because of the differences between Nix compilation vs Brew compilation.

I want to eventually integrate this into Nixpkgs. We want most of Nixpkgs to be
source-based but sometimes this is not possible. We should try to get rid of the
binary blobs in Nixpkgs and offload it to Homebrew Casks or something else.

There are other package managers that we can use in Nixpkgs.
[repology](https://repology.org/statistics) has a list of how many packages are
available in other package managers. Something like Arch Linux's PKGBUILD would
be great as a source for Nixpkgs. PKGBUILD is just a bash script so a
pkgbuild2nix project should be easy.
