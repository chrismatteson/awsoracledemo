#!/bin/bash

# simple 3.7 NC classifier commands

declare -x PE_CERT=$(/opt/puppetlabs/bin/puppet agent --configprint hostcert)
declare -x PE_KEY=$(/opt/puppetlabs/bin/puppet agent --configprint hostprivkey)
declare -x PE_CA=$(/opt/puppetlabs/bin/puppet agent --configprint localcacert)
declare -x PE_CERTNAME=$(/opt/puppetlabs/bin/puppet agent --configprint certname)

declare -x NC_CURL_OPT="-s --cacert $PE_CA --cert $PE_CERT --key $PE_KEY --insecure"

find_guid()
{
  echo $(curl $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "$1" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')
}


read -r -d '' ORACLEDB << ORACLEDB_JSON
{
    "classes": {
      "awsoracledemo::nodes::oracledb": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Oracle Database",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "oracle"
      ]
      ],
    "variables": {}
}
ORACLEDB_JSON

read -r -d '' AWSENV << AWSENV_JSON
{
    "classes": {
      "awsoracledemo::nodes": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Estantiate AWS Env",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
           "or",
        [
            "=",
            "name",
            "$PE_CERTNAME"
        ]
     ],
    "variables": {}
}
AWSENV_JSON


curl -X POST -H 'Content-Type: application/json' -d "$ORACLEDB" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$AWSENV" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
