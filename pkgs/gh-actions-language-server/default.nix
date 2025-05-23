{
  lib,
  fetchFromGitHub,
  mkBunDerivation,
}:
mkBunDerivation {
  pname = "gh-actions-language-server";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "lttb";
    repo = "gh-actions-language-server";
    rev = "0287d3081d7b74fef88824ca3bd6e9a44323a54d";
    hash = "sha256-ZWO5G33FXGO57Zca5B5i8zaE8eFbBCrEtmwwR3m1Px4=";
  };

  bunNix = ./bun.nix;
  index = "./index.js";

  meta = {
    description = "CLI Script for exec `@actions/languageserver";
    homepage = "https://github.com/lttb/gh-actions-language-server";
    license = lib.licenses.mit;
    mainProgram = "gh-actions-language-server";
    platforms = lib.platforms.all;
  };
}
