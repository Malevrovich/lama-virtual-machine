.PHONY: lama tooling

# Rebuild and install compiler, VM and stdlib from the pinned workspace fork.
lama:
	cd Lama && GNUMAKEFLAGS=CC=clang opam exec -- dune build --profile=release @install
	cd Lama && opam exec -- dune install --profile=release

# Force compilation so Bear captures every translation unit on repeated runs too.
# Keep native build artifacts outside the submodule.
tooling:
	mkdir -p build/lama
	bear --output build/lama/compile_commands.json -- $(MAKE) -B -C Lama/virtual_machine CC=clang BUILD_DIR=$(CURDIR)/build/lama/vm TARGET=$(CURDIR)/build/lama/lamavm
