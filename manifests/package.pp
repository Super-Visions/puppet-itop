class itop::package(  
  ensure = present,   
) {

  $source = "/downloads/iTop-${ensure}-noarch.rpm"

  package { 'iTop':
    ensure   => $ensure,
    source   => $source
    provider => 'rpm',
  }

}
