class tilestream::install {
  notify { 'Installing Tilestream': }

  package { 'git':
    ensure => 'present'
  }

  class { 'nodejs':
	  version => 'v0.8.26',
	}

	include nginx

	file { 'tilestream.conf':
		path => '/etc/nginx/conf.d/tilestream.conf',
		content => template('tilestream/tilestream.conf.erb'),
		replace => true,
	}

	file { '/var/www':
		ensure => 'directory',
	}->
	file { 'tilestream-home':
		path => '/var/www/tilestream',
		ensure => 'directory',
	}->
	file { 'tilestream-home-tiles':
		path => '/var/www/tilestream/tiles',
		ensure => 'directory',
	}->
	file { 'tilestream-package.json':
		path => '/var/www/tilestream/package.json',
		source => 'puppet:///modules/tilestream/package.json',
	}->
	exec { "installing-tilestream-dependencies":
		command => "npm install",
		cwd => '/var/www/tilestream',
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	}

	file { 'tilestream-upstart':
		path => '/etc/init/tilestream.conf',
		content => template('tilestream/upstart.conf.erb'),
		notify => Service['tilestream'],
	}

	service { "tilestream":
	  enable => true,
		ensure => running,
		provider => 'upstart',
		require => File['tilestream-upstart'],
	}
}
