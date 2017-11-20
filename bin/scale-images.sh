#!/usr/bin/env bash

DIR="${1}"

if [ ! -d "${DIR}" ]; then
    echo "Please provide a directory"
    exit
fi

BASEDIR="$(dirname "${DIR}")"
OUTPUT_DIR="${BASEDIR}/$(basename "${DIR}")-scaled"

mkdir -p "${OUTPUT_DIR}"

for file in $(ls "${DIR}"); do
    if [ -f "${DIR}/${file}" ]; then
        width="$(mediainfo --Output="Image;%Width%" "${DIR}/${file}")"

        if [ "${width}" != "" ] && [ $width -lt 3840 ]; then
            waifu2x-converter-cpp -j 8 -i "${DIR}/${file}" -o "${OUTPUT_DIR}/${file}"
        fi
    fi
done

