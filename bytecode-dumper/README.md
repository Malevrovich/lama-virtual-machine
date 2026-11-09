# bytecode-dumper

Дизассемблер байткода Lama на C++20. Использует `dump_bytecode` из
`Lama/virtual_machine/disasm.h`.

Из корня проекта в девконтейнере:

```sh
make bytecode-dumper
./build/clang18/bytecode-dumper/bytecode-dumper path/to/program.bc
```

Дамп выводится в stdout; для сохранения добавьте `> program.dump.txt`.
`make examples` создаёт байткод и дампы для всех примеров.

Стиль — Google C++ Style Guide. Форматирование:

```sh
clang-format-18 -i bytecode-dumper/*.cpp
```
