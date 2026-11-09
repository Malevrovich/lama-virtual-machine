# Lama Virtual Machine homework environment

- This repository contains homework examples and development infrastructure.
- `Lama/` is a Git submodule of https://github.com/Malevrovich/Lama.
- Do not implement the homework interpreter unless the user explicitly requests it.
- Run builds and development tools inside the Linux amd64 devcontainer.
- `make lama` rebuilds and installs the workspace fork; `make tooling` rebuilds
  C-VM/runtime and refreshes `build/lama/compile_commands.json` for clangd.
- Commit changes to Lama in the fork first, then update the parent submodule pin.
