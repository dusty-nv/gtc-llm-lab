#!/usr/bin/env bash
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONTAINERS="$HOME/jetson-containers"

echo "script dir:         $ROOT"
echo "jetson-containers:  $CONTAINERS"

cd $CONTAINERS
CONTAINER=$(./autotag l4t-text-generation)

download()
{
	./run.sh $CONTAINER huggingface-downloader $2 $1
}

download_ooba()
{
	download $1 $2
	./run.sh $CONTAINER /bin/bash -c "if [ ! -e /data/models/text-generation-webui/$(basename $1) ] ; then ln -s \$(huggingface-downloader $1) /data/models/text-generation-webui/$(basename $1) ; fi"
}

download_gguf()
{
	download $1/$2
	./run.sh $CONTAINER /bin/bash -c "if [ ! -e /data/models/text-generation-webui/$2 ] ; then ln -s \$(huggingface-downloader $1/$2) /data/models/text-generation-webui/$2 ; fi"
}

rm_safetensors()
{
	./run.sh $CONTAINER /bin/bash -c "rm \$(huggingface-downloader $1)/*.safetensors"
}

download_gguf "TheBloke/Llama-2-7b-Chat-GGUF" "llama-2-7b-chat.Q4_K_M.gguf"
download_gguf "TheBloke/Llama-2-13b-Chat-GGUF" "llama-2-13b-chat.Q4_K_M.gguf"

download_ooba "meta-llama/Llama-2-7b-hf" "--skip-safetensors"
download_ooba "meta-llama/Llama-2-13b-hf" "--skip-safetensors"

download_ooba "meta-llama/Llama-2-7b-chat-hf"
download_ooba "meta-llama/Llama-2-13b-chat-hf"

#rm_safetensors "meta-llama/Llama-2-7b-hf"
#rm_safetensors "meta-llama/Llama-2-13b-hf"

#rm_safetensors "meta-llama/Llama-2-7b-chat-hf"
#rm_safetensors "meta-llama/Llama-2-13b-chat-hf"

download_ooba "TheBloke/Llama-2-7B-Chat-GPTQ"
download_ooba "TheBloke/Llama-2-7B-Chat-AWQ"

download_ooba "TheBloke/Llama-2-13B-chat-GPTQ"
download_ooba "TheBloke/Llama-2-13B-chat-AWQ"

download_ooba "TheBloke/llava-v1.5-13B-GPTQ"

download_ooba "liuhaotian/llava-v1.5-7b"
download_ooba "liuhaotian/llava-v1.5-13b"

download_ooba "liuhaotian/llava-v1.6-vicuna-7b"
download_ooba "liuhaotian/llava-v1.6-vicuna-13b"

download_ooba "princeton-nlp/Sheared-LLaMA-2.7B-ShareGPT"
download_ooba "stabilityai/stablelm-zephyr-3b"
download_ooba "microsoft/phi-2"

download "Efficient-Large-Model/VILA-2.7b"
download "Efficient-Large-Model/VILA-7b"
download "Efficient-Large-Model/VILA-13b"

download "NousResearch/Obsidian-3B-V0.5"
download "openai/clip-vit-large-patch14"

download "coqui/XTTS-v2"

#./run.sh $CONTAINER /bin/bash -c 'cd $(huggingface-downloader coqui/XTTS-v2); wget https://nvidia.box.com/shared/static/8i27ejn39kdjjiigatbw9r28cunubuhd.trt -O hifigan_decoder_fp16.trt'
#./run.sh $CONTAINER /bin/bash -c 'cd $(huggingface-downloader coqui/XTTS-v2); wget https://nvidia.box.com/shared/static/n3dqw0gnr5mj0lt0kqrqcuw5b1xj36cj.trt -O hifigan_decoder_fp32.trt'

