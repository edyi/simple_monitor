#!/bin/bash

function slack_recovery() {
    status="_OK(recovery)"
    mention="<!here>"
    data="--- Status: $status $mention\n Domain: $domain\n IP: $ip\n Ping: $ping\n"
    message="{\"text\":\"${data}\"}"
    head="Content-type: application/json"
    curl -X POST -H '${head}' --data "${message}" ${webhook}
}

function slack_ng() {
    status=_NG
    mention="<!here>"
    data="--- Status: $status $mention\n Domain: $domain\n IP: $ip\n Ping: $ping\n"
    message="{\"text\":\"${data}\"}"
    head="Content-type: application/json"
    curl -X POST -H '${head}' --data "${message}" ${webhook}
}
