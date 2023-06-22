#!/bin/bash

# Script to automatically get cadvisor raw data.

set -x

DATE=$(date +"%F_%T")
DIR="testRunData_$DATE"

# times x minute = trial duration
MINUTE=60
TIMES=10

sudo apt-get install -y \
	jq \
	wget

mkdir "$DIR"
cd "$DIR"
declare -a framework=("cvlc") 
#"ffmpeg" "gstreamer")
declare -a codec=("h264")
#"h265" "vp8" "vp9" "mjpeg")

sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:v0.47.0

## loop through frameworks
for f in "${framework[@]}"
do
	## loop through different codecs
	for c in "${codec[@]}"
	do
		NAME="${f}_${c}"
		echo "Starting ${NAME} ..."
    docker compose run --name ${NAME} -d ${f} ${c}
		sleep ${MINUTE}

    wget -O "${NAME}"_1.json http://localhost:8080/api/v1.3/docker/"${NAME}"
		cp "${NAME}"_1.json "${NAME}".json
		for i in $(seq 2 $TIMES)
		do
			echo "Sleeping $i x $MINUTE"
			sleep ${MINUTE}
			cp "${NAME}".json "${NAME}"_copy.json
			wget -O "${NAME}"_"${i}".json http://localhost:8080/api/v1.3/docker/"${NAME}"
			jq '.[].stats += [inputs]' "${NAME}"_copy.json <(jq -c "values[] | .stats[]" "${NAME}"_"${i}".json) > "${NAME}".json
		done
		rm "${NAME}"_copy.json
		mkdir "${NAME}"_singleMinutes
		mv "${NAME}"_*.json "${NAME}"_singleMinutes/
		docker rm -f ${NAME}
		echo "Finished with ${NAME}"
	done
done

docker rm -f cadvisor
echo "Finished testrun."
