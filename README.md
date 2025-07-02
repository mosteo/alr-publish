# `alr publish` action

Uses `alr publish` publish the commit from which it is run to the Alire
community index (by default). `alr` will be installed if not already available,
but not cleaned up afterwards.

See [action.yml](action.yml) for available options.

**Requires** a secret, which should be a personal access token with `repo`
scope. This is used to create a pull request in the index repository. The name
of the secret is given as an input to the action. (Note, there are no
user-level secrets, so you have to add one for each repository, unless they're
part of an organization, which do have org-level secrets.)