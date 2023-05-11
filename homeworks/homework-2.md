# Домашнее задание к занятию «Типы виртуализации: KVM, QEMU»

## Задание 2


```shell
bondarenko@Debi-vhost:~/qemu-images$ qemu-img create -f qcow2 alpine.img 8G
Formatting 'alpine.img', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=8589934592 lazy_refcounts=off refcount_bits=16
bondarenko@Debi-vhost:~/qemu-images/alpine$ nano run-alpine.sh
bondarenko@Debi-vhost:~/qemu-images/alpine$ chmod +x run-alpine.sh
bondarenko@Debi-vhost:~/qemu-images/alpine$ ./run-alpine.sh

```

*run-alpine.sh*

```shell
#!/bin/bash

qemu-system-x86_64 \
-m 2048 \
-smp cores=4 \
-cdrom ~/_iso/alpine-standard-3.13.5-x86.iso \
-hda alpine.img \
-boot d \
-net nic \
-net user \
-name alpine-vm

```
*Скриншот запуска*

![](./homework-2/image-01.jpg)