This module stands up oracle servers in AWS.
In order to use this module, do the following steps:

1) Create an IAM role in AWS with the ability to provision nodes
2) Create a VPC in AWS for this to live inside
3) Create a security group in AWS to allow internode communication
4) Create a m4.xlarge redhat 7 VM with sufficent disk space and
install Puppet Enterprise
5) Git clone this project to the modules directory
 - https://github.com/chrismatteson/awsoracledemo
6) Run the script at awsoracledemo/scripts/deploy.sh
7) Add nodes to the common.yaml of hiera in this format:

awsoracledemo::nodes_hash:
 server1:
 - image_id: ami-12345678
 - role: oracle
 - password: P@ssw0rd!
 server2:
 - image_id: ami-12345678
 - role: other
 - password: P@ssw0rd!

