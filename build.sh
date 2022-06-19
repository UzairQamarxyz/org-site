#!/usr/bin/env sh

\cp -r ./content/assets ./public/assets/ &&
	emacs -Q --script build.el
