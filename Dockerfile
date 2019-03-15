FROM jupyter/tensorflow-notebook

# Radare version
ARG R2_VERSION=master
# R2pipe python version
ARG R2_PIPE_PY_VERSION=0.8.9
# R2pipe node version
ARG R2_PIPE_NPM_VERSION=2.3.2

ENV R2_VERSION ${R2_VERSION}
ENV R2_PIPE_PY_VERSION ${R2_PIPE_PY_VERSION}
ENV R2_PIPE_NPM_VERSION ${R2_PIPE_NPM_VERSION}

USER root

RUN echo -e "Building versions:\n\
  R2_VERSION=$R2_VERSION\n\
  R2_PIPE_PY_VERSION=${R2_PIPE_PY_VERSION}\n\
  R2_PIPE_NPM_VERSION=${R2_PIPE_NPM_VERSION}"

# Build radare2 in a volume to minimize space used by build
VOLUME ["/mnt"]

# Install all build dependencies
# Install bindings
# Build and install radare2 on master branch
# Remove all build dependencies
# Cleanup
# Install all build dependencies
# Install bindings
# Build and install radare2 on master branch
# Remove all build dependencies
# Cleanup
RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
  curl \
  gcc \
  git \
  bison \
  pkg-config \
  make \
  glib-2.0 \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  gnupg2 \
  sudo && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs python-pip && \
  pip install r2pipe=="$R2_PIPE_PY_VERSION" && \
  npm install --unsafe-perm -g "r2pipe@$R2_PIPE_NPM_VERSION" && \
  cd /mnt && \
  git clone -b "$R2_VERSION" -q --depth 1 https://github.com/radare/radare2.git && \
  cd radare2 && \
  ./sys/install.sh && \
  make install && \
  apt-get install -y xz-utils && \
  apt-get remove --purge -y \
  bison \
  python-pip \
  glib-2.0 && \
  apt-get autoremove --purge -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup r2pm
RUN r2pm init && \
  r2pm update && \
  chown -R $NB_UID:$NB_UID /home/jovyan


RUN mkdir -p /home/jovyan/.jupyter/custom/
RUN curl https://raw.githubusercontent.com/powerpak/jupyter-dark-theme/master/custom.css > /home/jovyan/.jupyter/custom/custom.css
RUN conda install --yes gensim

USER $NB_UID

