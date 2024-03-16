#!/usr/bin/env bash
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTAINERS="$HOME/jetson-containers"

echo "script dir:         $ROOT"
echo "jetson-containers:  $CONTAINERS"

echo ""
#echo "No updates needed"

echo "updating jetson-containers @ $CONTAINERS"
cd $CONTAINERS
git pull

echo "updating XTTS HiFiGAN TensorRT engine"
./run.sh $(./autotag l4t-text-generation) /bin/bash -c 'cd $(huggingface-downloader coqui/XTTS-v2); wget https://nvidia.box.com/shared/static/8i27ejn39kdjjiigatbw9r28cunubuhd.trt -O hifigan_decoder_fp16.trt'
