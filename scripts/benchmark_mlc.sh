#!/usr/bin/env bash
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTAINERS="$HOME/jetson-containers"

echo "script dir:         $ROOT"
echo "jetson-containers:  $CONTAINERS"

cd $CONTAINERS
CONTAINER=$(./autotag mlc)

MLC_MODEL_DIR="/data/models/mlc"
HF_MODEL_DIR="$MLC_MODEL_DIR/models"

QUANTIZATION=${QUANTIZATION:-"q4f16_ft"}
SKIP_QUANTIZATION=${SKIP_QUANTIZATION:-"no"}
USE_SAFETENSORS=${USE_SAFETENSORS:-"no"}

MAX_SEQ_LEN="4096"
MAX_NEW_TOKENS="128"
MAX_NUM_PROMPTS="4"

download()
{
	local DOWNLOADER_FLAGS=""
	
	if [[ $USE_SAFETENSORS = "no" ]]; then
		DOWNLOADER_FLAGS="--skip-safetensors"
	fi
	
	./run.sh --env HUGGINGFACE_TOKEN="$HUGGINGFACE_TOKEN" $CONTAINER huggingface-downloader $DOWNLOADER_FLAGS "$1/$2"
	./run.sh --env HUGGINGFACE_TOKEN="$HUGGINGFACE_TOKEN" $CONTAINER /bin/bash -c "if [ ! -d $HF_MODEL_DIR/$2 ] ; then ln -s \$(huggingface-downloader $DOWNLOADER_FLAGS $1/$2) $HF_MODEL_DIR/$2 ; fi"
}

link()
{
	./run.sh $CONTAINER /bin/bash -c "if [ ! -d $HF_MODEL_DIR/$1 ] ; then ln -s $2 $HF_MODEL_DIR/$1 ; fi"
}

quantize()
{
	local QUANT_FLAGS=""
	
	if [[ $USE_SAFETENSORS = "yes" ]]; then
		QUANT_FLAGS="--use-safetensors"
	fi
	
	if [[ $SKIP_QUANTIZATION = "no" ]]; then
		./run.sh --workdir $MLC_MODEL_DIR $CONTAINER \
			/bin/bash -c "python3 -m mlc_llm.build --model $1 --target cuda --use-cuda-graph --use-flash-attn-mqa --quantization $QUANTIZATION $QUANT_FLAGS --artifact-path $MLC_MODEL_DIR --max-seq-len $MAX_SEQ_LEN"
	fi
}

benchmark()
{
	./run.sh --workdir $MLC_MODEL_DIR $CONTAINER \
		/bin/bash -c "python3 /opt/mlc-llm/benchmark.py --model $MLC_MODEL_DIR/$1/params --max-new-tokens $MAX_NEW_TOKENS --max-num-prompts $MAX_NUM_PROMPTS --prompt $2 --save /data/benchmarks/mlc.csv"
}

benchmark_shmoo()
{
	benchmark $1 "/data/prompts/completion_16.json"
	#benchmark $1 "/data/prompts/completion_32.json"
	#benchmark $1 "/data/prompts/completion_64.json"
	#benchmark $1 "/data/prompts/completion_128.json"
	#benchmark $1 "/data/prompts/completion_256.json"
	#benchmark $1 "/data/prompts/completion_512.json"
	#benchmark $1 "/data/prompts/completion_1024.json"
	#benchmark $1 "/data/prompts/completion_2048.json"
	#benchmark $1 "/data/prompts/completion_3072.json"
	##benchmark $1 "/data/prompts/completion_3840.json"
	#benchmark $1 "/data/prompts/completion_3968.json"
}
	
run_benchmark()
{
	download $1 $2
	quantize $2
	benchmark_shmoo "$2-$QUANTIZATION"
}

run_benchmark "meta-llama" "Llama-2-7b-chat-hf"
run_benchmark "meta-llama" "Llama-2-13b-chat-hf"

