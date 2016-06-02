#!/bin/sh

if [ -d /home/loick/www/$1 ]
then
  echo "The folder \"$1\" already exists"
else
  #Create project folder
  `mkdir /home/loick/www/$1`
  if [ -d /home/loick/www/$1 ]
  then
    echo "Folder \"$1\" created."
  else
    echo "***[Error]*** Project folder creation failed"
  fi
  #Create log filder
  `mkdir /home/loick/www/$1/log`
  if [ -d /home/loick/www/$1/log ]
  then
    echo "Log Folder created."
  else
    echo "***[Error]*** Log folder creation failed"
  fi
  #Create configuration file
  echo "<VirtualHost *:80>
  DocumentRoot \"/home/loick/www/$1\"
  ServerName $1.dev

  <Directory /home/loick/www/myproject>
    Options FollowSymLinks
    AllowOverride all
    Require all granted
  </Directory>

  ErrorLog \"/home/loick/www/$1/log/$1.dev_errors\"
  CustomLog \"/home/loick/www/$1/log/$1.dev_access\" common
</VirtualHost>
  " > /home/loick/www/sites-available/$1.dev.conf
  if [ -f /home/loick/www/sites-available/$1.dev.conf ]
  then
    echo "Configuration file created in /home/loick/www/sites-available"
  else
    echo "***[Error]*** Configuration file creation failed"
  fi
  #Create index.php
  echo "
    <h1>Project $1 is running !</h1>
  " > /home/loick/www/$1/index.php
  if [ -f /home/loick/www/$1/index.php ]
  then
    echo "index.php created"
    chmod 775 /home/loick/www/$1/index.php
  else
    echo "***[Error]*** index.php creation failed"
  fi
  #restart apache
  echo "Restarting apache..."
  systemctl restart httpd.service
fi
