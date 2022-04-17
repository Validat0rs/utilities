# Utilities

A collection of utilities for application-specific blockchains built with the Cosmos SDK.

## Testnets

See [here](TESTNETS.md) for instructions on how to launch a single-node testnet.

## Snapshots

See [here](SNAPSHOTS.md) for scripts to generate a backup of a given Cosmos chain and ship that backup to AWS S3 or Hetzner Storage Box. 

We *strongly* recommend only performing this on a full node and *not* a validator, as the process will stop the daemon. 
