#!/usr/bin/env bash

DEPS_LIST=("terraform")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

if [ ! -f "lambda.zip" ]; then
  echo "Required file not found - lambda.zip, execute build.sh first"
  exit 1
fi

terraform init -input=false terraform/
terraform apply -input=false -auto-approve terraform/
