#!/usr/bin/env bash

export AWS_PROFILE="personal"

aws lambda invoke --function-name app_employees output.json
