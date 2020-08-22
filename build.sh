#!/usr/bin/env sh

# abort on errors
set -e

# start dart-sass and pass script arguments to it
sass ./src/main.scss ./dist/main.css $@