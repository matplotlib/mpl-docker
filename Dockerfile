FROM python:3.7
MAINTAINER MPL developers

# Install apt packages (from https://github.com/matplotlib/matplotlib/blob/master/.circleci/config.yml)
RUN apt -qq update && \
    apt install -y \
      cm-super \
      dvipng \
      ffmpeg \
      fonts-crosextra-carlito \
      fonts-freefont-otf \
      fonts-humor-sans \
      graphviz \
      inkscape\
      lmodern \
      optipng\
      texlive-fonts-recommended \
      texlive-latex-base \
      texlive-latex-extra \
      texlive-latex-recommended \
      texlive-luatex \
      texlive-pictures \
      texlive-xetex \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED 1

# Install MPL docs and testing dependencies
RUN pip install --no-cache-dir \
        -r https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/doc/doc-requirements.txt \
        -r https://raw.githubusercontent.com/matplotlib/matplotlib/master/requirements/testing/travis_all.txt \
        cycler kiwisolver numpy pillow pyparsing python-dateutil

# Fonts
RUN mkdir -p $HOME/.local/share/fonts
RUN wget -nc "https://github.com/google/fonts/blob/master/ofl/felipa/Felipa-Regular.ttf?raw=true" -O "$HOME/.local/share/fonts/Felipa-Regular.ttf" || true
RUN fc-cache -f -v

# Switch back to normal shell for now.
CMD [ "/bin/bash" ]
