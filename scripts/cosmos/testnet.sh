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
  -r      The root directory for config and data (e.g.: ~/.gaia).
  -s      Default denom (e.g.: uatom).
  -c      Chain ID.
  -m      Genesis moniker.
  -b      Binary (e.g.: gaiad).
  -g      Block gas limit (should mirror mainnet).
EOF
  exit 1
}

#
# Setup
#
setup() {
  ROOT="${1}"
  DEFAULT_DENOM="${2}"
  CHAIN_ID="${3}"
  MONIKER="${4}"
  BINARY="${5}"
  GAS_LIMIT="${6}"
}

#
# Init chain.
#
init_chain() {
  $BINARY init --chain-id "$CHAIN_ID" "$MONIKER"
  sed -i "s/\"stake\"/\"$DEFAULT_DENOM\"/" "$GENESIS_FILE"
  sed -i 's/"time_iota_ms": "1000"/"time_iota_ms": "10"/' "$GENESIS_FILE"
  sed -i 's/"max_gas": "-1"/"max_gas": "'"$GAS_LIMIT"'"/' "$GENESIS_FILE"
  sed -i 's/keyring-backend = "os"/keyring-backend = "test"/' "${ROOT}"/config/client.toml
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
# Add genesis account.
#
add_genesis_account() {
  $BINARY add-genesis-account validator "1000000000000$DEFAULT_DENOM" --keyring-backend test
}

#
# Genesis Txn.
#
gentx() {
  $BINARY gentx validator "25000000000$DEFAULT_DENOM" --chain-id="$CHAIN_ID" --amount="25000000000$DEFAULT_DENOM" --keyring-backend test
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

  GENESIS_FILE="${ROOT}"/config/genesis.json
  if [ -f "$GENESIS_FILE" ]; then
    clear
    printf "\nGenesis already exists!?\n"
    exit 0
  fi

  init_chain
  add_validator
  add_genesis_account
  gentx
  collect_gentx
  display_summary
}

while getopts ":hr:s:c:m:b:g:" opt; do
  case "${opt}" in
    h)
      usage
      ;;
    r)
      r=${OPTARG:-"~/.gaia"}
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
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${r}" ] ||
    [ -z "${s}" ] ||
    [ -z "${c}" ] ||
    [ -z "${m}" ] ||
    [ -z "${b}" ] ||
    [ -z "${g}" ]; then
  usage
fi

run "${r}" "${s}" "${c}" "${m}" "${b}" "${g}"
