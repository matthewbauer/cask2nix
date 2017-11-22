{ stdenv, fetchurl, lib, runCommand, fetchFromGitHub, ruby, undmg, unzip }:

casks: name:

let
  brew = stdenv.mkDerivation {
    name = "brew";
    src = fetchFromGitHub {
      owner = "Homebrew";
      repo = "brew";
      rev = "dbc04b4dc701aa1d0aa9197dd12be92c7b1800fc";
      sha256 = "1xp78ba8c12j936zg50k1xks11nhjhysvhwf1c21w90rnia0lkx0";
    };
    patches = [ ./no-abs-paths.patch];
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };

  locale = stdenv.mkDerivation {
    name = "locale-2.1.2";
    src = fetchurl {
      url = "https://rubygems.org/downloads/locale-2.1.2.gem";
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
    };
    unpackPhase = ''
      tar xf $src
      tar xfz data.tar.gz
    '';
    installPhase = ''
      mkdir -p $out
      cp -r lib $out
    '';
  };

  cask-info = (builtins.fromJSON (builtins.readFile (
    runCommand name { buildInputs = [ ruby ]; } ''
      env HOMEBREW_MACOS_VERSION="$(/usr/bin/sw_vers -productVersion)" \
          HOMEBREW_PREFIX=${brew} \
          HOMEBREW_BREW_FILE=$HOMEBREW_PREFIX/bin/brew \
          HOMEBREW_REPOSITORY=${brew} \
          HOMEBREW_LIBRARY=${brew} \
          HOMEBREW_CELLAR=${brew} \
          HOMEBREW_CACHE=$PWD \
          HOMEBREW_LOGS=$PWD \
          HOMEBREW_TEMP=$PWD \
          HOMEBREW_LANGUAGES=en \
      ruby -I${brew}/Library/Homebrew/cask/lib \
           -I${brew}/Library/Homebrew \
           -I${locale}/lib \
        ${./cask2nix.rb} ${casks}/Casks/${name}.rb > $out
  '')));
in

# build NAME from the list of CASKS

stdenv.mkDerivation {
  inherit name; # NOTE: name shouldn’t be an attribute of cask-info because it
                # takes to long to generate and name is needed by nix-env -qa

  buildInputs = [ undmg unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  src = if cask-info.sha256 == "no_check" then
    builtins.fetchurl cask-info.url
  else fetchurl rec {
    inherit (cask-info) url sha256;
    name = baseNameOf (builtins.replaceStrings ["%20"] ["_"] url);
  };

  # avoid auto cd into .app dir
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out
  '' + (lib.concatMapStrings (x: ''
    mkdir -p $(dirname $out${x.target})
    cp -r ${x.source} $out${x.target}
  '') cask-info.apps);

  meta = with lib; {
    homepage = cask-info.homepage;
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
