#!/usr/bin/env bash

PACKAGE=shticker-book-rewritten-git
PKGLINK=https://github.com/madsciencecoder/Shticker-Book-Rewritten

PKGDIR="$HOME/aur/$PACKAGE"
TMPDIR="$HOME/aur/tmp"

pushd $(pwd) > /dev/null

rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
cp "$PKGDIR/PKGBUILD" "$TMPDIR"

cd "$TMPDIR"
makepkg
if [ $? -eq 0 ]
then
  cp PKGBUILD "$PKGDIR"
  cd "$PKGDIR"
  mksrcinfo
  git add .
  git commit -m "Version bump"
  git push
else
  echo "missing dependency"
  chromium "$PKGLINK" || firefox "$PKGLINK"
fi

popd > /dev/null
rm -rf "$TMPDIR/*"
