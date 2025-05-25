#!/usr/bin/env bash

comm -23 \
  <(pcregrep -riho1 --include='.*\.asm$' -e '^\s*SECTION\s*(".+")\s*,\s*\w+\s*(?:,|$)' . | sort) \
  <(pcregrep -riho1 --include='.*\.link$' -e '^\s+(".+")' contents | sort)
