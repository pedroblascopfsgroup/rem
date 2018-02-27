#!/bin/bash
last_tag=$(git describe --tags | sed 's/^\(.*\)-.*-.*$/\1/')
commits_since_tag=$(git rev-list ${last_tag}^..HEAD | wc -l)
if [[ $commits_since_tag -le 1 ]]; then
	version=$last_tag
else
	version="$last_tag-SNAP_$commits_since_tag"	
fi
echo $version