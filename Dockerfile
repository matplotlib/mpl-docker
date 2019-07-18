FROM ubuntu:xenial
MAINTAINER MPL developers

# Install apt packages (from https://github.com/matplotlib/matplotlib/blob/master/.circleci/config.yml)
RUN apt-get -qq update && \
    apt-get install -y \
      inkscape \
      ffmpeg \
      dvipng \
      lmodern \
      cm-super \
      texlive-latex-base \
      texlive-latex-extra \
      texlive-fonts-recommended \
      texlive-latex-recommended \
      texlive-pictures \
      texlive-xetex \
      graphviz \
      libgeos-dev \
      fonts-crosextra-carlito \
      fonts-freefont-otf

# Extra utility packages used below and interactively later
RUN apt-get install -y \
      wget \
      bzip2 \
      git \
      make \
      build-essential \
      bzip2 \
      gcc \
      g++ \
      libpng12-dev

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
RUN conda install python=3.7 pip

# Install MPL docs and testing dependencies
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/doc/doc-requirements.txt
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/testing/travis_all.txt

# Fonts
RUN mkdir -p $HOME/.local/share/fonts
RUN wget -nc "https://github.com/google/fonts/blob/master/ofl/felipa/Felipa-Regular.ttf?raw=true" -O "$HOME/.local/share/fonts/Felipa-Regular.ttf" || true
RUN if [ ! -f "$HOME/.local/share/fonts/Humor-Sans.ttf" ]; then \
      wget "https://mirrors.kernel.org/ubuntu/pool/universe/f/fonts-humor-sans/fonts-humor-sans_1.0-1_all.deb" && \
      mkdir tmp && \
      dpkg -x fonts-humor-sans_1.0-1_all.deb tmp && \
      cp tmp/usr/share/fonts/truetype/humor-sans/Humor-Sans.ttf $HOME/.local/share/fonts && \
      rm -rf tmp; \
    else \
      echo "Not downloading Humor-Sans; file already exists."; \
    fi
RUN fc-cache -f -v
ENV MPLLOCALFREETYPE 1
