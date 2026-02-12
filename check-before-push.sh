#!/bin/bash
set -euo pipefail
set -x

# Usage:
#   ./check-before-push.sh USERNAME/TAPNAME

# local TAP (brew tap)
TAP="$1"

export HOMEBREW_NO_AUTO_UPDATE=1

brew style "${TAP}"

for filepath in Formula/*.rb
do
  fname="${filepath##*/}"
  formula="${fname%.rb}"
  brew uninstall "${formula}" || echo "(IGNORED)"
done

for filepath in Formula/*.rb
do
  fname="${filepath##*/}"
  formula="${fname%.rb}"
  brew install --build-from-source "${TAP}/${formula}"
  brew audit --formula "${TAP}/${formula}"
  brew test "${TAP}/${formula}"
  if [[ "${UNINSTALL:-0}" = 1 ]]
  then
    brew uninstall "${formula}"
  fi
done
