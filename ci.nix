# This file provides all the buildable and cacheable packages and
# package outputs in your package set. These are what gets built by CI,
# so if you correctly mark packages as
#
# - broken (using `meta.broken`),
# - unfree (using `meta.license.free`), and
# - locally built (using `preferLocalBuild`)
#
# then your CI will be able to build and cache only those packages for
# which this is possible.
{system ? builtins.currentSystem}:
with builtins; let
  flake = builtins.getFlake (toString ./.);
  inherit (flake) inputs;
  pkgs = import inputs.nixpkgs {inherit system;};
  nurAttrs = import ./default.nix {inherit system pkgs inputs;};

  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  isDerivation = p: isAttrs p && p ? type && p.type == "derivation";
  isBuildable = p: let
    licenseFromMeta = p.meta.license or [];
    licenseList =
      if builtins.isList licenseFromMeta
      then licenseFromMeta
      else [licenseFromMeta];
  in
    !(p.meta.broken or false) && builtins.all (license: license.free or true) licenseList;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: isAttrs p && p.recurseForDerivations or false;

  nameValuePair = n: v: {
    name = n;
    value = v;
  };

  concatMap = builtins.concatMap or (f: xs: concatLists (map f xs));

  flattenPkgs = s: let
    f = p:
      if shouldRecurseForDerivations p
      then flattenPkgs p
      else if isDerivation p
      then [p]
      else [];
  in
    concatMap f (attrValues s);

  outputsOf = p: map (o: p.${o}) p.outputs;

  nurPkgs =
    flattenPkgs
    (listToAttrs
      (map (n: nameValuePair n nurAttrs.${n})
        (filter (n: !isReserved n)
          (attrNames nurAttrs))));
in rec {
  buildPkgs = filter isBuildable nurPkgs;
  cachePkgs = filter isCacheable buildPkgs;

  buildOutputs = concatMap outputsOf buildPkgs;
  cacheOutputs = concatMap outputsOf cachePkgs;
}
