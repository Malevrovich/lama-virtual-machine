# Lama Virtual Machine

Окружение для ДЗ2 курса «Виртуальные машины». Реализация интерпретатора пока
не добавлена. Учебные примеры находятся в `examples/`.

## Начало работы

```sh
git clone --recurse-submodules https://github.com/Malevrovich/lama-virtual-machine.git
cd lama-virtual-machine
code .
```

На Mac запустите Docker/Colima (`colima start`; для Colima выберите Docker
context `colima`). В VS Code установите Dev Containers, затем выполните
**Dev Containers: Reopen in Container**. Открывать нужно корень этой репы.

Контейнер — Linux amd64, включая на Apple Silicon. Первая сборка требует
интернета. Рабочая папка внутри — `/workspaces/homework-2`, независимо от
имени папки на хосте. Файлы сохраняются на хосте.
UID/GID по умолчанию `501:20`; для другой машины задайте результаты `id -u`
и `id -g` в `build.args` файла `.devcontainer/devcontainer.json`.

При создании контейнера автоматически запускается `.devcontainer/setup.sh`:
инициализируется сабмодуль, из него собираются и устанавливаются компилятор,
C-VM и стандартная библиотека; затем создаётся база команд для clangd.
Обычное повторное подключение к контейнеру не запускает сборку.

## Исходники и редактор

`Lama/` — сабмодуль [своего форка](https://github.com/Malevrovich/Lama),
закреплённый на коммите `235828c57c0bf24b965c96a41bf3348ac3334a46`.
Это отдельная Git-история: ДЗ и инфраструктура живут в этой репе,
правки самого языка — в форке.

В контейнере установлены OCaml 4.14.4, Dune 3.17.2, opam, GCC/G++, Clang,
CMake, Ninja, make, clangd, Bear и GDB. VS Code автоматически устанавливает
Lama LSP, clangd и CMake Tools. clangd работает внутри Linux-контейнера:
пути и системные заголовки в базе команд относятся к нему.

```sh
make lama      # пересобрать и установить Lama из рабочего сабмодуля
make tooling   # пересобрать C-VM/runtime и обновить базу clangd
```

Эти команды также доступны через **Tasks: Run Task**.
`make tooling` использует Bear и штатные Makefile Lama с `CC=clang`;
`build/lama/compile_commands.json` содержит настоящие команды компиляции.
Артефакты этой сборки находятся в `build/lama/`, вне сабмодуля.
`.clangd` направляет файлы `Lama/` в эту базу. После обновления Makefile
или набора C-файлов выполните `make tooling` повторно.

Если позже у решения ДЗ появится свой CMake-проект, конфигурируйте его в
`build/` с `CMAKE_EXPORT_COMPILE_COMMANDS=ON` (это уже задано для CMake Tools).
Тогда для собственного кода clangd найдёт `build/compile_commands.json`.

Dockerfile заранее устанавливает эталонную Lama той же ревизии из upstream,
чтобы закэшировать зависимости и иметь готовый bootstrap. `make lama` в
post-create заменяет эту установку сборкой из рабочего форка. После изменения
исходников повторяйте `make lama`; одна правка файла установленную программу
не обновляет. Переменная `$LAMA_STDLIB` указывает на установленную x64-stdlib.

## Запуск примеров

```sh
cd examples/01-constant
lamac -i Constant.lama </dev/null
lamac -s Constant.lama </dev/null
lamac -b Constant.lama
lamavm -I "$LAMA_STDLIB" Constant.bc
lamac Constant.lama && ./Constant
```

`-i` — AST-интерпретатор, `-s` — OCaml-интерпретатор стековой машины,
`lamavm` — существующая C-VM из форка. Для примера без ввода выше stdin
закрыт через `/dev/null`: OCaml-интерпретаторы читают входные числа до EOF
перед выполнением программы. Для примеров с `read()` передайте файл ввода
или завершите ручной ввод через Ctrl+D. Нативные программы запускаются в Linux.
Сгенерированные `.bc`, `.i`, `.s`, `.o` не добавляются в историю ДЗ.
Уже имевшийся пример `Constant.bc` сохранён в истории.

## Работа с сабмодулем

После обычного клонирования без `--recurse-submodules`:

```sh
git submodule update --init --recursive
```

Для правок форка создайте ветку в нём (при checkout сабмодуль может быть
на detached HEAD):

```sh
git -C Lama switch -c my-lama-change
# редактирование, make lama, проверка результата
git -C Lama add <изменённые-исходники>
git -C Lama commit -m "Describe Lama change"
git -C Lama push -u origin my-lama-change
# после публикации нужного коммита форка зафиксировать новый pin в ДЗ
git add Lama
git commit -m "Update Lama submodule"
```

GitHub-аутентификация для push настраивается отдельно; devcontainer не
содержит токенов. Не используйте `git add .` внутри Lama без просмотра:
Dune оставляет там сгенерированные файлы. Родительский репозиторий скрывает
только untracked-файлы сабмодуля (`ignore = untracked`), но показывает правки
отслеживаемых файлов и изменение закреплённого коммита.

## Без VS Code

Из корня репозитория:

```sh
docker --context colima build --platform linux/amd64 \
  -t lama-virtual-machine .devcontainer
docker --context colima run --rm -it --platform linux/amd64 \
  --mount "type=bind,source=$PWD,target=/workspaces/homework-2" \
  --workdir /workspaces/homework-2 lama-virtual-machine bash
# внутри контейнера при первом запуске:
bash .devcontainer/setup.sh
```

## Проверено 10 ноября 2026

Образ собран через Colima; конфигурация прочитана Dev Containers CLI.
Post-create script успешно собрал и установил рабочий сабмодуль. Установленные
`lamac` и `lamavm` побайтово совпали с результатом этой сборки.
`write (6 * 7)` вернул `42` в режимах `-i`, `-s`, C-VM и native.
Bear записал 14 единиц компиляции, включая рантайм и ассемблерный файл.
`clangd --check` для `virtual_machine/ops.c`, `virtual_machine/loader.c`
и `runtime/gc.c` завершился с 0 ошибок, используя созданную базу.
Установка расширений и работа интерфейса VS Code отдельно не проверялись.
Это проверка окружения, а не тестирование реализации ДЗ2 или всего Lama.
