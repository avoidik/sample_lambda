#!/usr/bin/env bash

DEPS_LIST=("terraform")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

terraform destroy -input=false -auto-approve terraform/

if [ -f "lambda.zip" ]; then
  rm -f ./lambda.zip
fi
