service mysql start
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'ayajrhou'@'localhost' IDENTIFIED BY 'password';";
mysql --password=password --user=ayajrhou -e "CREATE DATABASE wordpress; USE wordpress; source /var/wordpress.sql;";
mysql --password=password --user=ayajrhou -e "FLUSH PRIVILEGES;";

mysql --password=password --user=ayajrhou < /var/www/html/phpmyadmin/sql/create_tables.sql