#!/bin/bash

set -ex -o pipefail

~/src/helmfile/helmfile version
~/src/helmfile/helmfile apply &

sleep 10

until pgrep -f "helm upgrade"; do sleep 10; done

kill -INT %1
wait %1

pgrep -f "helm upgrade" | xargs ps -fp

helm ls -A --pending

# clean up

pkill -f "helm upgrade"

helm delete sleep
