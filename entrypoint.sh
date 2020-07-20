#!/bin/bash

git clone https://github.com/matplotlib/matplotlib
pip install -ve ./matplotlib
make -C matplotlib/doc html
python -m http.server -d matplotlib/doc/build/html/
