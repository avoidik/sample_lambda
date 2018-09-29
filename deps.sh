#!/usr/bin/env bash

DEPS_LIST=("glide" "go")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

glide up
