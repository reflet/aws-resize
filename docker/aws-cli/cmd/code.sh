#!/bin/bash

source /root/.bashrc

if [ -z "${CODE_BUCKET}" ]; then
    echo -e "環境変数「CODE_BUCKET」が定義されていません\n"
    exit 1
fi
if [ -z "$CODE_VERSION" ]; then
    echo -e "環境変数「CODE_VERSION」が定義されていません\n"
    exit 1
fi

create() {
    aws --region us-east-1 s3 mb s3://${CODE_BUCKET}
}
upload() {
    aws s3 cp /dist/origin-response-function.${CODE_VERSION}.zip s3://${CODE_BUCKET}/
    aws s3 cp /dist/viewer-request-function.${CODE_VERSION}.zip s3://${CODE_BUCKET}/
}
clear() {
    rm -f /dist/origin-response-function.${CODE_VERSION}.zip
    rm -f /dist/viewer-request-function.${CODE_VERSION}.zip
}

# 引数(オプション)
while getopts ":-:" opt; do
    case "$opt" in
        -)
            case "${OPTARG}" in
                create)
                    create
                    upload
                    clear
                    exit 0 ;;
                upload)
                    upload
                    clear
                    exit 0 ;;
                *) ;;
            esac ;;
    esac
done

echo -e "Usage: code.sh [--create] [--upload]\n"
exit 1
