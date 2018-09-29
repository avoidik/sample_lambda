#!/usr/bin/env bash

curl -s "$(terraform output invoke_url)/employees?id=$1"
