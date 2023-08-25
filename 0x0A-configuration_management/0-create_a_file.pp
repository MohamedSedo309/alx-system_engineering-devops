#Using Puppet, create a file in /tmp with some structures

file { 'tmp/school':
  ensure => file,
  mode => '0744',
  owner => 'www-data',
  group => 'www-data',
  path => 'tmp/school',
  content => 'I love Puppet'
}