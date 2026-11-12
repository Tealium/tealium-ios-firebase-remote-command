#!/bin/bash

# A script to verify that the repo is up to date and the version constant matches the latest tag before releasing

constants=$(<Sources/FirebaseConstants.swift)
regex="^.*static let version \= \"([0-9\.]*)\""

if [[ $constants =~ $regex ]]
then
    versionConstant=${BASH_REMATCH[1]}
else
    echo "Couldn't match the library version, exiting"
    exit 1
fi
echo Version Constant "$versionConstant"

branch_name="$(git rev-parse --abbrev-ref HEAD)"
echo Current branch "$branch_name"
if [ "$branch_name" != "main" ]
then 
  echo "Check out to main branch before trying to publish. Current branch: ${branch_name}"
  exit 1
fi

git fetch --tags
if ! git diff --quiet remotes/origin/main
then
  echo "Make sure you are up to date with the remote before publishing"
  exit 1
fi

latestTag=$(git describe --tags --abbrev=0)

echo Latest tag "$latestTag"
if [ "$latestTag" != "$versionConstant" ]
then
  printf "The latest published tag \"%s\" is different from the version constant \"%s\".\nDid you forget to add the tag to the release or did you forget to update the Constant?" "$latestTag" "$versionConstant"
  exit 1
fi

echo "All checks are passed, ready to release version $versionConstant"
