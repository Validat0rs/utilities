cosmos-testnet:
	@./scripts/cosmos/testnet.sh -r $(ROOT) -s $(DEFAULT_DENOM) -c $(CHAIN_ID) -m $(MONIKER) -b $(BINARY) -g $(GAS_LIMIT)
