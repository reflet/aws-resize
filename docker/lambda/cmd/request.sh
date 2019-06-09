#!/bin/bash

source /root/.bashrc

if [ -z "$CODE_VERSION" ]; then
    echo -e "環境変数「CODE_VERSION」が定義されていません\n"
    exit 1
fi

compile() {
    mkdir -p /tmp/viewer-request-function/
    cd /tmp/viewer-request-function/
    cp /src/viewer-request-function/index.js .
    npm init -f -y;
    npm install querystring --save;
    npm install --only=prod
}
package() {
    cd /tmp/viewer-request-function/
    mkdir -p /dist
    file="/dist/viewer-request-function.${CODE_VERSION}.zip"
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

echo -e "Usage: request.sh --package\n"
exit 1
