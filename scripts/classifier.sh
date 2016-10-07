#!/bin/bash

# simple 3.7 NC classifier commands

declare -x PE_CERT=$(/opt/puppet/bin/puppet agent --configprint hostcert)
declare -x PE_KEY=$(/opt/puppet/bin/puppet agent --configprint hostprivkey)
declare -x PE_CA=$(/opt/puppet/bin/puppet agent --configprint localcacert)
declare -x PE_CERTNAME=$(/opt/puppet/bin/puppet agent --configprint certname)

declare -x NC_CURL_OPT="-s --cacert $PE_CA --cert $PE_CERT --key $PE_KEY --insecure"

find_guid()
{
  echo $(curl $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "$1" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')
}


read -r -d '' TRAINING_LAB_DC << DC_JSON
{
    "classes": {
      "windowstraininglab::nodes::dc": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab Primary DC",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-dc-01"
      ]
      ],
    "variables": {}
}
DC_JSON

read -r -d '' TRAINING_LAB_DC2 << DC2_JSON
{
    "classes": {
      "windowstraininglab::nodes::dc2": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab Secondary DC",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-dc-02"
      ]
      ],
    "variables": {}
}
DC2_JSON

read -r -d '' TRAINING_LAB_CLIENT << CLIENT_JSON
{
    "classes": {
      "windowstraininglab::nodes::client": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab Client",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-client"
      ]
      ],
    "variables": {}
}
CLIENT_JSON

read -r -d '' TRAINING_LAB_APPSERVER << APPSERVER_JSON
{
    "classes": {
      "windowstraininglab::nodes::appserver": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab App Server",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-appserver"
      ]
      ],
    "variables": {}
}
APPSERVER_JSON

read -r -d '' TRAINING_LAB_INSTCONTROLLER << INSTCONTROLLER_JSON
{
    "classes": {
      "windowstraininglab::nodes::instcontroller": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab Inst Controller",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-inst-controller"
      ]
      ],
    "variables": {}
}
INSTCONTROLLER_JSON

read -r -d '' TRAINING_LAB_RDGATEWAY << RDGATEWAY_JSON
{
    "classes": {
      "windowstraininglab::nodes::rdgateway": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab RD Gateway",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "or",
      [
      "~",
      [
      "fact",
      "clientcert"
      ],
      "-rd-"
      ]
      ],
    "variables": {}
}
RDGATEWAY_JSON

read -r -d '' TRAINING_LAB_NODES << NODES_JSON
{
    "classes": {
      "windowstraininglab::nodes": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Training Lab Nodes",
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
NODES_JSON


curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_DC" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_DC2" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_NODES" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_CLIENT" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_APPSERVER" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_INSTCONTROLLER" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$TRAINING_LAB_RDGATEWAY" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
