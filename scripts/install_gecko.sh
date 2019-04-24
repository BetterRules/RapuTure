#!/bin/bash
set -v

GECKO_URL="https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz"
rm -rf "$PWD/geckodriver"
mkdir -p "$PWD/geckodriver"
cd "$PWD/geckodriver" || exit 1
wget "$GECKO_URL"
tar -vzxf geckodriver-v0.24.0-linux64.tar.gz

which geckodriver
geckodriver --version
