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
  create_backup "${1}" "${2}" "${5}"

  backup_name=$(ls "${1}/backups/*")
  latest=$(mktemp)
  cat << EOF > "${latest}"
${backup_name}
EOF

  copy_s3 "${6}" "${1}"/backups/"${backup_name}" "${3}"/"${4}"/"${backup_name}"
  copy_s3 "${6}" "${latest}" "${3}"/"${4}"/latest.txt

  rm "${1}"/backups/"${backup_name}"
  rm "${latest}"
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
