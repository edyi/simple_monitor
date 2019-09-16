#!/bin/bash

## webhookのURLを読み込む（暗号化しておく）
source $(dirname $0)/.secret.sh || { echo 'cannot read .secret.sh' ; exit 1 ;}

## ドメインのリストを作成しておき、読み込む
source $(dirname $0)/domains.sh || { echo 'cannot read domains.sh' ; exit 1 ;}

## ドメインのチェックをまわす
for domain in ${domains[@]}
  do
      ## digコマンドとpingコマンドを打つ
      ip=$(dig $domain +short)
      ping=$(ping -c 1 $domain | grep ttl )

      ## 両方成功した場合は次の処理へ、失敗したら@hereを付けてslackに飛ばす
      if [ -n "$ip" -a -n "$ping" ]; then
        status=_OK
        mension=""
        continue
      else
        status=_NG
        mension="<!here>"

        ## ペイロード部分を作成する
        data="--- Status: $status$mension\n Domain: $domain\n IP: $ip\n Ping: $ping\n"
        message="{\"text\":\"${data}\"}"

        ## Slackに飛ばす
        head="Content-type: application/json"
        curl -X POST -H '${head}' --data "${message}" ${webhook}
      fi

      ## 連続投稿ができない場合は待つ
      # sleep 1
done