#!/bin/sh
#short-name: mvrepo
#interactive-shell: .

mv $1 "_$2"
cd "_$2"
find . -type f -name '*.pyc' -exec rm {} +
git checkout master
git pull
