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
    rev = "0079cc6817d070ff42bfc568c6652e260485983b";
    hash = "sha256-j+vWB01yI1Mlg5c+/WD429nyI0idtd28w5wYMlPl08Y=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-XISRy7Ncy0lTlsCFYmJBcgGiDJfdygTDF4f9O9ZlzDU=";

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
    mainProgram = "ty";
  };
}
