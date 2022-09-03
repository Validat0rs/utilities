TYPE?="pruned"
RPC_STATUS_URL?="http://localhost:26657/status"

cosmos-snapshot:
	@./scripts/cosmos/snapshot.sh -r $(ROOT) -b $(BINARY) -l $(BACKUP_LABEL) -s $(RPC_STATUS_URL)

cosmos-testnet:
	@./scripts/cosmos/testnet.sh -r $(ROOT) -s $(DEFAULT_DENOM) -c $(CHAIN_ID) -m $(MONIKER) -b $(BINARY) -g $(GAS_LIMIT)

provider-aws-copy:
	@./scripts/provider/aws/copy.sh -b $(BUCKET_NAME) -l $(LOCAL_FILE) -r $(REMOTE_FILE)

provider-hetzner-copy:
	@./scripts/provider/hetzner/copy.sh -u $(USERNAME) -l $(LOCAL_FILE) -r $(REMOTE_FILE)

provider-ovhcloud-copy:
	@./scripts/provider/ovhcloud/copy.sh -l $(LOCAL_DIRECTORY) -s $(REMOTE_HOST) -r $(REMOTE_DIRECTORY)

snapshot:
	@./scripts/snapshot.sh -r $(ROOT) -b $(BINARY) -l $(BACKUP_LABEL) -s $(RPC_STATUS_URL)
