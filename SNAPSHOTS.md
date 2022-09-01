# Snapshots

## Prerequisites

### AWS

* [AWS CLI](https://aws.amazon.com/cli/)
* Generated and configured your access keys.
* Setup an S3 Bucket on your AWS account, with the appropriate access credentials.

### Hetzner

* Have an existing Storage Box on your Hetzner account.
* Configured your storage box for passwordless [login](https://docs.hetzner.com/robot/storage-box/access/access-ssh-rsync-borg/).

## Assumptions

It's assumed that you're running `cosmovisor` under `systemd`, as a non-privileged user.

## Generate

To generate a new snapshot, run:

```console
ROOT=<root_directory> \
BINARY=<binary> \
TYPE=<type> \
make cosmos-snapshot
```

where:

|Param|Description|
|-----|-----------|
|`<root_directory>`|The cosmos root directory (e.g.: `~/.gaiad`).|
|`<binary>`|The name of the running binary (e.g.: `gaiad`).|
|`<type>`|A label based on the type of node running (e.g.: `pruned` or `archive`).|

e.g.:

```console
ROOT=~/.gaiad \
BINARY=gaiad \
TYPE=pruned \
make cosmos-snapshot
```

## Sync

### AWS S3

To sync your newly created snapshot, run

```console
BUCKET_NAME=<bucket_name> \
LOCAL_FILE=<local_file> \
REMOTE_FILE=<remote_file> \
make provider-aws-copy
```

where:

|Param|Description|
|-----|-----------|
|`<bucket_name>`|The name of the bucket you setup (e.g.: `my-new-bucket`).|
|`<local_file>`|The path to the local file (e.g.: `~/snapshot.tar.lz4`).|
|`<remote_file>`|The upload path (e.g.: `cosmoshub/snapshot.tar.lz4`).|

e.g.:

```console
BUCKET_NAME=my-new-bucket \
LOCAL_FILE=~/snapshot.tar.lz4 \
REMOTE_FILE=cosmoshub/snapshot.tar.lz4 \
make provider-aws-copy
```

### Hetzner Storage Box

To sync your newly created snapshot, run

```console
USERNAME=<username> \
LOCAL_FILE=<local_file> \
REMOTE_FILE=<remote_file> \
make provider-hetzner-copy
```

where:

|Param|Description|
|-----|-----------|
|`<username>`|The username for accessing the Storage Box (e.g.: `user`).|
|`<local_file>`|The path to the local file (e.g.: `~/snapshot.tar.lz4`).|
|`<remote_file>`|The upload path (e.g.: `cosmoshub/snapshot.tar.lz4`).|

e.g.:

```console
USERNAME=user \
LOCAL_FILE=~/snapshot.tar.lz4 \
REMOTE_FILE=cosmoshub/snapshot.tar.lz4 \
make provider-hetzner-copy
```

### OVHCloud Storage Server

To sync your newly created snapshot, run

```console
USERNAME=<username> \
LOCAL_FILE=<local_file> \
REMOTE_HOST=<remove_host> \
REMOTE_FILE=<remote_file> \
make provider-ovhcloud-copy
```

where:

|Param| Description                                                |
|-----|------------------------------------------------------------|
|`<username>`| The username for accessing the Storage Box (e.g.: `user`). |
|`<local_file>`| The path to the local file (e.g.: `~/snapshot.tar.lz4`).   |
|`<remote_host>`| The storage server (e.g.: `storage.validat0.rs`).          |
|`<remote_file>`| The upload path (e.g.: `cosmoshub/snapshot.tar.lz4`).      |

e.g.:

```console
USERNAME=user \
LOCAL_FILE=~/snapshot.tar.lz4 \
REMOTE_HOST=storage.validat0.rs \
REMOTE_FILE=cosmoshub/snapshot.tar.lz4 \
make provider-ovhcloud-copy
```
