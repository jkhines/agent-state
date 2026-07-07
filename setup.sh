#!/bin/bash
# Backward-compatible wrapper; prefer install.sh for new setups.
exec "$(dirname "${BASH_SOURCE[0]}")/install.sh" "$@"
