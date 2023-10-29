# Домашнее задание к занятию «Уязвимости и атаки на информационные системы»

### Задание 1

Скачайте и установите виртуальную машину Metasploitable: https://sourceforge.net/projects/metasploitable/.

Это типовая ОС для экспериментов в области информационной безопасности, с которой следует начать при анализе уязвимостей.

Просканируйте эту виртуальную машину, используя **nmap**.

Попробуйте найти уязвимости, которым подвержена эта виртуальная машина.

Сами уязвимости можно поискать на сайте https://www.exploit-db.com/.

Для этого нужно в поиске ввести название сетевой службы, обнаруженной на атакуемой машине, и выбрать подходящие по версии уязвимости.

Ответьте на следующие вопросы:

- Какие сетевые службы в ней разрешены?
- Какие уязвимости были вами обнаружены? (список со ссылками: достаточно трёх уязвимостей)
  
*Приведите ответ в свободной форме.*  

## Ответ

```
bondarenko@DebiMachine:~$ sudo nmap -sV 192.168.0.148
Starting Nmap 7.80 ( https://nmap.org ) at 2023-10-28 23:18 MSK
Nmap scan report for 192.168.0.148
Host is up (0.00092s latency).
Not shown: 977 closed ports
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
53/tcp   open  domain      ISC BIND 9.4.2
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
111/tcp  open  rpcbind     2 (RPC #100000)
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp  open  exec        netkit-rsh rexecd
513/tcp  open  login       OpenBSD or Solaris rlogind
514/tcp  open  tcpwrapped
1099/tcp open  java-rmi    GNU Classpath grmiregistry
1524/tcp open  bindshell   Metasploitable root shell
2049/tcp open  nfs         2-4 (RPC #100003)
2121/tcp open  ftp         ProFTPD 1.3.1
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp open  vnc         VNC (protocol 3.3)
6000/tcp open  X11         (access denied)
6667/tcp open  irc         UnrealIRCd
8009/tcp open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
```

## *Уязвимости*
vsftpd 2.3.4 - Backdoor Command Execution - https://www.exploit-db.com/exploits/49757

PostgreSQL 8.2/8.3/8.4 - UDF for Command Execution - https://www.exploit-db.com/exploits/7855

ProFTPd 1.3 - 'mod_sql' 'Username' SQL Injection - https://www.exploit-db.com/exploits/32798

### Задание 2

Проведите сканирование Metasploitable в режимах SYN, FIN, Xmas, UDP.

Запишите сеансы сканирования в Wireshark.

Ответьте на следующие вопросы:

- Чем отличаются эти режимы сканирования с точки зрения сетевого трафика?
- Как отвечает сервер?

*Приведите ответ в свободной форме.*

## Ответ

SYN сканирование (SYN scan):

Этот метод использует пакеты с флагом SYN (синхронизация) для установления соединения с целевым хостом.
Если целевой порт открыт, то целевой хост отвечает пакетом с флагом SYN/ACK.
Если порт закрыт, то целевой хост отвечает пакетом с флагом RST (сброс соединения).
SYN сканирование является более скрытым, чем другие методы, так как оно не завершает установление соединения.

