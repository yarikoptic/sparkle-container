#!/bin/bash

set -eu

version_date=20210510

generate() {
	# more details might come on https://github.com/ReproNim/neurodocker/issues/330
	[ "$1" == singularity ] && add_entry=' "$@"' || add_entry=''
	#neurodocker generate "$1" \
	ndversion=0.7.0
	#ndversion=master
	docker run --rm repronim/neurodocker:$ndversion generate "$1" \
		--base=neurodebian:bullseye \
		--ndfreeze date=${version_date}T000000Z \
		--pkg-manager=apt \
		--install vim wget strace time ncdu gnupg curl procps git pigz less tree \
		--run "$run_cmd" \
		--run "curl -sL https://deb.nodesource.com/setup_14.x | bash - " \
		--install nodejs \
		--run "cd /tmp/ && git clone -b env/ohbm http://github.com/sparkletown/sparkle && cd sparkle && npm install -g && cd /tmp && rm -rf sparkle" \
		--user=sparkle
}

#version=$(git describe)

generate docker > Dockerfile
