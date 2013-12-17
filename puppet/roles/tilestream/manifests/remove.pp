class tilestream::remove {
  notify { 'Removing Tilestream': }

  package { 'git':
    ensure => 'absent'
  }

  package { 'nodejs':
    ensure => 'absent'
  }

  package { 'npm':
    ensure => 'absent'
  }

  file { '/var/www':
  	ensure => 'directory',
  	purge => true
	}
}
