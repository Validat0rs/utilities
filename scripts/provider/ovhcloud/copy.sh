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
  -u      Username.
  -l      Local file.
  -s      Remote host.
  -r      Remote file.
EOF
  exit 1
}

#
# Run
#
run() {
  if [ ! -f "${2}" ]; then
    printf "file does not exist!?\n"
    exit 1
  fi

  printf "copying...\n"
  scp -P 23 "${2}" "${1}"@"${3}":"${4}"
}

while getopts ":hu:l:s:r:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    u)
      u=${OPTARG}
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

if [ -z "${u}" ] ||
    [ -z "${l}" ] ||
    [ -z "${s}" ] ||
    [ -z "${r}" ]; then
  usage
fi

run "${u}" "${l}" "${s}" "${r}"
