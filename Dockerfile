FROM ubuntu:xenial
MAINTAINER MPL developers

# Install apt packages
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

RUN apt-get install -y wget bzip2

# Add the conda binary folder to the path
ENV PATH /opt/conda/bin:$PATH

# Install miniconda
RUN cd && \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh --no-verbose && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda*.sh

ENV CONDARC_PATH /opt/conda/.condarc
ENV CONDARC $CONDARC_PATH
ENV PYTHONUNBUFFERED 1

RUN conda install python=3.7 pip

# Install MPL docs and testing dependencies
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/doc/doc-requirements.txt
RUN pip install -vr https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/testing/travis_all.txt

# Create a user, since we don't want to run as root
ENV USER=mpl
RUN useradd -m $USER
ENV HOME=/home/$USER
WORKDIR $HOME
USER $USER

RUN mkdir -p ~/.local/share/fonts
RUN wget -nc "https://github.com/google/fonts/blob/master/ofl/felipa/Felipa-Regular.ttf?raw=true" -O ~/.local/share/fonts/Felipa-Regular.ttf || true \
    if [ ! -f ~/.local/share/fonts/Humor-Sans.ttf ]; then \
      wget https://mirrors.kernel.org/ubuntu/pool/universe/f/fonts-humor-sans/fonts-humor-sans_1.0-1_all.deb \
      mkdir tmp \
      dpkg -x fonts-humor-sans_1.0-1_all.deb tmp \
      cp tmp/usr/share/fonts/truetype/humor-sans/Humor-Sans.ttf ~/.local/share/fonts \
      rm -rf tmp \
    else \
      echo "Not downloading Humor-Sans; file already exists." \
    fi \
    fc-cache -f -v
