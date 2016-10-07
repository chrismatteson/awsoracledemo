class awsoracledemo (
  $nodes = hiera_hash('awsoracledemo::nodes_hash')
  ){

  contain awsoracledemo::nodes

}
