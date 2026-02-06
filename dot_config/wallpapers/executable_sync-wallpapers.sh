#!/usr/bin/env bash
set -euo pipefail

OWNER_REPO="xavier-sanna/dotfiles"             # repo that hosts the Release assets
WALLPAPERS_DIR="$HOME/.local/share/wallpapers" # local folder with your animated wallpapers
TAG="wallpapers"                               # fixed tag to always pull the same Release

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

WORKDIR="$(mktemp -d)"
ARCHIVE="${WORKDIR}/wallpapers.tar"
SHA_FILE="${WORKDIR}/wallpapers.sha256"
EXTRACT_DIR="${WORKDIR}/extract"

cleanup() {
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

info "Repo: $OWNER_REPO"
info "Tag:  $TAG (fixed)"

step "Downloading release assets"
gh release download "$TAG" -R "$OWNER_REPO" \
  --pattern "wallpapers.tar" \
  --pattern "wallpapers.sha256" \
  --dir "$WORKDIR"

if [ ! -f "$ARCHIVE" ] || [ ! -f "$SHA_FILE" ]; then
  err "Missing assets after download."
  exit 1
fi
ok "Assets downloaded"

step "Verifying checksum"
EXPECTED_SHA="$(cat "$SHA_FILE")"
if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL_SHA="$(sha256sum "$ARCHIVE" | awk '{print $1}')"
else
  ACTUAL_SHA="$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')"
fi

if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
  err "Checksum mismatch."
  err "Expected: $EXPECTED_SHA"
  err "Actual:   $ACTUAL_SHA"
  exit 1
fi
ok "Checksum OK"

step "Extracting archive"
mkdir -p "$EXTRACT_DIR"
tar -xf "$ARCHIVE" -C "$EXTRACT_DIR"
ok "Extracted"

step "Syncing to local wallpapers directory"
mkdir -p "$WALLPAPERS_DIR"
find "$WALLPAPERS_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
cp -a "$EXTRACT_DIR"/. "$WALLPAPERS_DIR"/
ok "Local wallpapers updated"

ok "Done!"
