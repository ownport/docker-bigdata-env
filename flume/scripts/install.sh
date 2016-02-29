#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

FLUME_URL="http://www.apache.org/dist/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz"

base() {

    mkdir -p \
        /data/bin \
        /data/conf \
        /data/channels \
        /data/logs \
        /data/lib \
        /data/meta \
        /data/sinks \
        /data/tmp && \
    apk add --update python

    echo "hosts: files dns" >> /etc/nsswitch.conf
}


flume() {

    [ -z ${FLUME_VERSION} ] && {
        echo '[ERROR] Environment variable FLUME_VERSION does not defined'
        exit 1
    }


	echo "[INFO] Getting ${FLUME_URL}" && \
	wget -qO- ${FLUME_URL} | tar zxf - -C /opt && \
  	rm -rf /opt/apache-flume-${FLUME_VERSION}-bin/docs && \
  	ln -s /opt/apache-flume-${FLUME_VERSION}-bin /opt/flume && \
	echo "[INFO] Installation of Flume agent [${FLUME_VERSION}] is completed"
}


clean() {

    rm -rf /var/cache/apk/* /tmp/* /install/* && \
    echo '[INFO] Clearing is completed'    
}

set_env() {

    echo "export PATH=/opt/flume/bin:\$PATH" >> /etc/profile.d/flume.sh  
    chmod +x /etc/profile.d/flume.sh
}

$@
