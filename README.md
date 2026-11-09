# Lama Virtual Machine

Devcontainer с Linux x86_64 для разработки на C/C++ и работы с Lama.
Включает OCaml, Dune, opam, GCC, Clang, CMake, Ninja, GDB и clangd.
В VS Code устанавливаются расширения Lama LSP, clangd и CMake Tools.

При создании контейнера собирается Lama из сабмодуля `Lama/` и создаётся
`compile_commands.json` для навигации и диагностики C-кода через clangd.

- `make lama` — пересобрать и установить Lama.
- `make tooling` — обновить базу команд компиляции для clangd.
