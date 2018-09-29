#!/usr/bin/env bash

DEPS_LIST=("go" "chmod" "zip")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

env GOOS=linux GOARCH=amd64 go build -o build/main employees/*

if [[ "$OSTYPE" == "msys" ]]; then
  build-lambda-zip -o lambda.zip build/main
else
  chmod +x build/main
  zip -j lambda.zip build/main
fi
