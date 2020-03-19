# Работа с загрузчиком

### 1. Попасть в систему без пароля несколькими способами
1. Прописать в конфигурации GRUB параметр `rd.break`. Этот параметр останавливает загрузку на стадии initramfs и позволит сбросить пароль пользователя root. 
После загрузки монтируем /sysroot командой `mount -o remount,rw /sysroot` и меняем текущий корень командой `chroot /sysroot`. 
Далее командой `passwd` меняем пароль учетной записи root. 
Затем, чтобы это все сохранилось, создаем в корне файл .autorelabel командой `touch /.autorelabel`
1. Загрузиться с LiveCD  в Troubleshooting - Rescue a CentOS system
1. Добавить в параметры загрузки вместо `ro` пишем  `rw init=/bin/sh` , затем проделать все то же, что и в пункте 1.

### 2. Установить систему с LVM, после чего переименовать VG

```bash
[root@centos romak]# lsblk
    NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                      8:0    0   60G  0 disk
    ├─sda1                   8:1    0    1G  0 part /boot
    └─sda2                   8:2    0   59G  0 part
      ├─centos_centos-root 253:0    0 35.6G  0 lvm  /
      ├─centos_centos-swap 253:1    0    6G  0 lvm  [SWAP]
      └─centos_centos-home 253:2    0 17.4G  0 lvm  /home
    sr0                     11:0    1 1024M  0 rom
[root@centos romak]# vgs
  VG            #PV #LV #SN Attr   VSize   VFree
  centos_centos   1   3   0 wz--n- <59.00g    0
[root@centos romak]#
```
### 3. Добавить модуль в initrd





![Alt-loader](https://github.com/RomaK79/OTUS/blob/master/Lesson008/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA.PNG)
