class awsoracledemo::nodes (
  $nodes = hiera_hash(awsoracledemo::nodes_hash, $awsoracledemo::params::nodes),
) inherits awsoracledemo::params {

  $public_key = split($ec2_public_keys_0_openssh_key, ' ')
  $awskey = $public_key[2]

  $nodes.each | $node | {
    awsoracledemo::ec2instance { $node:
      nodename           => $node,
      image_id           => $awsoracledemo::params::centos7,
      pp_created_by      => $ec2_tags['created_by'],
      key_name           => $awskey,
      pe_master_hostname => $::ec2_local_hostname,
      role               => $role,
    }
  }

  @@host { $fqdn:
    ensure       => 'present',
    host_aliases => $hostname,
    ip           => $ipaddress,
  }

  Host <<| |>>

}
