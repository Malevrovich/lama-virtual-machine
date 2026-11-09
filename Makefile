CC := clang-18
CXX := clang++-18
export CC CXX

.PHONY: lama tooling bytecode-dumper configure-bytecode-dumper examples clean-examples

lama:
	cd Lama && GNUMAKEFLAGS="CC=$(CC)" opam exec -- dune build --profile=release @install
	cd Lama && opam exec -- dune install --profile=release

# -B ensures Bear records commands even when objects are up to date.
tooling: configure-bytecode-dumper
	mkdir -p build/lama
	bear --output build/lama/compile_commands.json -- $(MAKE) -B -C Lama/virtual_machine CC=$(CC) BUILD_DIR=$(CURDIR)/build/lama/vm TARGET=$(CURDIR)/build/lama/lamavm

configure-bytecode-dumper:
	cmake -S bytecode-dumper -B build/clang18/bytecode-dumper -G Ninja -DCMAKE_C_COMPILER=$(CC) -DCMAKE_CXX_COMPILER=$(CXX) -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

bytecode-dumper: configure-bytecode-dumper
	cmake --build build/clang18/bytecode-dumper

examples:
	+./examples/dump-bytecode.sh

clean-examples:
	rm -f examples/*/*.bc examples/*/*.i examples/*/*.dump.txt
