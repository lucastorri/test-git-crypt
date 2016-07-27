#!/bin/bash

set -u

cd "$(dirname "$0")/.."

exit_code=0

for system in `ls -1 templates`; do
  for environment in `ls -1 "configs/$system" | grep -v default`; do
    echo "Testing $system:$environment"
    ./bin/render.sh "$system" "$environment" && echo 'OK' || exit_code=1
  done
done

exit $exit_code
