#!/bin/bash

set -u

cd "$(dirname "$0")/.."

for system in `ls -1 templates`; do
  for environment in `ls -1 "configs/$system" | grep -v default`; do

    ./bin/render.sh "$system" "$environment"
    output_dir_name="$system-$environment"
    output_dir_tgz="rendered/$output_dir_name.tar.gz"
    tar -C "rendered/$output_dir_name" -zcf "$output_dir_tgz" .

    rendered_output="rendered/$output_dir_name.sh"

    key=`cat "configs/$system/$environment" | pcregrep -o1 '#key=(.*)'`
    if [ ! -z "$key" ]; then
      encoded_file=`openssl enc -e -des3 -A -base64 -in "$output_dir_tgz" -pass "pass:$key"`
      echo "#content $encoded_file" > "$rendered_output"

      cat >> "$rendered_output" <<- EOM
# https://www.openssl.org/docs/manmaster/apps/openssl.html#Pass-Phrase-Options
pcregrep -o1 '#content\s(.*)' "\$0" | openssl enc -d -des3 -base64 -A -pass "\$1"
EOM
      chmod +x "$rendered_output"

    fi

  done
done
