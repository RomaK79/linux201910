## 3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами
### создаем шаблон для инстанса httpd
```
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@first.service
```
### Изменяем  в Unit-файле строчку: ExecStart=/usr/sbin/httpd -f %i.conf -DFOREGROUND
```
   [root@centos romak]# mcedit /usr/lib/systemd/system/httpd@first.service

   [Unit]
   Description=The Apache HTTP Server
   After=network.target remote-fs.target nss-lookup.target
   Documentation=man:httpd(8)
   Documentation=man:apachectl(8)

   [Service]
   Type=notify
   EnvironmentFile=/etc/sysconfig/httpd
   ExecStart=/usr/sbin/httpd -f %i.conf -DFOREGROUND
   ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
   ExecStop=/bin/kill -WINCH ${MAINPID}
   # We want systemd to give httpd some time to finish gracefully, but still want
   # it to kill httpd after TimeoutStopSec if something went wrong during the
   # graceful stop. Normally, Systemd sends SIGTERM signal right after the
   # ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
   # httpd time to finish.
   KillSignal=SIGCONT
   PrivateTmp=true

   [Install]
   WantedBy=multi-user.target
```
### Копируем конфиг httpd в /etc/httpd/first.conf
```
   [root@centos romak]# cp /etc/httpd/conf/httpd.conf /etc/httpd/first.conf
   [root@centos romak]# ll /etc/httpd/
   total 12
   drwxr-xr-x. 2 root root    37 Jul 12 15:49 conf
   drwxr-xr-x. 2 root root    82 Jul 12 15:49 conf.d
   drwxr-xr-x. 2 root root   146 Jul 12 15:49 conf.modules.d
   -rw-r--r--. 1 root root 11753 Jul 18 17:30 first.conf
   lrwxrwxrwx. 1 root root    19 Jul 12 15:49 logs -> ../../var/log/httpd
   lrwxrwxrwx. 1 root root    29 Jul 12 15:49 modules -> ../../usr/lib64/httpd/modules
   lrwxrwxrwx. 1 root root    10 Jul 12 15:49 run -> /run/httpd
```   
### Изменяем параметры PidFile и Listen:
```
   [root@centos romak]# mcedit /etc/httpd/first.conf

   PidFile /var/run/httpd-first.pid
   Listen 8080
```   
### Запускаем новый сервис и проверяем статус:
```
[root@centos romak]# systemctl start httpd@first
[root@centos romak]# systemctl status httpd@first
● httpd@first.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd@first.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-07-18 17:45:18 MSK; 3s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 1968 (httpd)
   Status: "Processing requests..."
   CGroup: /system.slice/system-httpd.slice/httpd@first.service
           ├─1968 /usr/sbin/httpd -f first.conf -DFOREGROUND
           ├─1969 /usr/sbin/httpd -f first.conf -DFOREGROUND
           ├─1970 /usr/sbin/httpd -f first.conf -DFOREGROUND
           ├─1971 /usr/sbin/httpd -f first.conf -DFOREGROUND
           ├─1972 /usr/sbin/httpd -f first.conf -DFOREGROUND
           └─1973 /usr/sbin/httpd -f first.conf -DFOREGROUND

Jul 18 17:45:17 centos.localdomain systemd[1]: Starting The Apache HTTP Server...
Jul 18 17:45:17 centos.localdomain httpd[1968]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using centos.localdomain. Set the 'ServerName' directive globally to suppress this message
Jul 18 17:45:18 centos.localdomain systemd[1]: Started The Apache HTTP Server.
[root@centos romak]#
```
