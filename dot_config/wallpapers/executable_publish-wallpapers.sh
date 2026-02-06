#!/usr/bin/env bash
set -euo pipefail

OWNER_REPO="xavier-sanna/dotfiles"             # repo that will host the Release assets
WALLPAPERS_DIR="$HOME/.local/share/wallpapers" # local folder with your animated wallpapers
TAG="wallpapers"                               # fixed tag to always overwrite the same Release

bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"

info() { printf "%sℹ️  %s%s\n" "$bold" "$*" "$reset"; }
step() { printf "%s➡️  %s%s\n" "$bold" "$*" "$reset"; }
ok() { printf "%s✅ %s%s\n" "$bold" "$*" "$reset"; }
warn() { printf "%s⚠️  %s%s\n" "$bold" "$*" "$reset"; }
err() { printf "%s❌ %s%s\n" "$bold" "$*" "$reset" >&2; }

step "Checking prerequisites"
if ! command -v gh >/dev/null 2>&1; then
  err "GitHub CLI (gh) not found in PATH."
  exit 1
fi

if [ ! -d "$WALLPAPERS_DIR" ]; then
  err "Wallpapers directory not found: $WALLPAPERS_DIR"
  exit 1
fi

if [ -z "$(ls -A "$WALLPAPERS_DIR")" ]; then
  warn "Wallpapers directory is empty: $WALLPAPERS_DIR"
fi

info "Repo: $OWNER_REPO"
info "Tag:  $TAG (fixed)"

WORKDIR="$(mktemp -d)"
ARCHIVE="${WORKDIR}/wallpapers.tar"
SHA_FILE="${WORKDIR}/wallpapers.sha256"

cleanup() {
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

# Build archive
step "Building archive"
FILE_COUNT="$(find "$WALLPAPERS_DIR" -type f | wc -l | tr -d ' ')"
tar -cf "$ARCHIVE" -C "$WALLPAPERS_DIR" .
ok "Archive created (${FILE_COUNT} files)"

# Hash (Linux vs macOS)
step "Computing checksum"
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
else
  shasum -a 256 "$ARCHIVE" | awk '{print $1}' >"$SHA_FILE"
fi
ok "Checksum written"

# Create or update the release + upload assets
step "Publishing release"
if gh release view "$TAG" -R "$OWNER_REPO" >/dev/null 2>&1; then
  info "Release exists — uploading updated assets"
  gh release upload "$TAG" -R "$OWNER_REPO" --clobber "$ARCHIVE" "$SHA_FILE"
else
  info "Release not found — creating new one"
  gh release create "$TAG" -R "$OWNER_REPO" \
    --title "$TAG" --notes "my wallpapers bundle" \
    "$ARCHIVE" "$SHA_FILE"
fi

ok "Done! Release: https://github.com/${OWNER_REPO}/releases/tag/${TAG}"
