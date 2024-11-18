#!/bin/bash

git clone -n --depth=1 --filter=tree:0 https://github.com/mea2k/devops
cd devops
git sparse-checkout set --no-cone 3-docker-practice
git checkout
cd 3-docker-practice
