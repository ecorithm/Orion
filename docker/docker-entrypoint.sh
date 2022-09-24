#!/bin/bash

export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

jupyter notebook \
     --ip=0.0.0.0 \
     --NotebookApp.password='sha1:ba5b4aeee944:45476c47d625d98aa5ae6a09ff6b2cdea1b2a646' \
     --port=8888 \
     --no-browser
