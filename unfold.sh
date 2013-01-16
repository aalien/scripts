#!/bin/bash

while read line; do
    if [ -z "$line" ]; then
        echo ""; echo ""
    else
        echo -n "$line "
    fi
done

