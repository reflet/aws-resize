#!/bin/bash

source /root/.bashrc

if [ -z "${STACK_NAME}" ]; then
    echo "環境変数「STACK_NAME」が定義されていません\n"
    exit 1
fi
if [ -z "${IMAGE_BUCKET}" ]; then
    echo "環境変数「IMAGE_BUCKET」が定義されていません\n"
    exit 1
fi

create() {
    cd /root/
    FILE="/root/template.bucket.yml"
    if [ -e "${FILE}" ]; then
      rm -f ${FILE}
    fi
    cp /src/template.bucket.yml ${FILE}
    sed -i "s/<image-bucket>/${IMAGE_BUCKET}/g" ${FILE}

    aws cloudformation deploy \
        --template-file ${FILE} \
        --stack-name "${STACK_NAME}-bucket" \
        --capabilities CAPABILITY_IAM
}

while getopts ":-:" opt; do
    case "$opt" in
        -)
            case "${OPTARG}" in
                create)
                    create
                    exit 0 ;;
                *) ;;
            esac ;;
    esac
done

echo "Usage: bucket.sh --create"
exit 1

