class itop::install(  
  ensure = hiera( 'itop::ensure', 'present' ),   
) {

  $source = "/downloads/iTop-${ensure}-noarch.rpm"

  package { 'iTop':
    ensure => $ensure,
    source => $source
  }

}
