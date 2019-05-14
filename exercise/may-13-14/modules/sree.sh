#!/bin/bash

msg="Test simple module with a demo message from hostname=$(hostname)"
echo "{\"changed\": true, \"msg\": \"$msg\"}"
exit 0
