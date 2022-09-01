#!/bin/sh
#
# Create a snapshot.
#

#
# Usage.
#
usage() {
  cat <<- EOF
  Usage: $(basename "${0}") [OPTIONS]

  Options:
  -h      This help output.
  -r      The root directory for data (e.g.: ~/.gaia).
  -b      Binary (e.g.: gaiad).
  -t      Type (e.g.: pruned or archive).
  -s      RPC Status URL (e.g.: http://localhost:26657/status).
EOF
  exit 1
}

#
# Create backup.
#
create_backup() {
  ROOT="${1}" \
  BINARY="${2}" \
  TYPE="${3}" \
  STATUS_URL="${4}" \
  make cosmos-snapshot
}

#
# Run.
#
run() {
  create_backup "${1}" "${2}" "${3}" "${4}"
}

while getopts ":hr:b:t:s:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    r)
      r=${OPTARG:-"~/.gaia"}
      ;;
    b)
      b=${OPTARG:-"gaiad"}
      ;;
    t)
      t=${OPTARG:-"default"}
      ;;
    s)
      s=${OPTARG:-"http://localhost:26657/status"}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

run "${r}" "${b}" "${t}" "${s}"
