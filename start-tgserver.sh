#!/bin/sh

# Map input values from the GitHub Actions workflow to shell variables
TGSERVER_VERSION="3.7.0"
TGSERVER_USERNAME="tigergraph"
TGSERVER_PASSWORD="tigergraph"


if [ -z "$TGSERVER_VERSION" ]; then
  echo ""
  echo "Missing TigerGraph version in the [tgserver-version] input. Received value: $TGSERVER_VERSION"
  echo ""

  exit 2
fi


echo "::group::Starting TigerGraph Server"
echo "  - version [$TGSERVER_VERSION]"
echo ""

docker run --name tigergraph -d \
    -p 14022:22 \
    -p 9000:9000 \
    -p 14240:14240 \
    --ulimit nofile=1000000:1000000 \
    -v ~/data:/home/tigergraph/mydata \
    -v tg-data:/home/tigergraph \
    -t tigergraph/tigergraph:$TGSERVER_VERSION

if [ $? -ne 0 ]; then
    echo "Error starting TGSERVER Docker container"
    exit 2
fi
echo "::endgroup::"


echo "::group:: Waiting for TGSERVER to accept connections"
sleep 1
TIMER=0


docker exec -u tigergraph --workdir /home/tigergraph/tigergraph/app/cmd tigergraph ./gadmin start all

until docker exec -u tigergraph --workdir /home/tigergraph/tigergraph/app/cmd tigergraph ./gadmin status &> /dev/null
do
  sleep 1
  echo "."
  TIMER=$((TIMER + 1))

  if [[ $TIMER -eq 20 ]]; then
    echo "TGSERVER did not initialize within 20 seconds. Exiting."
    exit 2
  fi
done
echo "::endgroup::"
