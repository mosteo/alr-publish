#!/usr/bin/env bash

set -o errexit
set -o nounset

# Credentials
alr settings --global --set user.github_login $GITHUB_ACTOR
git config --global user.name "$GITHUB_ACTOR"
git config --global user.email "$USER_EMAIL"

echo "Publishing with arguments: force=$force skip_build=$skip_build skip_submit=$skip_submit"
alr $force publish $skip_build $skip_submit | tee publish.log

# End already if we are skipping the submit
[[ "$skip_submit" != "" ]] && exit 0

# Identify PR number from output
# In python it would be: pr = re.search(r'/pull/(\d+) for details', p.out).group(1)

PR=$(grep -oP '/pull/\K\d+(?= for details)' publish.log) || {
    echo "::error::PR number not found in output!"
    echo "Publish log contents:"
    cat publish.log
    exit 1
}

if [[ -z "$PR" ]]; then
    echo "::error::PR variable is empty"
    exit 1
fi

echo "PR created with number: $PR"

# Check periodically until the PR checks succeed or fail

waited=0
backoff=30
timeout=${TIMEOUT:-600}

while true; do
    sleep $backoff
    waited=$((waited+backoff))
    line=$(alr publish --status | grep /$PR)
    if [[ $line == *Checks_Passed* ]]; then
        break
    elif [[ $line == *Checks_Failed* ]]; then
        echo "Checks failed unexpectedly for PR $PR: $line"
        echo Please review manually
        exit 1
    elif [[ $waited -gt $timeout ]]; then
        echo "Checks not completed after $timeout seconds for PR $PR"
        echo Please review manually
        exit 1
    else
        # Wait a bit and retry, but fail after so many time
        sleep 1
        waited=$((waited+1))
    fi
done

# At this point the PR checks have passed and we can request a review

alr publish --request-review=$PR