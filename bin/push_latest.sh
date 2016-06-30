#!/usr/bin/env bash

set -e

export $(cat .env | xargs)
echo "Pushing image tagged as latest and $MATCHUP_VERSION"

docker tag -f larribas/matchup-api:$MATCHUP_VERSION larribas/matchup-api:latest
docker push larribas/matchup-api:$MATCHUP_VERSION
docker push larribas/matchup-api:latest
