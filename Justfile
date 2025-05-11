# Justfile for fetching sources using nurl and building Nix packages
# Default values

default_url := "https://github.com/NixOS/nixpkgs"
default_rev := "master"
output_dir := "nix/sources"
nixpkgs_file := "default.nix"

# Help command
help:
    @just --list

# Fetch a source using nurl

# Usage: just fetch <url> <revision>
fetch url=default_url rev=default_rev:
    @echo "Fetching from {{ url }} at revision {{ rev }}..."
    @mkdir -p {{ output_dir }}
    @nix run nixpkgs#nurl -- \
        --url {{ url }} \
        --rev {{ rev }} \
        --output {{ output_dir }}/source.nix

# Fetch a GitHub repository

# Usage: just fetch-github <owner> <repo> <revision>
fetch-github owner repo rev:
    @echo "Fetching GitHub repo {{ owner }}/{{ repo }} at revision {{ rev }}..."
    @mkdir -p {{ output_dir }}
    @nix run nixpkgs#nurl -- \
        --url https://github.com/{{ owner }}/{{ repo }} \
        --rev {{ rev }} \
        --output {{ output_dir }}/{{ repo }}.nix

# Fetch and generate cargoHash for a Rust package

# Usage: just fetch-rust <owner> <repo> <revision>
fetch-rust owner repo rev:
    @echo "Fetching Rust package {{ owner }}/{{ repo }} at revision {{ rev }}..."
    @mkdir -p {{ output_dir }}

    # First fetch the source
    @nix run nixpkgs#nurl -- \
        --url https://github.com/{{ owner }}/{{ repo }} \
        --rev {{ rev }} \
        --output {{ output_dir }}/{{ repo }}-src.nix

    # Create a temporary Nix file to get cargoHash
    @echo "{ pkgs ? import <nixpkgs> {} }:" > {{ output_dir }}/temp-{{ repo }}.nix
    @echo "let src = import ./{{ repo }}-src.nix { inherit (pkgs) fetchFromGitHub lib; };" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "in pkgs.rustPlatform.buildRustPackage {" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "  pname = \"{{ repo }}\";" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "  version = \"{{ rev }}\";" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "  inherit src;" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "  cargoSha256 = pkgs.lib.fakeSha256;" >> {{ output_dir }}/temp-{{ repo }}.nix
    @echo "}" >> {{ output_dir }}/temp-{{ repo }}.nix

    @echo "Attempting to build to get cargoHash (this will fail with the correct hash)..."
    @nix-build {{ output_dir }}/temp-{{ repo }}.nix || true
    @echo "Copy the hash from the error message above and update your Nix expression"

# Fetch with custom output filename

# Usage: just fetch-to <url> <revision> <output-name>
fetch-to url rev output_name:
    @echo "Fetching from {{ url }} at revision {{ rev }}..."
    @mkdir -p {{ output_dir }}
    @nix run nixpkgs#nurl -- \
        --url {{ url }} \
        --rev {{ rev }} \
        --output {{ output_dir }}/{{ output_name }}.nix

# Build a specific package from Nixpkgs

# Usage: just build <package>
build package:
    @echo "Building package {{ package }}..."
    NIXPKGS_ALLOW_UNFREE=1 nix-build -A {{ package }}

# Build all packages in the repository
build-all:
    @echo "Building all packages in the repository..."
    @echo "This may take a while..."

    @# Extract all package names from default.nix
    @packages=$(grep -E "^\s+[a-zA-Z0-9_-]+ =" default.nix | grep -v "^#" | sed 's/ =.*$//' | tr -d ' ' | sort)

    @# Create a temporary directory for build results
    @mkdir -p build-results

    @# Build each package and log results
    @for pkg in $packages; do \
        echo "Building $$pkg..."; \
        if NIXPKGS_ALLOW_UNFREE=1 nix-build -A $$pkg --no-out-link > build-results/$$pkg.log 2>&1; then \
            echo "✅ $$pkg built successfully"; \
        else \
            echo "❌ $$pkg failed to build (see build-results/$$pkg.log for details)"; \
        fi; \
    done

    @# Print summary
    @echo ""
    @echo "Build Summary:"
    @echo "Successful: $(grep -c "✅" build-results/*.log)"
    @echo "Failed: $(grep -c "❌" build-results/*.log)"
    @echo "See build-results directory for detailed logs"

# Build all packages in parallel (faster but harder to debug)
build-all-parallel:
    @echo "Building all packages in parallel..."

    @# Extract all package names from default.nix
    @packages=$(grep -E "^\s+[a-zA-Z0-9_-]+ =" default.nix | grep -v "^#" | sed 's/ =.*$//' | tr -d ' ' | sort)

    @# Create a temporary directory for build results
    @mkdir -p build-results

    @# Build all packages in parallel
    @echo $packages | tr ' ' '\n' | xargs -P $(nproc) -I{} bash -c 'echo "Building {}..." && if nix-build -A {} --no-out-link > build-results/{}.log 2>&1; then echo "✅ {} built successfully"; else echo "❌ {} failed to build"; fi'

    @# Print summary
    @echo ""
    @echo "Build Summary:"
    @echo "Successful: $(grep -c "✅" build-results/*.log)"
    @echo "Failed: $(grep -c "❌" build-results/*.log)"
    @echo "See build-results directory for detailed logs"

# List all available packages in the repository
list-packages:
    @echo "Available packages in the repository:"
    @grep -E "^\s+[a-zA-Z0-9_-]+ =" default.nix | grep -v "^#" | sed 's/ =.*$//' | tr -d ' ' | sort

# Clean generated files
clean:
    @echo "Cleaning generated files..."
    @rm -rf {{ output_dir }} build-results
    @mkdir -p {{ output_dir }}

# Show the Nix store path for a package without building it

# Usage: just show-path <package>
show-path package:
    @echo "Store path for {{ package }}:"
    nix-build -A {{ package }} --no-out-link
