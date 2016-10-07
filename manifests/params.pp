class awsoracledemo::params (
  $nodes = {
    'server-oracle-1' => {
       'name'     => 'server-oracle-1',
       'image_id' => 'ami-d440a6e7',
       'role'     => 'oracledb',
       'password' => 'P@ssw0rd!',
    },
    'server-other-1' => {
       'name'     => 'server-other-1',
       'image_id' => 'ami-d440a6e7',
       'role'     => 'other',
       'password' => 'P@ssw0rd!',
    }
  }
) {

  case $::ec2_region {
    # North America
    'us-west-2': {
      $security_groups = ['tse-us-west-2-agents','tse-us-west-2-crossconnect']
      $windows2012 = 'ami-4dbcb67d'
      $windows7 = 'ami-4dbcb67d'
      $centos7 = 'ami-d440a6e7'
    }
    # Singapore
    'ap-southeast-1': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $windows2012 = 'ami-ae7c41fc'
      $windows7 = 'ami-ae7c41fc'
    }
    # Sydney
    'ap-southeast-2': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $windows2012 = 'ami-dd1b6be7'
      $windows7 = 'ami-dd1b6be7'
    }
    # Europe
    # UK + Ireland
    'eu-west-1': {
      $security_groups = ['tse-agents','tse-crossconnect']
      $windows2012 = 'ami-5d62ff2a'
      $windows7 = 'ami-5d62ff2a'
    }
    default: {
      fail("This module is only meant for aws, ec2_regions: us-west-2, ap-southeast-2, eu-west-1")
    }
  }

$subnet = 'tse-us-west-2-avza'
#  case $::ec2_placement_availability_zone {
##    'us-west-2a', 'ap-southeast-2a', 'eu-west-1a': {
#      $subnet = 'tse-subnet-avza-1'
#    }
#    'us-west-2b', 'ap-southeast-2b', 'eu-west-1b': {
#      $subnet = 'tse-subnet-avzb-1'
#    }
#    default: {
#      fail("This module is only meant for aws, ec2_regions: us-west-2, ap-southeast-2, eu-west-1")
#    }
#  }
}
