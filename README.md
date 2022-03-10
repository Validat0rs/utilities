# Utilities

A collection of general utilities for Validat0rs.

## Testnets

### Launch

To launch a testnet for any Cosmos SDK chain, simply run:

```console
HOME=<home> \
DEFAULT_DENOM=<default_denom> \
CHAIN_ID=<chain_id> \
MONIKER=<moniker> \
BINARY=<binary> \
GAS_LIMIT=<gas_limit> \
GENESIS_ACCOUNTS=<genesis_accounts> \
make cosmos-testnet
```

where:

|Param|Description|Required|
|-----|-----------|--------|
|`<home>`|The directory for config and data (e.g.: `~/.gaia`)|Yes|
|`<default_denom>`|The default denomination for the network (e.g.: `uatom`).|Yes|
|`<chain_id>`|The Chain ID (e.g.: `testnet-1`).|Yes|
|`<moniker>`|The moniker of the genesis node (e.g.: `node01`).|Yes|
|`<binary>`|The binary name (e.g.: `gaiad`).|Yes|
|`<gas_limit>`|The block gas limit (e.g.: `100000000`).|Yes|
|`<genesis_accounts>`|A comma-seperated list of additional genesis accounts to add.|No|

e.g.:

```console
HOME=~/.gaiad \
DEFAULT_DENOM=uatom \
CHAIN_ID=testnet-1 \
MONIKER=node01 \
BINARY=gaiad \
GAS_LIMIT=100000000 \
GENESIS_ACCOUNTS=cosmos19skpq685dyedh06ceszah28ch70x94jqrn09ts,cosmos1hwlqf64cxjzh69rdskz2hhwmkhpr4skakjvn4m \
make cosmos-testnet
```

### Troubleshooting

Ensure that you have compiled the appropriate Cosmos SDK binary (e.g.: `gaiad`, `junod` etc) before attempting to setup a testnet.
