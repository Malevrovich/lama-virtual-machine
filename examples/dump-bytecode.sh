#!/usr/bin/env bash
set -euo pipefail

examples_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(dirname -- "$examples_dir")"
dumper="$project_dir/build/clang18/bytecode-dumper/bytecode-dumper"

command -v lamac >/dev/null || {
  echo "lamac not found; run this script inside the Lama devcontainer." >&2
  exit 1
}

make -C "$project_dir" bytecode-dumper

shopt -s nullglob
sources=("$examples_dir"/*/*.lama)
if ((${#sources[@]} == 0)); then
  echo "No Lama examples found." >&2
  exit 1
fi

for source in "${sources[@]}"; do
  (
    cd -- "$(dirname -- "$source")"
    filename="$(basename -- "$source")"
    name="${filename%.lama}"
    echo "Dumping ${source#"$examples_dir/"} -> $name.dump.txt"
    lamac -b "$filename"
    "$dumper" "$name.bc" > "$name.dump.txt"
  )
done
