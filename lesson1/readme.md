## Клонирование репозитория

```
git clone git@github.com:RomaK79/manual_kernel_update.git
Cloning into 'manual_kernel_update'...
remote: Enumerating objects: 40, done.
remote: Total 40 (delta 0), reused 0 (delta 0), pack-reused 40
Receiving objects: 100% (40/40), 12.04 KiB | 12.04 MiB/s, done.
Resolving deltas: 100% (7/7), done.

```

## 

```
romak@ubuntu:~/otus$ cd manual_kernel_update/
romak@ubuntu:~/otus/manual_kernel_update$ ls -l
total 12
drwxrwxr-x 2 romak romak 4096 Mar  5 05:16 manual
drwxrwxr-x 4 romak romak 4096 Mar  5 05:16 packer
-rwxrwxr-x 1 romak romak 1335 Mar  5 05:16 Vagrantfile
romak@ubuntu:~/otus/manual_kernel_update$
```

## Запускаем виртуальную машину и логинимся:


```
romak@ubuntu:~/otus/manual_kernel_update$ sudo vagrant up
Bringing machine 'kernel-update' up with 'virtualbox' provider...
==> kernel-update: Importing base box 'centos/7'...

```

```
romak@ubuntu:~/otus/manual_kernel_update$ sudo vagrant ssh
[vagrant@kernel-update ~]$ uname -r
3.10.0-957.12.2.el7.x86_64
[vagrant@kernel-update ~]$
[vagrant@kernel-update ~]$

```

## Обновляем ядро

```
[vagrant@kernel-update ~]$ sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

....
Installed:
  elrepo-release.noarch 0:7.0-3.el7.elrepo

Complete!
[vagrant@kernel-update ~]$


```

```
[vagrant@kernel-update ~]$ sudo yum --enablerepo elrepo-kernel install kernel-ml -y

......

Installed:
  kernel-ml.x86_64 0:5.5.7-1.el7.elrepo

Complete!
[vagrant@kernel-update ~]$


```

## Обновляем конфигурацию загрузчика:

```
[vagrant@kernel-update ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.5.7-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.5.7-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-957.12.2.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.12.2.el7.x86_64.img
done
[vagrant@kernel-update ~]$

```

## Выбираем загрузку с новым ядром по-умолчанию:

```
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$

```

## Перезагружаем виртуальную машину:

```
[vagrant@kernel-update ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
Connection to 127.0.0.1 closed.
romak@ubuntu:~/otus/manual_kernel_update$
```

## После перезагрузки виртуальной машины заходим в нее и выполняем:

```
romak@ubuntu:~/otus/manual_kernel_update$ sudo vagrant ssh
Last login: Thu Mar  5 13:37:25 2020 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
5.5.7-1.el7.elrepo.x86_64
[vagrant@kernel-update ~]$


```

## Packer

```
root@ubuntu:/home/romak/otus/manual_kernel_update# cd packer/
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# packer build centos.json
centos-7.7: output will be in this color.

==> centos-7.7: Cannot find "Default Guest Additions ISO" in vboxmanage output (or it is empty)
==> centos-7.7: Retrieving Guest additions checksums
................

Build 'centos-7.7' finished.

==> Builds finished. The artifacts of successful builds are:
--> centos-7.7: 'virtualbox' provider box: centos-7.7.1908-kernel-5-x86_64-Minimal.box
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# 

```

## в текущей директории мы увидим файл centos-7.7.1908-kernel-5-x86_64-Minimal.box

```
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# ls -la
total 750676
drwxrwxr-x 5 romak romak      4096 Mar  5 06:52 .
drwxrwxr-x 6 romak romak      4096 Mar  5 05:27 ..
-rw-r--r-- 1 root  root  768660088 Mar  5 06:52 centos-7.7.1908-kernel-5-x86_64-Minimal.box
-rwxrwxr-x 1 romak romak      1997 Mar  5 05:16 centos.json
drwxrwxr-x 2 romak romak      4096 Mar  5 05:16 http
drwxrwxr-x 3 romak romak      4096 Mar  5 06:16 packer_cache
drwxrwxr-x 2 romak romak      4096 Mar  5 05:16 scripts
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# 


```

## vagrant init (тестирование)
Проведем тестирование созданного образа. Выполним его импорт в vagrant:

```
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# vagrant box add --name centos-7-5 centos-7.7.1908-kernel-5-x86_64-Minimal.box 
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'centos-7-5' (v0) for provider: 
    box: Unpacking necessary files from: file:///home/romak/otus/manual_kernel_update/packer/centos-7.7.1908-kernel-5-x86_64-Minimal.box
==> box: Successfully added box 'centos-7-5' (v0) for 'virtualbox'!

root@ubuntu:/home/romak/otus/manual_kernel_update/packer# vagrant box list
centos-7-5 (virtualbox, 0)
root@ubuntu:/home/romak/otus/manual_kernel_update/packer#


```

## создадим новый Vagrantfile:

```
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# mkdir test
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# cd test/
root@ubuntu:/home/romak/otus/manual_kernel_update/packer/test# vagrant init centos-7-5
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
root@ubuntu:/home/romak/otus/manual_kernel_update/packer/test# ls -la
total 12
drwxr-xr-x 2 root  root  4096 Mar 12 06:42 .
drwxrwxr-x 6 romak romak 4096 Mar 12 06:41 ..
-rw-r--r-- 1 root  root  3017 Mar 12 06:42 Vagrantfile


```

## Теперь запустим виртуальную машину, подключимся к ней и проверим, что у нас в ней новое ядро:


```
root@ubuntu:/home/romak/otus/manual_kernel_update/packer/test# vagrant up
Bringing machine 'kernel-update' up with 'virtualbox' provider...
root@ubuntu:/home/romak/otus/manual_kernel_update/packer/test# vagrant ssh
Last login: Thu Mar  5 14:50:45 2020 from 10.0.2.2
[vagrant@localhost ~]$ uname -r
5.5.7-1.el7.elrepo.x86_64
[vagrant@localhost ~]$ 

```

## Vagrant cloud

## Поделимся полученным образом с сообществом. 

```
root@ubuntu:/home/romak/otus/manual_kernel_update/packer# vagrant cloud publish --release romak79/centos-7-7 1.0 virtualbox centos-7.7.1908-kernel-5-x86_64-Minimal.box 
You are about to publish a box on Vagrant Cloud with the following options:
romak79/centos-7-7:   (v1.0) for provider 'virtualbox'
Automatic Release:     true
Do you wish to continue? [y/N] y
==> cloud: Creating a box entry...
==> cloud: Box already exists, updating instead...
==> cloud: Creating a version entry...
==> cloud: Version already exists, updating instead...
==> cloud: Creating a provider entry...
==> cloud: Provider already exists, updating instead...
==> cloud: Uploading provider with file /home/romak/otus/manual_kernel_update/packer/centos-7.7.1908-kernel-5-x86_64-Minimal.box
==> cloud: Releasing box...
Complete! Published romak79/centos-7-7
tag:             romak79/centos-7-7
username:        romak79
name:            centos-7-7
private:         false
downloads:       0
created_at:      2020-03-16T15:31:20.148+03:00
updated_at:      2020-03-16T15:31:24.527+03:00
current_version: 1.0
providers:       virtualbox
old_versions:    ...

root@ubuntu:/home/romak/otus/manual_kernel_update/packer# 


```

https://app.vagrantup.com/romak79/boxes/centos-7-7
