#!/usr/bin/env bash

curl -i -s -H "Content-Type: application/json" -X POST \
  -d '{"id":"3", "name":"Eva", "surname": "Brown", "org": "NSA"}' \
  "$(terraform output invoke_url)/employees"
