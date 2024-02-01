# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Configure Nginx server
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => '
    server {
      listen 80;
      server_name _;

      location / {
        return 301 http://$host/redirect_me;
      }

      location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
      }

      location /hello {
        return 200 "Hello World!";
      }

      error_page 404 /custom_404.html;
      location = /custom_404.html {
        root /usr/share/nginx/html;
        internal;
      }
    }
  ',
  require => Package['nginx'],
}

# Enable Nginx server
file { '/etc/nginx/sites-enabled/default':
  ensure  => 'link',
  target  => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
  notify  => Service['nginx'],
}

# Restart Nginx service
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/nginx/sites-enabled/default'],
}

# Custom 404 error page
file { '/usr/share/nginx/html/custom_404.html':
  ensure  => present,
  content => 'Ceci n\'est pas une page',
  require => Package['nginx'],
}