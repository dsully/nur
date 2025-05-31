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

# Build a package or all packages
#
# Usage: just build [package]
build +packages='all':
    #!/usr/bin/env fish

    echo "Building {{ packages }} ..."

    if test "{{ packages }}" = "all"
        set pattern pkgs
    else
        set pattern (string join '|' {{ packages }})
    end

    set files (fd --type f --extension nix --exclude bun.nix --exclude build.zig.zon.nix $pattern pkgs/)

    mkdir -p build-results

    set NIXPKGS_ALLOW_UNFREE 1 

    # Build each package and log results
    for file in $files

        set pkg (echo $file | sed 's/pkgs\///' | sed 's/\.nix//' | sed 's/\/.*//')

        if nix build .#$pkg --no-link > build-results/$pkg.log 2>&1
            echo "✅ $pkg built successfully"
        else
            set new_hash (grep "got:" build-results/$pkg.log | awk '{print $2}')

            if string match -qr 'sha256' -- $new_hash
                echo "Got a new cargoHash: $new_hash - replacing & rebuilding..."

                sd "cargoHash = .*" "cargoHash = \"$new_hash\";" "$file"

                if nix build .#$pkg --no-link > build-results/$pkg.log 2>&1
                    echo "✅ $pkg built successfully"

                    continue
                end
            end

            echo "❌ $pkg failed to build (see build-results/$pkg.log for details)"
        end

        echo
    end

# List all available packages in the repository
list-packages:
    #!/usr/bin/env fish

    echo "Available packages in the repository:"
    echo
    fd --type f --extension nix --base-directory pkgs pkgs/| sed 's/\.nix//' | sed 's/\/.*//' | sort -u

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
