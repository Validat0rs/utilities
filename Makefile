TYPE?="pruned"

cosmos-snapshot:
	@./scripts/cosmos/snapshot.sh -r $(ROOT) -b $(BINARY) -t $(TYPE)

cosmos-testnet:
	@./scripts/cosmos/testnet.sh -r $(ROOT) -s $(DEFAULT_DENOM) -c $(CHAIN_ID) -m $(MONIKER) -b $(BINARY) -g $(GAS_LIMIT)

provider-aws-copy:
	@./scripts/provider/aws/copy.sh -b $(BUCKET_NAME) -l $(LOCAL_FILE) -r $(REMOTE_FILE)

provider-hetzner-copy:
	@./scripts/provider/hetzner/copy.sh -u $(USERNAME) -l $(LOCAL_FILE) -r $(REMOTE_FILE)

snapshot-copy:
	@./scripts/snapshot_copy.sh -r $(ROOT) -b $(BINARY) -n $(NETWORK) -p $(PROJECT) -t $(TYPE) -a $(BUCKET_NAME) -u $(USERNAME)
