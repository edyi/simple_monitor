#!/bin/bash

## webhookのURLを読み込む（暗号化しておく）
source $(dirname $0)/.secret.sh || { echo 'cannot read .secret.sh' ; exit 1 ;}
## ドメインのリストを作成しておき、読み込む
source $(dirname $0)/domains.sh || { echo 'cannot read domains.sh' ; exit 1 ;}
## functionsを読み込む
source $(dirname $0)/functions.sh || { echo 'cannot read functions.sh' ; exit 1 ;}


## ドメインのチェックをforでまわす
for domain in ${domains[@]}
  do
      ## 監視結果のファイルを置く場所
      file_ok="$(dirname $0)/result/$domain.ok"
      file_ng="$(dirname $0)/result/$domain.ng"

      ## 簡易監視。digコマンドとpingコマンドを打って結果を代入する
      ip=$(dig $domain +short)
      ping=$(ping -c 1 $domain | grep ttl )

      ## 両方成功した場合は次の処理へ、失敗したら@hereを付けてslackに飛ばす
      if [ -n "$ip" -a -n "$ping" ]; then
          ## OKだった記録を残す
          touch $file_ok

          ## ドメインのNG結果ファイルを確認し、存在していたら復活ということなのでslackに通知する
          if [ -e "$file_ng" ]; then
              ## Slackに飛ばす
              slack_recovery

              ## 復活したのでNGファイルを削除する
              rm -f $file_ng
          else
              ## 監視に成功し、NGファイルがなければ問題ないのでそのままcontinueする
              continue 3
          fi        
      else
          ## 監視に失敗し、NGファイルもOKファイルもなかったら最初のNGということなので通知する（これは初回実行時にNGだったときの処理）
          if [ ! -e "$file_ng" -a ! -e "$file_ok" ]; then
              ## Slackに飛ばす
              slack_ng
              ## NGだった記録を残す
              touch $file_ng
              continue 3
          fi

          ## NGファイルまたはOKファイルが既にある場合、ここではNGだった記録を残す
          touch $file_ng

          ## OKファイルがあったらNGに状態変化したという事なのでslackに通知する
          if [ -e "$file_ok" ]; then
              ## Slackに飛ばす
              slack_ng

              ## NGになったのでOKファイルを削除する
              rm -f $file_ok

            elif [ -e "$file_ng" ]; then
            ## NGファイルがあるということは以前からNGなので復活するまでslackには送らない
            continue 3
          fi
      fi

        ## 連続投稿ができない場合は待つ
        # sleep 1
done