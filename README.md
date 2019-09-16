## .secret.shにslackのwebhookのURLを書く
- webhookのURLは公開できないので.gitignoreに書いておく
<b>.secret.sh</b>
```
webhook="https://hooks.slack.com/services/xxxxxxxxxx/xxxxxxxxxx/xxxxxxxxxx"
```

## domains.shドメインを書く
```
domains=(
    www.examples.com
    www.hogehoge.com
)
```

## 実行する
sh execute_me.sh


