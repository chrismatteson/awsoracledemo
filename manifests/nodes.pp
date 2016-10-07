class awsoracledemo::nodes (
  $nodes = hiera_hash(awsoracledemo::nodes_hash, $awsoracledemo::params::nodes),
) inherits awsoracledemo::params {

  $public_key = split($ec2_metadata['public-keys']['0']['openssh-key'], ' ')
  $awskey = $public_key[2]

  $nodekeys = keys($nodes)

  $nodekeys.each |$node| {
    awsoracledemo::ec2instance { $node:
      image_id           => $nodes["$node"]['image_id'],
      pp_created_by      => 'chris.matteson', #$ec2_tags['created_by'],
      key_name           => $awskey,
      pe_master_hostname => $::ec2_local_hostname,
      role               => $nodes["$node"]['role'],
    }
  }

  @@host { $fqdn:
    ensure       => 'present',
    host_aliases => $hostname,
    ip           => $ipaddress,
  }

  Host <<| |>>

}
