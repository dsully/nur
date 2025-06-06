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
  rev = "cb8246bc5f3f1cad5cb443d5122b944cba68fb3e";
  pname = "ty";
  version = "0.0.1-alpha.8-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "astral-sh";
    repo = "ruff";
    hash = "sha256-jcm8/pI5rpOK8OqpwpMTPeFb9sdL6Ck4axs65e9Lh58=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-JkhvTONWKd3/2jI/yQU2jRfEQ2eAp3drup9SsYWOXNA=";

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
