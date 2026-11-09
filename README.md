# ДЗ2: окружение разработки

Папку `homework-2` можно перенести и открыть отдельно от материалов курса.
Полный Dockerfile находится в `.devcontainer/Dockerfile`: он собирает Lama
самостоятельно, без файлов из родительской папки и без локального образа `local/lama`.
Для первой сборки нужен интернет; повторная использует Docker cache.

## Открыть в VS Code

1. Запустите Colima: `colima start`, если она остановлена.
2. Проверьте Docker context: `docker context show`. Для текущего профиля нужен
   `colima`; при необходимости выберите его командой `docker context use colima`.
3. Откройте именно `homework-2` в VS Code и выполните
   **Dev Containers: Reopen in Container**. Расширение Dev Containers требуется
   на хосте; Lama LSP (`mrartemsav.lama-lsp`), clangd и CMake Tools установятся
   в контейнере автоматически.

В контейнере папка задания находится в `/workspaces/homework-2`.
Изменения в ней сохраняются на Mac. По умолчанию пользователь контейнера
имеет UID/GID `501:20`, как на этом Mac. На другой машине измените
`build.args.USER_UID` и `USER_GID` в `devcontainer.json` на вывод `id -u` и `id -g`.

## Что установлено

- Linux x86_64, OCaml 4.14.4, Dune 3.17.2.
- Lama и C-VM из коммита `235828c57c0bf24b965c96a41bf3348ac3334a46`.
- `lamac`, `lamavm`, opam, GCC/G++, Clang, make, CMake, Ninja, clangd.
- Стандартная библиотека Lama; путь к x64-библиотеке — `$LAMA_STDLIB`.

Для своего файла `Example.lama`:

```sh
lamac -i Example.lama
lamac -s Example.lama
lamac Example.lama && ./Example
lamac -b Example.lama
lamavm -I "$LAMA_STDLIB" Example.bc
```

Нативные программы предназначены для запуска в Linux-контейнере.
Содержимое `examples/` сохранено; реализация ДЗ2 не добавлена.

## Проверка окружения

9 ноября 2026 контейнер собран и запущен через Dev Containers CLI в Colima.
Проверены архитектура `x86_64`, доступность всех перечисленных инструментов,
запись в workspace с UID/GID `501:20`, четыре режима Lama на `write (6 * 7)`,
импорт `List` в C-VM и сборка маленькой программы C++ через CMake/Ninja.
Все программы вернули `42`; временные файлы проверки удалены.
Подключение самого интерфейса VS Code и установка расширений редактора отдельно
не проверялись.

## Без VS Code

Из папки `homework-2`:

```sh
docker --context colima build --platform linux/amd64 -t homework-2-lama .devcontainer
docker --context colima run --rm -it --platform linux/amd64 \
  --mount "type=bind,source=$PWD,target=/workspaces/homework-2" \
  --workdir /workspaces/homework-2 homework-2-lama bash
```
