FROM ubuntu:20.04 AS stage1

RUN apt-get update && apt-get install -y \
    bzip2 \
    ca-certificates \
    curl \
    && rm -rf /var/lib/{apt,dpkg,cache,log}
RUN curl -L https://micro.mamba.pm/api/micromamba/linux-64/latest | \
    tar -xj -C /tmp bin/micromamba

FROM ubuntu:20.04
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV MAMBA_ROOT_PREFIX=/opt/conda

# Use bash in RUN commands and make sure bashrc is sourced when executing commands with /bin/bash -c
# Needed to have the micromamba activate command configured etc.
ENV BASH_ENV ~/.bashrc
SHELL ["/bin/bash", "-c"]

COPY --from=stage1 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=stage1 /tmp/bin/micromamba /bin/micromamba

RUN ln -s /bin/micromamba /bin/mamba && \
    ln -s /bin/micromamba /bin/conda && \
    ln -s /bin/micromamba /bin/miniconda && \
    mkdir -p $(dirname $MAMBA_ROOT_PREFIX) && \
    /bin/micromamba shell init -s bash -p $MAMBA_ROOT_PREFIX && \
    echo "micromamba activate base" >> ~/.bashrc

RUN micromamba install -v -y -n base -c conda-forge \
    "python>=3.7"       \
    "pip"               \
    "fastapi"           \
    "typer"             \
    "authlib"           \
    "psycopg2"          \
    "httpx=0.16.0"      \
    "sqlalchemy<1.4.0"  \
    "sqlalchemy-utils"  \
    "sqlite"            \
    "python-multipart"  \
    "uvicorn"           \
    "zstandard"         \
    "conda-build"       \
    "appdirs"           \
    "toml"              \
    "quetz-client"      \
    "fsspec"            \
    "requests"          \
    "h2<4.0.0"          \
    "pluggy"            \
    "jinja2"            \
    "itsdangerous"      \
    "alembic"           \
    "zchunk"            \
    "s3fs"              \
    "sphinx"            \
    "sphinx-book-theme" \
    "tenacity"          \
    "xattr"             \
    "aiofiles"          \
    "pyyaml"            \
    "ujson"             \
    "prometheus_client" \
    "typing_extensions" \
    "pamela"            \
    "xonsh"             \
    "git"               \
    "importlib_metadata" \
    && rm -rf /opt/conda/pkgs/cache/*

ENV PATH="/opt/conda/bin:${PATH}"
ENV LANG=en_US.UTF-8

ARG QUETZ_USER=quetz
ARG QUETZ_UID=1000

ENV USER ${QUETZ_USER}
ENV HOME /home/${QUETZ_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${QUETZ_UID} \
    ${QUETZ_USER}
COPY wait-for-it.sh /usr/bin/wait-for-it.sh

RUN micromamba install -n base -y jupyter-packaging yarn nodejs -c conda-forge

RUN mkdir /quetz_frontend
COPY quetz-frontend/ /quetz_frontend/quetz-frontend
COPY mamba-pm-frontend/ /quetz_frontend/mamba-pm-frontend

RUN cd /quetz_frontend/quetz-frontend && rm -rf yarn.lock && yarn install  --network-timeout=1000000 && yarn run build:prod
RUN cd /quetz_frontend/mamba-pm-frontend && rm -rf yarn.lock && yarn install --network-timeout=1000000 && yarn run build:prod
RUN cp -r /quetz_frontend/quetz-frontend /tmp/
RUN cd /quetz_frontend/mamba-pm-frontend && pip install . -v --no-cache

ADD quetz/ /tmp/quetz
RUN python3 -m pip install --no-cache /tmp/quetz/
RUN cd /tmp/quetz/plugins/quetz_runexports && pip install . --no-cache
RUN cd /tmp/quetz/plugins/quetz_repodata_patching && pip install . --no-cache
RUN cd /tmp/quetz/plugins/quetz_current_repodata && pip install . --no-cache
RUN cd /tmp/quetz/plugins/quetz_transmutation && pip install . --no-cache
RUN pip install git+https://git@github.com/regro/libcflib@master --no-deps
RUN cd /tmp/quetz/plugins/quetz_harvester && pip install . --no-cache --no-deps

# TODO: use the CLI when available in the next release to set-up Quetz
CMD ["/bin/bash"]
