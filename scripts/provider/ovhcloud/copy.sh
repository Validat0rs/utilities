#!/bin/sh
#
# Copy files (via SCP) to a OVHCloud Storage Server.
#

#
# Usage.
#
usage() {
  cat <<- EOF
  Usage: $(basename "${0}") [OPTIONS]

  Options:
  -h      This help output.
  -l      Local directory (e.g.: ~/.gaia/backup).
  -s      Remote host.
  -r      Remote directory (e.g.: /var/www/html/gaia).
EOF
  exit 1
}

#
# Run
#
run() {
  printf "copying...\n"
  rsync -a --del "${1}"/ snapshots@"${2}":"${3}"
}

while getopts ":hl:s:r:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    l)
      l=${OPTARG}
      ;;
    s)
      s=${OPTARG}
      ;;
    r)
      r=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${l}" ] ||
    [ -z "${s}" ] ||
    [ -z "${r}" ]; then
  usage
fi

run "${l}" "${s}" "${r}"
