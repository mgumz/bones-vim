#!/bin/bash

case "$1" in
    zipball)
        ARCHIVE="zipball-$(date +'%Y-%d-%mT%H:%M%:%S').zip"
        git archive --format zip -v -o "$ARCHIVE" HEAD
        zip -9 -r -u "$ARCHIVE" pack -x "*.zip" -x "*.tar.gz"
        ;;
esac
