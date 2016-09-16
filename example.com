upstream php {
server unix:/run/php/php5.6-fpm.sock;
#server 127.0.0.1:9000;
}

server {

  server_name example.com   www.example.com;

  access_log /var/log/nginx/example.com.access.log;
  error_log /var/log/nginx/example.com.error.log;
  root /var/www/example.com/htdocs;
  index index.php index.html index.htm;
  # PHP NGINX CONFIGURATION
  # DO NOT MODIFY, ALL CHANGES LOST AFTER UPDATE EasyEngine (ee)
 location / {
    try_files $uri $uri/ /index.php?$args;
 }

 location ~ \.php$ {
      try_files $uri =404;
      include fastcgi_params;
      fastcgi_pass php;
  }

  # Deny backup extensions & log files
    location ~* ^.+\.(bak|log|old|orig|original|php#|php~|php_bak|save|swo|swp|sql)$ {
  	deny all;
  	access_log off;
  	log_not_found off;
	}

# Return 403 forbidden for readme.(txt|html) or license.(txt|html) or example.(txt|html)
	if ($uri ~* "^.+(readme|license|example)\.(txt|html)$") {
  		return 403;
 }
}
