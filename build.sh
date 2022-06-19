#!/usr/bin/env sh

\cp -r ./content/assets ./

emacs -Q --script build.el
