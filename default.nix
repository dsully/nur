{
  inputs,
  pkgs ? import <nixpkgs> {},
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

  # Re-export all packages from the overlay
  inherit
    (overlaidPkgs)
    apple-photos-export
    autorebase
    codesort
    # curlconverter
    devmoji-log
    dirstat-rs
    feluda
    geil
    gh-actions-language-server
    # ghostty-ls
    git-ai-commit
    git-trim
    lolcate-rs
    magic-opener
    # mc
    oli
    pkl-lsp
    pyproject-fmt
    # qlty
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
