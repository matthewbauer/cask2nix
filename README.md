# cask2nix

## About

Nix users on macOS suffer from not having a lot of packages available. We've made a lot of progress in the past 6 months, but there are still lots of packages that aren't easy to do source-based builds with. The lack of packages is a main reason why most macOS users prefer Homebrew over Nix. This is a chicken-egg problem where most we need more packages to bring the users but also more users to support our growing number of packages.

I'm trying to cheat a little by using another package manager's packages. Homebrew Casks are a set of formula for Homebrew that just download and extract pre-compiled binaries. They’re all pretty simple and because it’s Homebrew there's a ton of them and they’re usually up-to-date. This makes Homebrew Casks a great candidate for generating Nix expressions with.

cask2nix will build a Homebrew Cask formula from within Nix. This means you can use a Homebrew Cask formula like any other derivation in Nix. Things like installing, removing, and more become possible. We can even create a package set from the default Homebrew Casks.

This project contain 0% generated files— everything is generated automatically. Basically, it will download the Homebrew Casks formula repo and create an index for each file in that repo. When building, it pulls in Homebrew, then evaluates the Cask in Ruby and generates a JSON file that is readable by Nix.

This project is mostly an experiment in building packages directly from another package manager. Because we’re just using another package manager’s data, not every package is going to work. Please file an issue if you find a bug in your project. I’ll try to support it as much as I can but be warned it’s very experimental.

## Usage

### List all casks

``` shell
nix-env -f https://github.com/matthewbauer/cask2nix/archive/v0.1.tar.gz -qa
```

### Install a cask

``` shell
nix-env -f https://github.com/matthewbauer/cask2nix/archive/v0.1.tar.gz -iA CASK-NAME
```

## Future

There are other package managers that we can use in Nixpkgs.
[repology](https://repology.org/statistics) has a list of how many packages are
available in other package managers and how they compare to Nixpkgs. Something
like Arch Linux’s PKGBUILD would be great as a source for Nixpkgs. PKGBUILD is
just a bash script so a pkgbuild2nix project should be easy.
