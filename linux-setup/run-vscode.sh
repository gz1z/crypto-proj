#!/bin/bash

cd ~

# Run vscode code server
nohup code-server --port 9000 --auth none &

# Create tunnel with ngrok
./ngrok config add-authtoken $NGROK_TOKEN
./ngrok http 9000
