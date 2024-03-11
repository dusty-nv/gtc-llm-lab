#!/usr/bin/env bash
set -e

ROOT="$( dirname $( dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ) ) )"
CONTAINERS="$HOME/jetson-containers"

echo "script dir:         $ROOT"
echo "jetson-containers:  $CONTAINERS"

cd $CONTAINERS
CONTAINER=$(./autotag local_llm)


quantize_llm()
{
	./run.sh $CONTAINER /bin/bash -c "python3 -m local_llm.chat --api=mlc --debug --model $1 --prompt /data/prompts/qa.json"
}

quantize_vlm()
{
	./run.sh $CONTAINER /bin/bash -c "python3 -m local_llm.chat --api=mlc --debug --model $1 --prompt /data/prompts/images.json --max-context-len 768 --max-new-tokens 64"
}


#quantize_llm "meta-llama/Llama-2-7b-chat-hf"
#quantize_llm "meta-llama/Llama-2-13b-chat-hf"
quantize_llm "meta-llama/Llama-2-70b-chat-hf"

#quantize_llm "princeton-nlp/Sheared-LLaMA-2.7B-ShareGPT"
#quantize_llm "stabilityai/stablelm-zephyr-3b"

#quantize_vlm "liuhaotian/llava-v1.6-vicuna-7b"
#quantize_vlm "liuhaotian/llava-v1.6-vicuna-13b"

#quantize_vlm "Efficient-Large-Model/VILA-2.7b"
#quantize_vlm "Efficient-Large-Model/VILA-7b"
#quantize_vlm "Efficient-Large-Model/VILA-13b"

#quantize_vlm "NousResearch/Obsidian-3B-V0.5"
