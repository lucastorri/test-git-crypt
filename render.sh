#!/bin/bash

set -ue

source secretfile

render-template() {
  eval "echo \"$(cat $1)\""
}

render-template "$1"
