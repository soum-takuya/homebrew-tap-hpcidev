#!/bin/bash
set -euo pipefail
set -x

# Usage:
#   ./check-before-push.sh [Formula name]

# Arguments
FORMULA="${1:-}"

# Environment variables
UNINSTALL="${UNINSTALL:-1}" # default: uninstall after test

# Local TAP (brew tap)
TAP="hpci-auth/tap-localtest"
export HOMEBREW_NO_AUTO_UPDATE=1

REPO=$(brew --repo "${TAP}")
REPO_PARENT=$(dirname "${REPO}")
THIS_DIR=$(pwd)

if [[ -e "${REPO}" ]]
then
  if [[ ! -s "${REPO}" ]]
  then
    echo >&2 "Error: ${REPO}: Directory exists"
    exit 1
  fi
  # symlink
  echo "Info: ${REPO} (symlink) will be replaced"
  rm -f "${REPO}"
fi

mkdir -p "${REPO_PARENT}"
ln -s "${THIS_DIR}" "${REPO}"

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
  brew install --verbose --build-from-source "${TAP}/${formula}"
  brew audit --formula "${TAP}/${formula}"
  brew test --verbose "${TAP}/${formula}"
  if [[ "${UNINSTALL}" = 1 ]]
  then
    brew uninstall "${formula}"
  fi
done

set +x
echo
echo "NOTE: To untap the local tap (${TAP}),"
echo "  Run 'rm ${REPO}'"
