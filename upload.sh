#!/bin/bash

# set -o allexport
source .env
# set +o allexport

# Vérifier l'extension du fichier blob
if [[ "$BLOB_NAME" == *.parquet ]]; then
    echo "Uploading parquet file to azure data lake"
elif [[ "$BLOB_NAME" == *.csv ]]; then
    echo "Uploading csv to azure data lake"
else
    echo "Uploading file to azure data lake"
fi

python3 upload_file_to_dl.py