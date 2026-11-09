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

# gcc-multilib supplies the legacy -m32 build instead of opam depexts.
RUN opam pin add Lama . --no-action --yes \
    && opam install Lama --deps-only --yes --jobs=4 --no-depexts

# The VM requires Clang musttail; opam clears MAKEFLAGS but keeps GNUMAKEFLAGS.
RUN GNUMAKEFLAGS=CC=clang opam install Lama --yes --jobs=4 --no-depexts \
    && mkdir -p /home/opam/lama-bin \
    && ln -s "$(opam var bin)/lamac" /home/opam/lama-bin/lamac \
    && ln -s "$(opam var bin)/lamavm" /home/opam/lama-bin/lamavm \
    && opam list --installed --columns=name,version > /home/opam/lama-packages.txt

RUN ln -s "$(opam var share)/Lama/x64" /home/opam/lama-stdlib
USER root
RUN chmod 755 /home/opam
USER opam
ENV LAMA_STDLIB=/home/opam/lama-stdlib
ENV PATH="/home/opam/lama-bin:${PATH}"
WORKDIR /work
ENTRYPOINT []
CMD ["bash"]

USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       g++ cmake ninja-build clangd \
    && rm -rf /var/lib/apt/lists/*

# Match host ownership on Colima bind mounts.
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