```console
bondarenko@DebiMachine:~$ cat tcpdump.txt | grep 192.168.0.148 | head -20
23:37:23.725338 ARP, Request who-has 192.168.0.148 tell DebiMachine, length 28
23:37:23.725999 ARP, Reply 192.168.0.148 is-at 08:00:27:9f:55:74 (oui Unknown), length 46
23:37:23.791220 IP DebiMachine.63471 > 192.168.0.148.1025: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.791599 IP 192.168.0.148.1025 > DebiMachine.63471: Flags [R.], seq 0, ack 3785453443, win 0, length 0
23:37:23.792011 IP DebiMachine.63471 > 192.168.0.148.imap2: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.792251 IP DebiMachine.63471 > 192.168.0.148.5900: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.792447 IP 192.168.0.148.imap2 > DebiMachine.63471: Flags [R.], seq 0, ack 3785453443, win 0, length 0
23:37:23.792448 IP 192.168.0.148.5900 > DebiMachine.63471: Flags [S.], seq 2670273821, ack 3785453443, win 5840, options [mss 1460], length 0
23:37:23.792458 IP DebiMachine.63471 > 192.168.0.148.5900: Flags [R], seq 3785453443, win 0, length 0
23:37:23.792801 IP DebiMachine.63471 > 192.168.0.148.1723: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.793039 IP DebiMachine.63471 > 192.168.0.148.imaps: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.793234 IP 192.168.0.148.1723 > DebiMachine.63471: Flags [R.], seq 0, ack 3785453443, win 0, length 0
23:37:23.793235 IP 192.168.0.148.imaps > DebiMachine.63471: Flags [R.], seq 0, ack 3785453443, win 0, length 0
23:37:23.793541 IP DebiMachine.63471 > 192.168.0.148.ssh: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.793776 IP DebiMachine.63471 > 192.168.0.148.submission: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.793976 IP 192.168.0.148.ssh > DebiMachine.63471: Flags [S.], seq 2669075405, ack 3785453443, win 5840, options [mss 1460], length 0
23:37:23.793976 IP 192.168.0.148.submission > DebiMachine.63471: Flags [R.], seq 0, ack 3785453443, win 0, length 0
23:37:23.793983 IP DebiMachine.63471 > 192.168.0.148.ssh: Flags [R], seq 3785453443, win 0, length 0
23:37:23.794326 IP DebiMachine.63471 > 192.168.0.148.sunrpc: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
23:37:23.794584 IP DebiMachine.63471 > 192.168.0.148.1720: Flags [S], seq 3785453442, win 1024, options [mss 1460], length 0
```

FIN сканирование (FIN scan):

Этот метод отправляет пакеты с флагом FIN (завершение) для целевых портов.
Если порт закрыт, целевой хост должен отправить пакет с флагом RST в ответ.
Если порт открыт, то целевой хост может проигнорировать такие пакеты.
FIN сканирование обычно менее надежно, так как ответы могут быть непредсказуемыми.

```console
bondarenko@DebiMachine:~$ cat tcpdump-sA.txt | grep 192.168.0.148 | head -20
23:40:45.143577 ARP, Request who-has 192.168.0.148 tell DebiMachine, length 28
23:40:45.144342 ARP, Reply 192.168.0.148 is-at 08:00:27:9f:55:74 (oui Unknown), length 46
23:40:45.226897 IP DebiMachine.61443 > 192.168.0.148.http: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.226975 IP DebiMachine.61443 > 192.168.0.148.mysql: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227030 IP DebiMachine.61443 > 192.168.0.148.netbios-ssn: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227087 IP DebiMachine.61443 > 192.168.0.148.microsoft-ds: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227143 IP DebiMachine.61443 > 192.168.0.148.256: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227343 IP DebiMachine.61443 > 192.168.0.148.ms-wbt-server: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227398 IP DebiMachine.61443 > 192.168.0.148.5900: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227466 IP DebiMachine.61443 > 192.168.0.148.auth: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227491 IP 192.168.0.148.http > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.227530 IP DebiMachine.61443 > 192.168.0.148.epmap: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227585 IP DebiMachine.61443 > 192.168.0.148.pop3: Flags [.], ack 3453887439, win 1024, length 0
23:40:45.227865 IP 192.168.0.148.mysql > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.227867 IP 192.168.0.148.netbios-ssn > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.227867 IP 192.168.0.148.microsoft-ds > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.227868 IP 192.168.0.148.256 > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.227869 IP 192.168.0.148.ms-wbt-server > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.228185 IP 192.168.0.148.5900 > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
23:40:45.228186 IP 192.168.0.148.auth > DebiMachine.61443: Flags [R], seq 3453887439, win 0, length 0
```

Xmas сканирование (Xmas tree scan):

Этот метод отправляет пакеты с установленными флагами FIN, URG (urgent), и PSH (push).
Попытка определить статус порта происходит на основе ответов от целевого хоста.
Если порт закрыт, целевой хост должен отправить пакет с флагом RST.
Xmas сканирование также менее надежно и менее распространено.

