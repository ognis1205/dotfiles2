#!/usr/bin/env bash

set -eu

GIT_DIR="$(git rev-parse --git-dir)"
HOOK="$(basename $0)"

if [ -f "${GIT_DIR}/hooks/${HOOK}" ]; then
  "${GIT_DIR}/hooks/${HOOK}" $@
fi

DIR="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)"
WHITELISTS="${DIR}/whitelists"

is_allowed() {
  file="${1}"
  path="${DIR}/whitelists.d/${file}"

  if [ -f "${path}" ]; then
    while read -r; do
      if [ "${REPLY}" == "$(pwd)" ]; then
        return 0
      fi
    done < "${path}"
  fi
  return 1
}

WHITELIST=""

has_whitelist() {
  hook="${1}"

  while read -ra LINE; do
    entry="${LINE[0]}"
    if [ "${hook}" == "$entry" ]; then
      WHITELIST="${LINE[1]}"
      return 0
    fi
  done < ${WHITELISTS}
  return 1
}

HOOK_DIR="${DIR}/${HOOK}.d"

for entry in $(ls "${HOOK_DIR}"); do
  rel_entry="${HOOK_DIR}/${entry}"

  if has_whitelist "${rel_entry}"; then
    if is_allowed "${WHITELIST}"; then
      continue
    fi
  fi
  "${HOOK_DIR}/${entry}" $@
done
