# Class: ntp
#
#   Takes care of NTP service
#   Keeps the default ntp.conf
#   Makes use of step-tickers so clock is slowly adjusted if drifted
#   Configure step-tickers using rhel.pool.ntp.org hosts
#   

class ntp::install {
  package {'ntp':
    ensure => installed, 
  }
}

class ntp::config {
  file { '/etc/ntp/step-tickers':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => "puppet:///modules/ntp/steptickers",
    require => Class["ntp::install"],
    notify => Class["ntp::service"],
  }
}

class ntp::service {
  service { 'ntpd':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Class["ntp::config"],
  }
}

class ntp {
  include ntp::install, ntp::config, ntp::service
}
