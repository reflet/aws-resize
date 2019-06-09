# 画像リサイズ (Lambda@Edge)

## 環境変数の定義
dockerコンテナが使用する定数を設定する。

```
$ export AWS_ACCESS_KEY_ID='xxxxxxxxxxxxx'
$ export AWS_SECRET_ACCESS_KEY='xxxxxxxxxxxxxxxxxx'
$ export STACK_NAME='resize-lambda-edge'
$ export CODE_BUCKET='test-ms-s3-lambda'
$ export CODE_VERSION='v1'
$ export IMAGE_BUCKET='test-ms-s3'
```

## デプロイ
CloudFormationでStackを登録してAWSの各リソースを自動生成する。

```
$ export CODE_VERSION='v1' && \
  docker-compose build && \
  docker-compose run --rm lambda /root/request.sh --package && \
  docker-compose run --rm lambda /root/response.sh --package && \
  docker-compose run --rm aws-cli /root/code.sh --create && \
  docker-compose run --rm aws-cli /root/bucket.sh --create && \
  docker-compose run --rm aws-cli /root/cdn.sh --deploy
```

## lamda関数の更新

JavaScriptを変更して、CloudFormationでStackを更新し、lambdaのリソースを再構築する。

```
# ↓ 最新バージョン＋１を指定する
$ export CODE_VERSION='v10' && \
  docker-compose build && \
  docker-compose run --rm lambda /root/request.sh --package && \
  docker-compose run --rm lambda /root/response.sh --package && \
  docker-compose run --rm aws-cli /root/code.sh --upload && \
  docker-compose run --rm aws-cli /root/cdn.sh --deploy
```

## CloudFormationのエラー対応について

Stack一覧を確認する。
```
$ docker-compose run --rm aws-cli aws cloudfront list-distributions
```

エラーを確認してみる。
```
$ docker-compose run --rm aws cloudformation describe-stack-events --stack-name ${STACK_NAME} | grep 'FAILED'
```

deploy時に、前のStackが残っている場合、Stackを削除する。
```
$ docker-compose run --rm aws cloudformation delete-stack --stack-name ${STACK_NAME}
```

以上

## 参考サイト

* [Amazon CloudFront & Lambda@Edge で画像をリサイズする](https://aws.amazon.com/jp/blogs/news/resizing-images-with-amazon-cloudfront-lambdaedge-aws-cdn-blog/)
* [Lambda@Edgeを使って画像をリサイズしてみた](https://dev.classmethod.jp/cloud/aws/lambda-edge-image-resize/)
* [lambda@edgeでの画像リサイズ。ハマりどころとテストまとめ](https://kuronyankotan.com/?p=1547)
* [Lambda@Edgeによる画像リサイズを本番運用した感想](https://qiita.com/hareku/items/3c49e5f60a7cf0989cd0)
* [Cloudfront,S3で307リダイレクトに苦しめられた](http://masaru-tech.hateblo.jp/entry/2018/03/27/111327)
* [Amazon CloudFrontのキャッシュ削除(Invalidation)](https://dev.classmethod.jp/server-side/aws-amazon-cloudfront-deleting-cache-by-invalidation/)
* [Lambda@Edgeで画像をリアルタイムにリサイズ＆WebP形式へ変換する](https://techlife.cookpad.com/entry/2018-05-25-lambda-edge)
* [Lambda@Edgeを利用して画像リサイズ機能を実装した](https://engineers.weddingpark.co.jp/?p=2446)
