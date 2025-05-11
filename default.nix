# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage
{pkgs ? import <nixpkgs> {}, ...}: rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib {inherit pkgs;}; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  apple-photos-export = pkgs.lib.optional pkgs.stdenv.isDarwin (pkgs.callPackage ./pkgs/apple-photos-export.nix {});
  autorebase = pkgs.callPackage ./pkgs/autorebase.nix {};
  codesort = pkgs.callPackage ./pkgs/codesort.nix {};
  # curlconverter = pkgs.callPackage ./pkgs/curlconverter.nix {};
  devmoji-log = pkgs.callPackage ./pkgs/devmoji-log.nix {};
  dirstat-rs = pkgs.callPackage ./pkgs/dirstat-rs.nix {};
  feluda = pkgs.callPackage ./pkgs/feluda.nix {};
  geil = pkgs.callPackage ./pkgs/geil.nix {};
  ghostty-ls = pkgs.callPackage ./pkgs/ghostty-ls.nix {};
  git-ai-commit = pkgs.callPackage ./pkgs/git-ai-commit.nix {};
  git-trim = pkgs.callPackage ./pkgs/git-trim.nix {};
  github-actions-languageserver = pkgs.callPackage ./pkgs/github-actions-languageserver.nix {};
  lolcate-rs = pkgs.callPackage ./pkgs/lolcate-rs.nix {};
  magic-opener = pkgs.callPackage ./pkgs/magic-opener.nix {};
  oli = pkgs.callPackage ./pkgs/oli.nix {};
  # mc = pkgs.callPackage ./pkgs/mc.nix {};
  pkl-lsp = pkgs.callPackage ./pkgs/pkl-lsp.nix {};
  pyproject-fmt = pkgs.callPackage ./pkgs/pyproject-fmt.nix {inherit toml-fmt-common;};
  # qlty = pkgs.callPackage ./pkgs/qlty.nix {};
  reading-list-to-pinboard = pkgs.callPackage ./pkgs/reading-list-to-pinboard-rs {};
  safari-rs = pkgs.lib.optional pkgs.stdenv.isDarwin (pkgs.callPackage ./pkgs/safari-rs.nix {});
  sith-language-server = pkgs.callPackage ./pkgs/sith-language-server.nix {};
  sphinx-lint = pkgs.callPackage ./pkgs/sphinx-lint.nix {};
  sps = pkgs.lib.optional pkgs.stdenv.isDarwin (pkgs.callPackage ./pkgs/sps.nix {});
  toml-fmt-common = pkgs.callPackage ./pkgs/toml-fmt-common.nix {};
  turbo-commit = pkgs.callPackage ./pkgs/turbo-commit.nix {};
  werk = pkgs.callPackage ./pkgs/werk.nix {};
  xdg-open-svc = pkgs.callPackage ./pkgs/xdg-open-svc.nix {};
  xmlformatter = pkgs.callPackage ./pkgs/xmlformatter.nix {};
}
