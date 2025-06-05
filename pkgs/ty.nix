{
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  ...
}:
rustPlatform.buildRustPackage rec {
  rev = "74a4e9af3d52142247be218bd4b524d58b1c56e5";
  pname = "ty";
  version = "0.0.1-alpha.8-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "astral-sh";
    repo = "ruff";
    hash = "sha256-eTdTVIkI34J0DnXS1UN7dt5Ck0q1+NeSUjPqOghiLq8=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-UKfT3KE80mwkEx8ytGnrpGHhsAiLYQ/d2zGuMcesKAM=";

  doCheck = false;
  nativeBuildInputs = [installShellFiles];
  useFetchCargoVendor = true;

  env.TY_VERSION = version;

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      installShellCompletion --cmd ty \
        --bash <(${emulator} $out/bin/ty generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ty generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ty generate-shell-completion zsh)
    ''
  );

  passthru = {
    updateScript = nix-update-script {extraArgs = ["--version=unstable"];};
  };

  meta = {
    description = "Extremely fast Python type checker and language server, written in Rust";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ty/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    version = version;
    mainProgram = pname;
  };
}
