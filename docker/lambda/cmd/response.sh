#!/bin/bash

source /root/.bashrc

if [ -z "${IMAGE_BUCKET}" ]; then
    echo "環境変数「IMAGE_BUCKET」が定義されていません\n"
    exit 1
fi
if [ -z "$CODE_VERSION" ]; then
    echo -e "環境変数「CODE_VERSION」が定義されていません\n"
    exit 1
fi

compile() {
    mkdir -p /tmp/origin-response-function/
    cd /tmp/origin-response-function/
    cp /src/origin-response-function/index.js .
    sed -i "s/<image-bucket>/${IMAGE_BUCKET}/g" index.js
    npm init -f -y;
    npm install sharp --save;
    npm install querystring --save;
    npm install --only=prod
}
package() {
    cd /tmp/origin-response-function/
    mkdir -p /dist
    file="/dist/origin-response-function.${CODE_VERSION}.zip"
    zip -FS -q -r "${file}" *
    echo "export: ${file}"
}

while getopts ":-:" opt; do
    case "$opt" in
        -)
            case "${OPTARG}" in
                package)
                    compile
                    package
                    exit 0 ;;
                *) ;;
            esac ;;
    esac
done

echo -e "Usage: response.sh --package\n"
exit 1
