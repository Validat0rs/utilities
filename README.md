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
make cosmos-testnet
```

where:

|Param|Description|
|-----|-----------|
|`<home>`|The directory for config and data (e.g.: `~/.gaia`)|
|`<default_denom>`|The default denomination for the network (e.g.: `uatom`).|
|`<chain_id>`|The Chain ID (e.g.: `testnet-1`).|
|`<moniker>`|The moniker of the genesis node (e.g.: `node01`).|
|`<binary>`|The binary name (e.g.: `gaiad`).|
|`<gas_limit>`|The block gas limit (e.g.: `100000000`).|

e.g.:

```console
HOME=~/.gaiad \
DEFAULT_DENOM=uatom \
CHAIN_ID=testnet-1 \
MONIKER=node01 \
BINARY=gaiad \
GAS_LIMIT=100000000 \
make cosmos-testnet
```

### Troubleshooting

Ensure that you have compiled the appropriate Cosmos SDK binary (e.g.: `gaiad`, `junod` etc) before attempting to setup a testnet.
