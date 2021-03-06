## 2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.

### Устанавливаем spawn-fcgi и необходимые для него пакеты:
```
  [root@centos romak]# yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
  ......
  Installed:
    mod_fcgid.x86_64 0:2.3.9-4.el7_4.1                                     php.x86_64 0:5.4.16-46.el7                                         php-cli.x86_64 0:5.4.16-46.el7                                     spawn-fcgi.x86_64 0:1.6.3-5.el7

  Dependency Installed:
    libzip.x86_64 0:0.10.1-8.el7                                                                                                               php-common.x86_64 0:5.4.16-46.el7

  Complete!
  [root@centos romak]#
```
### В конфиге /etc/sysconfig/spawn-fcgi нужно раскоментировать строки.
```
  [root@centos romak]# cat /etc/sysconfig/spawn-fcgisconfig/spawn-fcgi
  # You must set some working options before the "spawn-fcgi" service will work.
  # If SOCKET points to a file, then this file is cleaned up by the init script.
  #
  # See spawn-fcgi(1) for all possible options.
  #
  # Example :
  SOCKET=/var/run/php-fcgi.sock
  OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"

  [root@centos romak]#
```  
### Создадим unit-file
```
  [root@centos romak]# mcedit /etc/systemd/system/spawn-fcgi.service

  [Unit]
  Description=Spawn-fcgi startup service by Otus
  After=network.target
  [Service]
  Type=simple
  PIDFile=/var/run/spawn-fcgi.pid
  EnvironmentFile=/etc/sysconfig/spawn-fcgi
  ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
  KillMode=process
  [Install]
  WantedBy=multi-user.target
  [root@centos romak]#
```
### Проверяем работу сервиса:
```
  [root@centos romak]# systemctl start spawn-fcgi
  [root@centos romak]# systemctl status spawn-fcgi
  ● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
     Active: active (running) since Thu 2019-07-18 15:25:14 MSK; 11s ago
   Main PID: 2819 (php-cgi)
     CGroup: /system.slice/spawn-fcgi.service
             ├─2819 /usr/bin/php-cgi
             ├─2820 /usr/bin/php-cgi
             ├─2821 /usr/bin/php-cgi
             ├─2822 /usr/bin/php-cgi
             ├─2823 /usr/bin/php-cgi
             ├─2824 /usr/bin/php-cgi
             ├─2825 /usr/bin/php-cgi
             ├─2826 /usr/bin/php-cgi
             ├─2827 /usr/bin/php-cgi
             ├─2828 /usr/bin/php-cgi
             ├─2829 /usr/bin/php-cgi
             ├─2830 /usr/bin/php-cgi
             ├─2831 /usr/bin/php-cgi
             ├─2832 /usr/bin/php-cgi
             ├─2833 /usr/bin/php-cgi
             ├─2834 /usr/bin/php-cgi
             ├─2835 /usr/bin/php-cgi
             ├─2836 /usr/bin/php-cgi
             ├─2837 /usr/bin/php-cgi
             ├─2838 /usr/bin/php-cgi
             ├─2839 /usr/bin/php-cgi
             ├─2840 /usr/bin/php-cgi
             ├─2841 /usr/bin/php-cgi
             ├─2842 /usr/bin/php-cgi
             ├─2843 /usr/bin/php-cgi
             ├─2844 /usr/bin/php-cgi
             ├─2845 /usr/bin/php-cgi
             ├─2846 /usr/bin/php-cgi
             ├─2847 /usr/bin/php-cgi
             ├─2848 /usr/bin/php-cgi
             ├─2849 /usr/bin/php-cgi
             ├─2850 /usr/bin/php-cgi
             └─2851 /usr/bin/php-cgi

  Jul 18 15:25:14 centos.localdomain systemd[1]: Started Spawn-fcgi startup service by Otus.
  [root@centos romak]#
 ```
 
