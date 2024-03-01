#!/bin/bash -el

function help() {
  echo "$(basename "${0}")"
}

for OPT in "$@"; do
  case $OPT in
    "--bool" | "-b") BOOL=true; shift;;
    "--help" | "-h") help; exit 0; shift;;
    -*)       echo "Unknown option: $1"
             help
             exit 1
  esac
done
