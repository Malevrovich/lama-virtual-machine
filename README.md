# Lama Virtual Machine

ДЗ2 по курсу «Виртуальные машины». Разработка в VS Code Dev Container:
Linux x86_64, Clang 18, C++20.

Откройте папку через `Dev Containers: Reopen in Container`.
При первом запуске автоматически собирается Lama и настраивается clangd.
Для CMake Tools доступен kit `Lama Devcontainer Clang 18`.

Команды из корня проекта:

| Команда | Действие |
| --- | --- |
| `make lama` | Собрать и установить Lama |
| `make tooling` | Обновить `compile_commands.json` для VM и дампера |
| `make bytecode-dumper` | Собрать [дампер](bytecode-dumper/README.md) |
| `make examples` | Скомпилировать примеры и сохранить `.bc` и `.dump.txt` рядом с `.lama` |
| `make clean-examples` | Удалить `.bc`, `.i` и `.dump.txt` из папок примеров |
