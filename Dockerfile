FROM ubuntu:xenial
MAINTAINER MPL developers

# Install apt packages (from https://github.com/matplotlib/matplotlib/blob/master/.circleci/config.yml)
RUN apt -qq update && \
    apt install -y \
      inkscape \
      ffmpeg \
      dvipng \
      lmodern \
      cm-super \
      texlive-latex-base \
      texlive-latex-extra \
      texlive-fonts-recommended \
      texlive-latex-recommended \
      texlive-luatex \
      texlive-pictures \
      texlive-xetex \
      graphviz \
      libgeos-dev \
      fonts-crosextra-carlito \
      fonts-freefont-otf \
      fonts-humor-sans

# Extra utility packages used below and interactively later
RUN apt install -y \
      wget \
      bzip2 \
      git \
      make \
      build-essential \
      bzip2 \
      gcc \
      g++

# Create a user, since we don't want to run as root
ENV USER mpl
RUN useradd -m $USER
ENV HOME /home/$USER
WORKDIR $HOME
USER $USER

# Add the conda binary folder to the path
ENV PATH $HOME/miniconda/bin:$PATH

# Install miniconda and python
RUN cd && \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh --no-verbose && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda && \
    rm Miniconda*.sh
ENV PYTHONUNBUFFERED 1
RUN conda install -y python=3.7 pip

# Install MPL docs and testing dependencies
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/doc/doc-requirements.txt
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/testing/travis_all.txt

# Fonts
RUN mkdir -p $HOME/.local/share/fonts
RUN wget -nc "https://github.com/google/fonts/blob/master/ofl/felipa/Felipa-Regular.ttf?raw=true" -O "$HOME/.local/share/fonts/Felipa-Regular.ttf" || true
RUN fc-cache -f -v
ENV MPLLOCALFREETYPE 1
