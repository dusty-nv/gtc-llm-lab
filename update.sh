#!/usr/bin/env bash
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTAINERS="$HOME/jetson-containers"

echo "script dir:         $ROOT"
echo "jetson-containers:  $CONTAINERS"

echo "updating gtc-llm-lab @ $ROOT"
cd $ROOT
git pull

bash ./scripts/update.sh
