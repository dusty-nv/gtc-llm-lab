#!/usr/bin/env bash
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RIVA=${1:-"$HOME/riva"}
RMIR="$RIVA/model_repository/rmir"

echo "script dir: $ROOT"
echo "riva dir:   $RIVA"
echo "rmir dir:   $RMIR"

download_file()
{
	wget --show-progress --progress=bar:force:noscroll --no-check-certificate $1 -O $2
}

download_riva()
{
	cd $RIVA
	
	#download_file "https://nvidia.box.com/shared/static/wlvrj3hn54qdbnve5o9xqzxw7hy6aypl.zip" "riva_embedded_quickstart_v2.14_rmir.zip"
	#unzip "riva_embedded_quickstart_v2.14_rmir.zip"
	
	download_file "https://nvidia.box.com/shared/static/ae7roctj7alud8bxmz3zbovuylmy3xnm.zip" "riva_embedded_quickstart_jp6-ea_asr.zip"
	unzip "riva_embedded_quickstart_jp6-ea_asr.zip"
	
	mkdir -p $RMIR
	cd $RMIR

	#download_file "https://nvidia.box.com/shared/static/eyw0v0du1xaivgjvyluxkhcjazongznz.rmir" "riva-nmt-megatronnmt_any_en_500m.rmir"
	download_file "https://nvidia.box.com/shared/static/9rfi80ridavw1edfnhqocxk05y7llvm2.rmir" "asr-conformer-en-US-offline-flashlight-.rmir"
	download_file "https://nvidia.box.com/shared/static/5qz24s3wvmr4uajxpjt8y4su2yzbbrsn.rmir" "asr-conformer-en-US-streaming-throughput-flashlight-.rmir"
	download_file "https://nvidia.box.com/shared/static/vw6b30rym3xarm45tx08vyg7xw780ked.rmir" "asr-punctuation-en-US.rmir"
	#download_file "https://nvidia.box.com/shared/static/qv115xr3bo4mxtu275ep2932rcu6fxmx.rmir" "tts-FastPitch_44k_EnglishUS_IPA.rmir"
}

download_riva

#
# TESTING RIVA
#
# bash riva_init.sh
# bash riva_start.sh
#
# nvidia-riva-client 2.14.0
#
# python3 examples/transcribe_file.py --input-file wav/en-US_wordboosting_sample.wav --simulate-realtime --show-intermediate
## anti beata and ab lupo both transformer based language models are examples of the emerging work in using graph neural networks to design protein sequences for particular target antigens
#
# python3 examples/riva_streaming_asr_client.py --input-file wav/en-US_wordboosting_sample.wav --simulate-realtime --automatic-punctuation
#
# python3 examples/transcribe_mic.py --list-devices
# python3 examples/transcribe_mic.py --automatic-punctuation --input-device 25
#
# python3 examples/talk.py --stream --output /data/tts.wav --text 'Hello, how are you today?' --sample-rate-hz 44100
# python3 examples/talk.py --stream --output /data/tts.wav --text 'Hello, how are you today?' --play-audio --output-device 25 --sample-rate-hz 44100
#
# if failed with "Error: Triton model failed during inference. Error message: Streaming timed out", try running it again
#