#!/bin/sh
#
# Create a snapshot and copy to AWS S3.
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
  -n      Network (e.g.: cosmoshub).
  -p      Project.
  -t      Type (e.g.: pruned or archive).
  -a      AWS S3 bucket name.
EOF
  exit 1
}

#
# Backup name.
#
backup_name() {
  BACKUP_NAME="${1}"-$(date +%Y-%m-%d)-"${2}"
}

#
# Create backup.
#
create_backup() {
  ROOT="${1}" \
  BINARY="${2}" \
  TYPE="${3}" \
  make cosmos-snapshot
}

#
# Copy to AWS S3.
#
copy_s3() {
  BUCKET_NAME="${1}" \
  LOCAL_FILE="${2}" \
  REMOTE_FILE="${3}" \
  make provider-aws-copy
}

#
# Run.
#
run() {
  backup_name "${2}" "${5}"
  create_backup "${1}" "${2}" "${5}"
  copy_s3 "${6}" "${1}"/backups/"${BACKUP_NAME}".tar.lz4 "${3}"/"${4}"/"${3}"-"${5}"-latest.tar.lz4

  if [ -n "${COPY_TO_DEFAULT}" ]; then
    copy_s3 "${6}" s3://"${6}"/"${3}"/"${4}"/"${3}"-latest.tar.lz4 "${3}"/default/"${3}"-"${5}"-latest.tar.lz4
  fi

  rm "${1}"/backups/"${BACKUP_NAME}".tar.lz4
}

while getopts ":hr:b:n:p:t:a:" opt; do
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
    n)
      n=${OPTARG:-"cosmoshub"}
      ;;
    p)
      p=${OPTARG}
      ;;
    t)
      t=${OPTARG:-"default"}
      ;;
    a)
      a=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${p}" ] ||
    [ -z "${a}" ]; then
  usage
fi

run "${r}" "${b}" "${n}" "${p}" "${t}" "${a}"
