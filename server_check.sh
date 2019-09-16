#!/bin/bash
#これはサーバの状態を定期的に送るもののサンプル。
source $(dirname $0)/.secret.sh || { echo 'cannot read .secret.sh' ; exit 1 ;}
source $(dirname $0)/functions.sh || { echo 'cannot read functions.sh' ; exit 1 ;}

hostname=$(hostname)
uptime=$(uptime)
ps=$(ps -ef | grep cron | grep -v grep)

slack_check "$hostname" "$uptime" "$ps"