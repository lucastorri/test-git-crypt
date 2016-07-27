#!/bin/bash

set -u

cd `dirname "$0"`/..

failed=false

for system in `ls -1 templates`; do
  for environment in `ls -1 "configs/$system" | grep -v default`; do
    echo "Testing $system:$environment"
    ./bin/render.sh "$system" "$environment" || failed=true
    echo
  done
done

$failed && exit 1
