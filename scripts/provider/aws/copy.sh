#!/bin/sh
#
# Copy files to AWS S3.
#

#
# Usage.
#
usage() {
  cat <<- EOF
  Usage: $(basename "${0}") [OPTIONS]

  Options:
  -h      This help output.
  -b      Bucket name.
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
  aws s3 cp "${2}" s3://"${1}"/"${3}" --acl public-read
}

while getopts ":hb:l:r:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    b)
      b=${OPTARG}
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

if [ -z "${b}" ] ||
    [ -z "${l}" ] ||
    [ -z "${r}" ]; then
  usage
fi

run "${b}" "${l}" "${r}"
