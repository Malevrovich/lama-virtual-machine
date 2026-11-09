# Self-contained Lama environment. Build context: this .devcontainer directory.
FROM ocaml/opam:ubuntu-24.04-ocaml-4.14@sha256:a466a76facae8aa906428a678960504eeb8834fa518463709ebcda771197aa38

USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       clang gcc-multilib libffi-dev libpcre2-dev m4 pkg-config \
    && rm -rf /var/lib/apt/lists/*

USER opam
ARG LAMA_REVISION=235828c57c0bf24b965c96a41bf3348ac3334a46
ENV OPAMJOBS=4
WORKDIR /home/opam/lama-src
RUN git init \
    && git remote add origin https://github.com/PLTools/Lama.git \
    && git fetch --depth=1 origin "${LAMA_REVISION}" \
    && git checkout --detach FETCH_HEAD \
    && test "$(git rev-parse HEAD)" = "${LAMA_REVISION}"

# Dune 3.24.2 stalled under this Colima/Rosetta setup while building csexp.
RUN opam pin add dune 3.17.2 --yes --no-action \
    && opam install dune.3.17.2 --yes --jobs=4 --no-depexts

# The C VM uses Clang's statement attribute __attribute__((musttail)).
# Command-line make variables also propagate to the nested runtime build.
# opam clears MAKEFLAGS; GNU make also accepts GNUMAKEFLAGS.
# gcc-multilib above supplies the legacy -m32 build; avoid the package's
# cross-toolchain depext names, which are unnecessary inside amd64 Linux.
RUN opam pin add Lama . --no-action --yes \
    && opam install Lama --deps-only --yes --jobs=4 --no-depexts

RUN GNUMAKEFLAGS=CC=clang opam install Lama --yes --jobs=4 --no-depexts \
    && mkdir -p /home/opam/lama-bin \
    && ln -s "$(opam var bin)/lamac" /home/opam/lama-bin/lamac \
    && ln -s "$(opam var bin)/lamavm" /home/opam/lama-bin/lamavm \
    && opam list --installed --columns=name,version > /home/opam/lama-packages.txt

RUN ln -s "$(opam var share)/Lama/x64" /home/opam/lama-stdlib
# The host UID used by the launcher needs to traverse the image user's home.
USER root
RUN chmod 755 /home/opam
USER opam
ENV LAMA_STDLIB=/home/opam/lama-stdlib
ENV PATH="/home/opam/lama-bin:${PATH}"
WORKDIR /work
ENTRYPOINT []
CMD ["bash"]

# Development tools for the homework. Lama installation above is unchanged.
USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       g++ cmake ninja-build clangd \
    && rm -rf /var/lib/apt/lists/*

# Colima preserves host ownership on bind mounts (this Mac uses 501:20).
ARG USER_UID=501
ARG USER_GID=20
RUN if ! getent group "${USER_GID}" >/dev/null; then \
        groupadd --gid "${USER_GID}" devcontainer; \
    fi \
    && usermod --uid "${USER_UID}" --gid "${USER_GID}" opam \
    && chown -R "${USER_UID}:${USER_GID}" /home/opam

USER opam
ENV PATH="/home/opam/.opam/4.14/bin:${PATH}"
WORKDIR /workspaces/homework-2

# Keep extra development tools after the cached OCaml installation/UID layers.
USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends bear gdb \
    && rm -rf /var/lib/apt/lists/*
USER opam
