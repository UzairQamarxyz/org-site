#!/usr/bin/env sh

mkdir -p ./public/ &&
	\cp -r ./content/assets ./public/assets/ &&
	emacs -Q --script build.el
