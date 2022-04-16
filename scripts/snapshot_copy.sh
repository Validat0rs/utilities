#!/bin/sh
#
# Create a snapshot and copy to AWS S3 and Hetzner Storage Box.
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
  -t      Type (e.g.: pruned or archive).
  -a      AWS S3 bucket name.
  -u      Hetzner Storage Box username.
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
  make -C ../ cosmos-snapshot
}

#
# Copy to AWS S3.
#
copy_s3() {
  BUCKET_NAME="${1}" \
  LOCAL_FILE="${2}" \
  REMOTE_FILE="${3}" \
  make -C ../ provider-aws-copy
}

#
# Copy to Hetzner Storage Box.
#
copy_sb() {
  USERNAME="${1}" \
  LOCAL_FILE="${2}" \
  REMOTE_FILE="${3}" \
  make -C ../ provider-hetzner-copy
}

#
# Run.
#
run() {
  backup_name "${1}"
  create_backup "${1}" "${2}" "${4}"
  copy_s3 "${5}" "${1}"/backups/"${BACKUP_NAME}".tar.lz4 "${3}/${3}-latest.tar.lz4"
  copy_sb "${6}" "${1}"/backups/"${BACKUP_NAME}".tar.lz4 "${3}/${BACKUP_NAME}".tar.lz4

  rm "${1}"/backups/"${BACKUP_NAME}".tar.lz4
}

while getopts ":hr:b:n:t:a:u:" opt; do
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
    t)
      t=${OPTARG:-"default"}
      ;;
    a)
      a=${OPTARG}
      ;;
    u)
      u=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${a}" ] ||
    [ -z "${u}" ]; then
  usage
fi

run "${r}" "${b}" "${n}" "${t}" "${a}" "${u}"
