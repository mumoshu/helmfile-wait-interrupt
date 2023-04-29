#!/bin/bash

set -ex -o pipefail

HELMFILE_BIN=${HELMFILE_BIN:-~/p/helmfile/helmfile}

${HELMFILE_BIN} version
${HELMFILE_BIN} destroy || true

pids=()
${HELMFILE_BIN} apply &
pids+=($!)
bash -c "echo waiting 10s before killing helm; sleep 10; echo killing helm; pkill helm" &
pids+=($!)

sleep 1

until pgrep -f "helm upgrade"; do sleep 1; done

echo "detected helm upgrade running"
echo "interrupting helm upgrade"

kill -INT %1
#wait %1
wait "${pids[@]}"

pgrep -f "helm upgrade" | xargs ps -fp

helm ls -A --pending

# clean up

pkill -f "helm upgrade"

helm delete sleep
