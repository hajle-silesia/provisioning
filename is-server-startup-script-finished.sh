#!/bin/bash

while [ ! -f /home/mtweeman/startup-script-finished ]; do
  echo -e "Waiting for startup script finish..."
  sleep 5
done
