#!/usr/bin/env bash
set -euo pipefail

OWNER_REPO="xavier-sanna/dotfiles"             # repo that will host the Release assets
WALLPAPERS_DIR="$HOME/.local/share/wallpapers" # local folder with your animated wallpapers
TAG="${1:-v$(date +%Y-%m-%d)}"                 # e.g. v2026-02-06 (or pass a tag as $1)

WORKDIR="$(mktemp -d)"
ARCHIVE="${WORKDIR}/wallpapers.tar"
SHA_FILE="${WORKDIR}/wallpapers.sha256"

# Build archive
tar -cf "$ARCHIVE" -C "$WALLPAPERS_DIR" .

# Hash (Linux vs macOS)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
else
  shasum -a 256 "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
fi

# Create or update the release + upload assets
if gh release view "$TAG" -R "$OWNER_REPO" >/dev/null 2>&1; then
  gh release upload "$TAG" -R "$OWNER_REPO" --clobber "$ARCHIVE" "$SHA_FILE"
else
  gh release create "$TAG" -R "$OWNER_REPO" \
    --title "$TAG" --notes "Animated wallpapers bundle" \
    "$ARCHIVE" "$SHA_FILE"
fi

echo "Done. Release: $TAG"

#!/usr/bin/env bash
set -euo pipefail

OWNER_REPO="xavier-sanna/dotfiles"             # repo that will host the Release assets
WALLPAPERS_DIR="$HOME/.local/share/wallpapers" # local folder with your animated wallpapers
TAG="${1:-v$(date +%Y-%m-%d)}"                 # e.g. v2026-02-06 (or pass a tag as $1)

WORKDIR="$(mktemp -d)"
ARCHIVE="${WORKDIR}/wallpapers.tar"
SHA_FILE="${WORKDIR}/wallpapers.sha256"

# Build archive
tar -cf "$ARCHIVE" -C "$WALLPAPERS_DIR" .

# Hash (Linux vs macOS)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
else
  shasum -a 256 "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
fi

# Create or update the release + upload assets
if gh release view "$TAG" -R "$OWNER_REPO" >/dev/null 2>&1; then
  gh release upload "$TAG" -R "$OWNER_REPO" --clobber "$ARCHIVE" "$SHA_FILE"
else
  gh release create "$TAG" -R "$OWNER_REPO" \
    --title "$TAG" --notes "Animated wallpapers bundle" \
    "$ARCHIVE" "$SHA_FILE"
fi

echo "Done. Release: $TAG"

#!/usr/bin/env bash
set -euo pipefail

OWNER_REPO="xavier-sanna/dotfiles"             # repo that will host the Release assets
WALLPAPERS_DIR="$HOME/.local/share/wallpapers" # local folder with your animated wallpapers
TAG="${1:-v$(date +%Y-%m-%d)}"                 # e.g. v2026-02-06 (or pass a tag as $1)

WORKDIR="$(mktemp -d)"
ARCHIVE="${WORKDIR}/wallpapers.tar"
SHA_FILE="${WORKDIR}/wallpapers.sha256"

# Build archive
tar -cf "$ARCHIVE" -C "$WALLPAPERS_DIR" .

# Hash (Linux vs macOS)
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
else
  shasum -a 256 "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
fi

# Create or update the release + upload assets
if gh release view "$TAG" -R "$OWNER_REPO" >/dev/null 2>&1; then
  gh release upload "$TAG" -R "$OWNER_REPO" --clobber "$ARCHIVE" "$SHA_FILE"
else
  gh release create "$TAG" -R "$OWNER_REPO" \
    --title "$TAG" --notes "Animated wallpapers bundle" \
    "$ARCHIVE" "$SHA_FILE"
fi

echo "Done. Release: $TAG"
