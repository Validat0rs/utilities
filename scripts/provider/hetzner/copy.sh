#!/bin/sh
#
# Copy files (via SCP) to a Hetzner Storage Box.
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
  scp -P 23 "${2}" "${1}"@"${1}".your-storagebox.de:"${3}"
}

while getopts ":hu:l:r:" opt; do
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
    [ -z "${r}" ]; then
  usage
fi

run "${u}" "${l}" "${r}"
