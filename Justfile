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

    set pattern

    if test "{{ packages }}" != "all"
        set glob (string join "," {{ packages }})
        set pattern --glob="*{$glob}*"
    end

    set files (rg -l --color=never --sort path --type nix $pattern "src = " pkgs/)

    mkdir -p build-results

    set NIXPKGS_ALLOW_UNFREE 1

    # Build each package and log results
    for file in $files

        set pkg (rg 'pname = "([^"]+)"' $file -o --max-count=1 --replace '$1' --no-line-number --color=never)

        echo -n "Building $pkg ..."

        if nix build .#$pkg --no-link > build-results/$pkg.log 2>&1
            echo (set_color green) "success!" (set_color normal)
        else
            set new_hash (grep "got:" build-results/$pkg.log | awk '{print $2}')

            if string match -qr 'sha256' -- $new_hash
                echo
                echo "  Got a new cargoHash: $new_hash"
                echo -n "  Rebuilding ..."

                sd "cargoHash = .*" "cargoHash = \"$new_hash\";" "$file"
                sd "vendorHash = .*" "vendorHash = \"$new_hash\";" "$file"

                if nix build .#$pkg --no-link > build-results/$pkg.log 2>&1
                    echo (set_color green) "success!" (set_color normal)
                    continue
                end
            end

            echo (set_color red) "failed" (set_color normal) "! See build-results/$pkg.log for details."
        end
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

# Update all package URLs using nurl
update-urls +packages='all': up
    #!/usr/bin/env fish

    set pattern
    set rebuild

    if test "{{ packages }}" != "all"
        set glob (string join "," {{ packages }})
        set pattern --glob="*{$glob}*"
    end

    # Find all .nix files in pkgs/ that contain fetchFromGitHub
    set -l nix_files (rg -l --color=never --sort=path --type nix "fetchFromGitHub" $pattern pkgs/)

    for file in $nix_files

        # Extract homepage URL from the file
        set -l github_url (rg 'homepage = "([^"]+)"' $file -o --replace '$1' --no-line-number --color=never)
        set -l package (rg 'pname = "([^"]+)"' $file -o --replace '$1' --no-line-number --color=never)

        if test -n "$github_url"

            echo -n "Checking $package..."

            # Get the new hash using nurl
            set -l nurl_output (nurl --json $github_url 2>&1)
            set -l nurl_status $status

            if test $nurl_status -eq 0
                # Extract just the JSON part from nurl output (everything after the last space)
                set -l json_part (echo $nurl_output | awk '{print $NF}')

                # Extract the hash and rev from nurl JSON output
                set -l new_hash (echo $json_part | jq -r '.args.hash' 2>/dev/null)
                set -l new_rev (echo $json_part | jq -r '.args.rev' 2>/dev/null)

                if test -n "$new_hash" -a -n "$new_rev"
                    # Get current hash and rev from file
                    set -l current_hash (rg '\bhash = "([^"]+)"' $file -o --replace '$1' --no-line-number --color=never)
                    set -l current_rev (rg '\brev = "([^"]+)"' $file -o --replace '$1' --no-line-number --color=never)

                    if test $new_hash != $current_hash; or test $new_rev != $current_rev
                        set -l updated true

                        sd --fixed-strings "$current_hash" "$new_hash" "$file"
                        sd --fixed-strings "$current_rev" "$new_rev" "$file"

                        # Clear cargoHash if it's there.
                        sd 'cargoHash = "[^"]*"' 'cargoHash = ""' "$file"

                        set -a rebuild $package

                        echo "...updated!"
                    else
                        echo "...no changes needed."
                    end
                else
                    echo
                    echo "   Could not extract hash/rev from nurl output for $file"
                    echo "  Debug: nurl output was: $nurl_output"
                    exit 1
                end
            else
                echo
                echo "   nurl failed for $github_url (exit code: $nurl_status)"
                echo "  Debug: nurl output was: $nurl_output"
                exit 1
            end
        else
            echo
            echo "   Could not extract homepage URL from $file"
        end
    end

    if test (count $rebuild) -gt 0
        echo
        echo "Run: just build" (string join " " $rebuild)
    end
