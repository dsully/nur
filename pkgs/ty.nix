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
  pname = "ty";
  version = "0.0.1-alpha.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "aa1fad61e0f9fe0c7faac876f2ef55cd3817fc6c";
    hash = "sha256-gAvtWOC2aQbqDNjOk7UUGXV/0TfdIXdrxTWH1lq7+fs=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-7wTJzHyrcz1V9FKRYPyhmaj4160gtXv1fsDH3q32vJ0=";

  doCheck = false;
  nativeBuildInputs = [installShellFiles];
  useFetchCargoVendor = true;

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
    mainProgram = "ty";
  };
}
