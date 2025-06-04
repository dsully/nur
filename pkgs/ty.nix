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
  version = "0.0.1-alpha.8";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "e658778cedc25051ec7f6aa6bc243bbc446fe416";
    hash = "sha256-GUQGsvvuDlWAwLKhHF304P2q6RyLwGTnzzXM2KN1YZs=";
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
