{
  inputs,
  pkgs ? import <nixpkgs> {},
  system,
  ...
}: let
  # Apply the overlay to get all packages
  overlay = import ./overlays;
  overlaidPkgs = pkgs.extend (overlay inputs);
in {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib {inherit pkgs;}; # functions
  modules = import ./modules; # NixOS modules
  overlays = overlay inputs;

  inherit (inputs.emmylua-analyzer-rust.packages.${system}) emmylua_ls emmylua_check;

  # Re-export all packages from the overlay
  inherit
    (overlaidPkgs)
    apple-photos-export
    autorebase
    codesort
    curlconverter
    devmoji-log
    dirstat-rs
    feluda
    geil
    gh-actions-language-server
    ghostty-ls
    git-ai-commit
    git-trim
    lolcate-rs
    magic-opener
    # mc
    njq
    oli
    pkl-lsp
    pyproject-fmt
    reading-list-to-pinboard-rs
    safari-rs
    sith-language-server
    sphinx-lint
    sps
    toml-fmt-common
    turbo-commit
    ty
    werk
    xdg-open-svc
    xmlformatter
    ;
}
