# `alr publish` action

Uses `alr publish` to open a PR for the commit from which it is run at the
Alire community index. `alr` will be installed if not already available, but
not cleaned up afterwards.

After the PR tests run successfully, the action will create a release in the
repository. Optionally, only a regular git tag (or nothing) can be created instead.

See [action.yml](action.yml) for available options.

**Requires** a secret, which should be a personal access token with `repo`
scope. This is used to create the pull request in the index repository. The name
of the secret is given as an input to the action. (Note, there are no
user-level secrets, so you have to add one for each repository, unless they're
part of an organization, which do have org-level secrets.)