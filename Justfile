output_dir := "nix/sources"

# Help command
help:
    @just --list

up:
    nix flake update

# Fetch a source using nix-init (via nurl)

# Usage: just init-from-url https://github.com/anistark/feluda
[group('nix')]
init-from-url URL:
    #!/usr/bin/env bash
    set -euo pipefail

    # Extract the last path component from the URL
    LAST_COMPONENT=$(echo "{{ URL }}" | sed -E 's|.*/([^/]+)/?$|\1|')

    # Remove any trailing .git if present
    LAST_COMPONENT=${LAST_COMPONENT%.git}

    # Create the output filename
    OUTPUT_FILE=pkgs/"${LAST_COMPONENT}.nix"

    # Run nix-init with the specified parameters
    nix-init -n 'builtins.getFlake "nixpkgs"' -u "{{ URL }}" "${OUTPUT_FILE}"

    # Add useFetchCargoVendor = true; to the file
    sed -i '/cargoHash = ".*";/a \    useFetchCargoVendor = true;' "${OUTPUT_FILE}"

# Build a specific package from Nixpkgs

# Usage: just build <package>
build package:
    @echo "Building package {{ package }}..."
    NIXPKGS_ALLOW_UNFREE=1 nix build .#{{ package }}

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
        if NIXPKGS_ALLOW_UNFREE=1 nix build .#$$pkg --no-out-link > build-results/$$pkg.log 2>&1; then \
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
    @echo $packages | tr ' ' '\n' | xargs -P $(nproc) -I{} bash -c 'echo "Building {}..." && if nix build .#{} --no-out-link > build-results/{}.log 2>&1; then echo "✅ {} built successfully"; else echo "❌ {} failed to build"; fi'

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
    nix build .#{{ package }} --no-out-link
