# `alr publish` action

Uses `alr publish` publish the commit from which it is run to the Alire
community index (by default). `alr` will be installed if not already available,
but not cleaned up afterwards.

See [action.yml](action.yml) for available options.

**Requires** a secret in the user or repository named `ALIRE_PUBLISH_PAT`, which
should be a personal access token with `repo` scope. This is used to create a
pull request in the index repository.