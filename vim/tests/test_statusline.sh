#!/usr/bin/env bash
#
# Tests for vim/lua/config/statusline.lua — verifies that
# _G.statusline_encoding() produces the expected marker for every
# combination of fileencoding, bomb, and fileformat we care about.
#
# Run: bash vim/tests/test_statusline.sh
# Requires: nvim on $PATH.

set -u

# Ensure unicode comparison works even in a bare environment.
export LC_ALL=${LC_ALL:-en_US.UTF-8}

here=$(cd "$(dirname "$0")" && pwd)
stl=$(cd "$here/.." && pwd)/lua/config/statusline.lua

if [[ ! -f $stl ]]; then
  echo "cannot find statusline.lua at $stl" >&2
  exit 2
fi

# encoding          bomb     fileformat  expected
cases=(
  'utf-8            nobomb   unix        ||'
  'utf-8            bomb     unix        |Ⓤ |'
  'utf-8            bomb     dos         |Ⓤ [dos] |'
  'utf-8            nobomb   dos         |[dos] |'

  'utf-16           nobomb   unix        |U16 |'
  'utf-16           bomb     unix        |Ⓤ 16 |'
  'utf-16le         nobomb   unix        |u16 |'
  'utf-16le         bomb     unix        |ⓤ 16 |'
  'utf-16be         nobomb   unix        |U16 |'
  'utf-16be         bomb     unix        |Ⓤ 16 |'

  'utf-32           nobomb   unix        |U32 |'
  'utf-32le         bomb     mac         |ⓤ 32 [mac] |'
  'utf-32be         nobomb   dos         |U32 [dos] |'

  'ucs-2            nobomb   unix        |U16 |'
  'ucs-2le          bomb     unix        |ⓤ 16 |'
  'ucs-4            nobomb   unix        |U32 |'
  'ucs-4le          bomb     unix        |ⓤ 32 |'

  'latin1           nobomb   unix        |Ⓛ |'
  'latin1           nobomb   dos         |Ⓛ [dos] |'

  'cp1252           nobomb   unix        |Ⓔ |'
  'euc-jp           nobomb   dos         |Ⓔ [dos] |'
)

pass=0
fail=0
failures=()

for row in "${cases[@]}"; do
  # Split the row: first three whitespace-separated fields, then the
  # pipe-delimited expected string.
  read -r enc bom fmt rest <<<"$row"
  expected=${rest#|}
  expected=${expected%|}

  actual=$(nvim --headless --clean \
    -c "set columns=120" \
    -c "luafile $stl" \
    -c "setlocal fileencoding=$enc $bom fileformat=$fmt" \
    -c 'lua io.stdout:write(_G.statusline_encoding())' \
    -c 'qa!' 2>/dev/null)

  if [[ $actual == "$expected" ]]; then
    pass=$((pass + 1))
    printf '  ok   %-10s %-8s %-6s -> [%s]\n' "$enc" "$bom" "$fmt" "$actual"
  else
    fail=$((fail + 1))
    failures+=("$enc $bom $fmt: expected [$expected] got [$actual]")
    printf '  FAIL %-10s %-8s %-6s -> [%s] (expected [%s])\n' \
      "$enc" "$bom" "$fmt" "$actual" "$expected"
  fi
done

echo
echo "passed: $pass   failed: $fail"
if (( fail > 0 )); then
  printf '\nfailures:\n'
  printf '  %s\n' "${failures[@]}"
  exit 1
fi

# Threshold guard: below MIN_COLUMNS the marker should be suppressed.
narrow=$(nvim --headless --clean \
  -c "set columns=20" \
  -c "luafile $stl" \
  -c 'setlocal fileencoding=utf-16le bomb fileformat=dos' \
  -c 'lua io.stdout:write("[" .. _G.statusline_encoding() .. "]")' \
  -c 'qa!' 2>/dev/null)
if [[ $narrow != '[]' ]]; then
  echo "FAIL: narrow-terminal guard produced $narrow, expected []" >&2
  exit 1
fi
echo "  ok   narrow-terminal guard suppresses marker"
