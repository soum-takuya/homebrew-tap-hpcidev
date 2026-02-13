#!/bin/bash
set -euo pipefail
set -x

# Usage:
#   ./check-before-push.sh USERNAME/TAPNAME

# local TAP (brew tap)
TAP="$1"
FORMULA="${2:-}"

export HOMEBREW_NO_AUTO_UPDATE=1

brew style "${TAP}"

for filepath in Formula/*.rb
do
  fname="${filepath##*/}"
  formula="${fname%.rb}"
  if [[ -n "${FORMULA}" ]] && [[ "${FORMULA}" != "${formula}" ]]
  then
    continue
  fi
  brew uninstall "${formula}" || echo "(IGNORED)"
done

for filepath in Formula/*.rb
do
  fname="${filepath##*/}"
  formula="${fname%.rb}"
  if [[ -n "${FORMULA}" ]] && [[ "${FORMULA}" != "${formula}" ]]
  then
    continue
  fi
  brew install --build-from-source "${TAP}/${formula}"
  brew audit --formula "${TAP}/${formula}"
  brew test "${TAP}/${formula}"
  if [[ "${UNINSTALL:-0}" = 1 ]]
  then
    brew uninstall "${formula}"
  fi
done
