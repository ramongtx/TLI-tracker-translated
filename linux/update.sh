#!/bin/sh
# Bump PKGBUILD to the latest upstream release (version + checksum).
set -eu
cd "$(dirname "$0")"

repo=Giboork/TLI-tracker-translated
tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
ver=${tag#v}
current=$(sed -n 's/^pkgver=//p' PKGBUILD)

if [ "$ver" = "$current" ]; then
  echo "Already at $current"
  exit 0
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
curl -fsSL -o "$tmp" "https://github.com/$repo/releases/download/$tag/TLI-tracker-translated-$tag.zip"
if command -v sha256sum >/dev/null; then sum=$(sha256sum "$tmp" | cut -d' ' -f1); else sum=$(shasum -a 256 "$tmp" | cut -d' ' -f1); fi

sed -i.bak -e "s/^pkgver=.*/pkgver=$ver/" -e "s/^pkgrel=.*/pkgrel=1/" -e "s/^sha256sums=('[0-9a-f]*'/sha256sums=('$sum'/" PKGBUILD
rm -f PKGBUILD.bak
echo "Updated $current -> $ver ($sum)"
