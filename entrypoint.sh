#!/bin/bash

git clone https://github.com/matplotlib/matplotlib
cd matplotlib/
pip install -ve .
cd doc/
make html
python -m http.server -d build/html/
