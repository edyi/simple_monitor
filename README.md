## .secret.shにslackのwebhookのURLを書く
- webhookのURLは公開できないので.gitignore書く

.secret.sh
```
webhook="https://hooks.slack.com/services/xxxxxxxxxx/xxxxxxxxxx/xxxxxxxxxx"
```

## ドメインを書く
domains.sh
```
domains=(
    www.examples.com
    www.hogehoge.com
)
```

## 実行する
sh execute_me.sh


