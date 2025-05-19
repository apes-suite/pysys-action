FROM debian:bookworm-slim
ENV PYENV_VERSION="v2025.2"

SHELL ["/bin/bash", "-c"]

ENV BASH_ENV=/etc/profile

RUN apt update && apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
      build-essential \
      gcc \
      gfortran \
      git \
      libfftw3-dev \
      openmpi-bin openmpi-common libopenmpi-dev \
      pkg-config \
      python3-dev \
      python3-full \
      python3-pip

RUN git clone --depth 1 --branch $PYENV_VERSION https://github.com/apes-suite/apes-pyenv.git
ENV VIRTUAL_ENV=$PWD/venv
RUN python3 -m venv --system-site-packages $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN $VIRTUAL_ENV/bin/pip install -r apes-pyenv/requirements.txt
RUN cp apes-pyenv/helper/env-freeze $VIRTUAL_ENV/bin
RUN cp apes-pyenv/helper/env-version $VIRTUAL_ENV/bin
RUN chmod +x $VIRTUAL_ENV/bin/env-freeze $VIRTUAL_ENV/bin/env-version
