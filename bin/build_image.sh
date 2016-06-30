#!/usr/bin/env bash

set -e

export $(cat .env | xargs)
echo "Building version $MATCHUP_VERSION"
docker build -t larribas/matchup-api:$MATCHUP_VERSION .
