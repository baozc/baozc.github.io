- `groupadd mysql`
- `useradd -r -g mysql mysql`
- `tar zxvf /path/to/mysql-VERSION-OS.tar.gz`
- `ln -s full-path-to-mysql-VERSION-OS mysql`
- `cd mysql`
- `mkdir mysql-files`
- `chown mysql:mysql mysql-files`
- `chmod 750 mysql-files`
- `mkdir data`
- `chown mysql:mysql data`
- `mkdir tmp`
- `chown mysql:mysql tmp`
- `bin/mysqld --initialize --user=mysql --basedir=install_locate --datadir=install_locate/data`

2018-06-26T10:00:11.236271Z mysqld_safe error: log-error set to '/var/log/mariadb/mariadb.log', however file don't exists. Create writable for user 'mysql'.

- `chmod o+w /var/log/`
- bin/mysqld --verbose --help | grep -A 1 'Default options' 查看mysql服务配置文件路径，服务器首先会读取/etc/my.cnf文件，如果发现该文件不存在，再依次尝试从后面的几个路径进行读取。
- 使用locate my.cnf命令可以列出所有的my.cnf文件
- bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

```properties
[mysqld]
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
log-error=/usr/local/mysql/tmp/mysql.err
pid-file=/usr/local/mysql/data/mysql.pid

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[client]
#socket=/usr/local/mysql/tmp/mysql.sock

[mysqld_safe]
#log-error=/var/log/mysql/mysql.log
#pid-file=/var/run/mysql/mysql.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

```
