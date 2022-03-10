#!/bin/sh
#
# Launch a new Testnet.
#

#
# Usage.
#
usage() {
  cat <<- EOF
  Usage: $(basename "${0}") [OPTIONS]

  Options:
  -h      This help output.
  -o      Home (e.g.: ~/.gaia).
  -s      Default denom (e.g.: uatom).
  -c      Chain ID.
  -m      Genesis moniker.
  -b      Binary (e.g.: gaiad).
  -g      Block gas limit (should mirror mainnet).
  -a      Additional genesis accounts (optional).
EOF
  exit 1
}

#
# Setup
#
setup() {
  HOME_DIR="${1}"
  DEFAULT_DENOM="${2}"
  CHAIN_ID="${3}"
  MONIKER="${4}"
  BINARY="${5}"
  GAS_LIMIT="${6}"
  GENESIS_ADDRESSES="${7}"
}

#
# Init chain.
#
init_chain() {
  $BINARY init --chain-id "$CHAIN_ID" "$MONIKER"
  sed -i "s/\"stake\"/\"$DEFAULT_DENOM\"/" "$GENESIS_FILE"
  sed -i 's/"time_iota_ms": "1000"/"time_iota_ms": "10"/' "$GENESIS_FILE"
  sed -i 's/"max_gas": "-1"/"max_gas": "'"$GAS_LIMIT"'"/' "$GENESIS_FILE"
  sed -i 's/keyring-backend = "os"/keyring-backend = "test"/' "${HOME_DIR}"/config/client.toml
}

#
# Add validator.
#
add_validator() {
  $BINARY keys add validator --keyring-backend test --output json > output.json 2>&1
  ADDRESS=$(cat output.json | jq -r .address)
  MNEMONIC=$(cat output.json | jq -r .mnemonic)
  rm -rf ./mnemonic.json
}

#
# Add genesis accounts.
#
add_genesis_accounts() {
  $BINARY add-genesis-account validator "1000000000$DEFAULT_DENOM" --keyring-backend test

  for i in $(echo "${GENESIS_ACCOUNTS}" | tr ',' '\n'); do
    $BINARY add-genesis-account "$i" "1000000000$DEFAULT_DENOM"
  done
}

#
# Genesis Txn.
#
gentx() {
  $BINARY gentx validator "250000000$DEFAULT_DENOM" --chain-id="$CHAIN_ID" --amount="250000000$DEFAULT_DENOM" --keyring-backend test
}

#
# Collect Genesis Txns.
#
collect_gentx() {
  $BINARY collect-gentxs
}

#
# Display summary
#
display_summary() {
  cat <<- EOF

Summary
========
The testnet has been setup.

Validator
---------
Address:          ${ADDRESS}
Mnemonic:         ${MNEMONIC}

EOF
  printf "\n\n"
}

#
# Run.
#
run() {
  setup "$@"

  GENESIS_FILE="${HOME_DIR}"/config/genesis.json
  if [ -f "$GENESIS_FILE" ]; then
    clear
    printf "\nGenesis already exists!?\n"
    exit 0
  fi

  init_chain
  add_validator
  add_genesis_accounts
  gentx
  collect_gentx
  summary
}

while getopts ":ho:s:c:m:b:g:a:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    o)
      o=${OPTARG:-"~/.gaia"}
      ;;
    s)
      s=${OPTARG:-ustake}
      ;;
    c)
      c=${OPTARG:-testnet}
      ;;
    m)
      m=${OPTARG:-node01}
      ;;
    b)
      b=${OPTARG:-gaiad}
      ;;
    g)
      g=${OPTARG:-100000000}
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

if [ -z "${o}" ] ||
    [ -z "${s}" ] ||
    [ -z "${c}" ] ||
    [ -z "${m}" ] ||
    [ -z "${b}" ] ||
    [ -z "${g}" ]; then
  usage
fi

run "${o}" "${s}" "${c}" "${m}" "${b}" "${g}" "${a}"
