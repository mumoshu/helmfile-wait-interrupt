#!/bin/bash

set -ex -o pipefail

helmfile apply &

until pgrep -f "helm upgrade"; do sleep 10; done

kill -TERM %1

pgrep -f "helm upgrade" | xargs ps -fp

helm ls -A --pending

# clean up

pkill -f "helm upgrade"

helm delete sleep
