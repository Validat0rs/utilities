GENESIS_ACCOUNTS?=cosmos19skpq685dyedh06ceszah28ch70x94jqrn09ts

cosmos-testnet:
	@./scripts/cosmos/testnet.sh -o $(HOME) -s $(DEFAULT_DENOM) -c $(CHAIN_ID) -m $(MONIKER) -b $(BINARY) -g $(GAS_LIMIT) -a $(GENESIS_ACCOUNTS)
