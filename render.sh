#!/bin/bash

set -ue

cd `dirname "$0"`

render-template() {
  local template_file="$1"
  eval "echo \"$(cat "$template_file")\""
}

readonly system="$1"
readonly environment="$2"

readonly def_keys_file="configs/$system/default"
readonly env_keys_file="configs/$system/$environment"

readonly templates_source="templates/$system"

readonly rendered_output="rendered/$system-$environment"

mkdir -p "$rendered_output"

source "$def_keys_file"
source "$env_keys_file"

for template in `find "$templates_source" -type f`; do
  rendered_template_path="${template/$templates_source\//}"
  rendered_output_file="$rendered_output/$rendered_template_path"
  mkdir -p "$(dirname "$rendered_output_file")"
  render-template "$template" > "$rendered_output_file"
done
