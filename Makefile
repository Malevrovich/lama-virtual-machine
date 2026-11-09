.PHONY: lama tooling

lama:
	cd Lama && GNUMAKEFLAGS=CC=clang opam exec -- dune build --profile=release @install
	cd Lama && opam exec -- dune install --profile=release

# -B ensures Bear records commands even when objects are up to date.
tooling:
	mkdir -p build/lama
	bear --output build/lama/compile_commands.json -- $(MAKE) -B -C Lama/virtual_machine CC=clang BUILD_DIR=$(CURDIR)/build/lama/vm TARGET=$(CURDIR)/build/lama/lamavm
