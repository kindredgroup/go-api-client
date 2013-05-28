#!/bin/bash
set -x
BUNDLE_PATH=/tmp/.bundle-$(basename $(pwd))
if [ -z "$BUNDLE_PATH" ]
then
   BUNDLE_PATH=".bundle"
fi
bundle install --local --path $BUNDLE_PATH --binstubs --clean