```console
bondarenko@DebiMachine:~$ cat tcpdump-sX.txt | grep 192.168.0.148 | head -20
23:08:40.660199 ARP, Request who-has 192.168.0.148 tell DebiMachine, length 28
23:08:40.661197 ARP, Reply 192.168.0.148 is-at 08:00:27:9f:55:74 (oui Unknown), length 46
23:08:40.732874 IP DebiMachine.40874 > 192.168.0.148.http: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.732962 IP DebiMachine.40874 > 192.168.0.148.microsoft-ds: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733031 IP DebiMachine.40874 > 192.168.0.148.imaps: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733102 IP DebiMachine.40874 > 192.168.0.148.mysql: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733171 IP DebiMachine.40874 > 192.168.0.148.epmap: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733240 IP DebiMachine.40874 > 192.168.0.148.pop3: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733308 IP DebiMachine.40874 > 192.168.0.148.ms-wbt-server: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733378 IP DebiMachine.40874 > 192.168.0.148.telnet: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733504 IP 192.168.0.148.imaps > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.733506 IP DebiMachine.40874 > 192.168.0.148.http-alt: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.733573 IP DebiMachine.40874 > 192.168.0.148.1720: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.734008 IP 192.168.0.148.epmap > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.734009 IP 192.168.0.148.pop3 > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.734010 IP 192.168.0.148.ms-wbt-server > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.734010 IP 192.168.0.148.http-alt > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.734522 IP 192.168.0.148.1720 > DebiMachine.40874: Flags [R.], seq 0, ack 2182805650, win 0, length 0
23:08:40.737098 IP DebiMachine.40874 > 192.168.0.148.rtsp: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
23:08:40.737157 IP DebiMachine.40874 > 192.168.0.148.1723: Flags [FPU], seq 2182805649, win 1024, urg 0, length 0
```

UDP сканирование (UDP scan):

При UDP сканировании отправляются UDP-пакеты на целевой порт.
Если порт закрыт, целевой хост может отправить ICMP сообщение о недостижимости порта.
UDP сканирование может быть более сложным, так как UDP-пакеты могут быть отброшены без какого-либо ответа, и определение состояния порта может быть более трудоемким.

```console
bondarenko@DebiMachine:~$ cat tcpdump-sU.txt | grep 192.168.0.148 | head -20
23:11:33.794504 ARP, Request who-has 192.168.0.148 tell DebiMachine, length 28
23:11:33.795188 ARP, Reply 192.168.0.148 is-at 08:00:27:9f:55:74 (oui Unknown), length 46
23:11:33.878545 IP DebiMachine.58661 > 192.168.0.148.21318: UDP, length 0
23:11:33.878615 IP DebiMachine.58661 > 192.168.0.148.53838: UDP, length 0
23:11:33.878670 IP DebiMachine.58661 > 192.168.0.148.58631: UDP, length 0
23:11:33.878724 IP DebiMachine.58661 > 192.168.0.148.1027: UDP, length 0
23:11:33.878781 IP DebiMachine.58661 > 192.168.0.148.17573: UDP, length 0
23:11:33.878836 IP DebiMachine.58661 > 192.168.0.148.40116: UDP, length 0
23:11:33.878892 IP DebiMachine.58661 > 192.168.0.148.17468: UDP, length 0
23:11:33.878950 IP DebiMachine.58661 > 192.168.0.148.17338: UDP, length 0
23:11:33.879021 IP DebiMachine.58661 > 192.168.0.148.61370: UDP, length 0
23:11:33.879125 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 21318 unreachable, length 36
23:11:33.879126 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 53838 unreachable, length 36
23:11:33.879076 IP DebiMachine.58661 > 192.168.0.148.20411: UDP, length 0
23:11:33.879500 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 58631 unreachable, length 36
23:11:33.879501 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 1027 unreachable, length 36
23:11:33.879502 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 17573 unreachable, length 36
23:11:33.879502 IP 192.168.0.148 > DebiMachine: ICMP 192.168.0.148 udp port 40116 unreachable, length 36
23:11:33.882404 IP DebiMachine.58661 > 192.168.0.148.31059: UDP, length 0
23:11:33.882468 IP DebiMachine.58661 > 192.168.0.148.1419: UDP, length 0
```