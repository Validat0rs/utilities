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
  -b      Binary (e.g.: gaiad).\
  -t      Type (e.g.: pruned or archive).
  -s      RPC Status URL (e.g.: http://localhost:26657/status)
EOF
  exit 1
}

#
# Stop cosmovisor
#
cosmovisor_stop() {
  HEIGHT=$(curl -s "${1}" | jq ".result.sync_info.latest_block_height" | xargs)
  sudo service cosmovisor stop
}

#
# Still running?
#
check_process() {
  PIDOF=$(pidof "${1}")
}

#
# Backup name.
#
backup_name() {
  BACKUP_NAME="${1}"_"${2}"_"${HEIGHT}"
}

#
# Create backup.
#
create_backup() {
  if [ ! -d "${1}/backups" ]; then
    mkdir "${1}/backups" || exit 1
  fi
  tar cvf - data/ | lz4 - "${1}/backups/${BACKUP_NAME}".tar.lz4
}

#
# Start cosmovisor
#
cosmovisor_start() {
  sudo service cosmovisor start
}

#
# Run
#
run() {
  printf "stopping cosmovisor...\n"
  cosmovisor_stop "${4}"
  sleep 10

  printf "checking that cosmovisor has stopped...\n"
  check_process "${2}"
  if [ "${PIDOF}" != "" ]; then
    printf "%s is still running!?\n" "${2}"
    exit 1
  fi

  backup_name "${2}" "${3}"

  cd "${1}" || exit 1
  if [ ! -d "data" ]; then
    printf "data directory does not exist!?\n"
    exit 1
  fi

  printf "creating backup...\n"
  create_backup "${1}"

  printf "starting cosmovisor...\n"
  cosmovisor_start
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
      s=${OPTARG:-"http://loalhost:26657/status"}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

run "${r}" "${b}" "${t}" "${s}"
