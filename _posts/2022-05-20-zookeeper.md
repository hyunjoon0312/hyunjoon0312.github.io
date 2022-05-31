---
title:  "[ZOOKEEPER #1] APACHE ZOOKEEPER 개념부터 설치까지"
excerpt: "Apache Zookeeper에 대한 개념부터 설치까지"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Hadoop
tags:
  - Zookeeper

---

HDFS와 YARN의 Apache Hadoop 시리즈에 이어서 이번에는 Apache Zookeeper에 대해서 알아보도록 하겠습니다. Hadoop 시리즈에서는 내용이 많아 개념과 설치 편으로 나눠서 포스팅을 했었지만 이번에는 한 포스팅으로 개념부터 설치까지 한번에 모두 이야기해보도록 하겠습니다. 



앞서 포스팅한 HADOOP 시리즈가 궁금하시다면 아래 링크를 통해 보실 수 있습니다.



[하둡 에코 시스템(Hadoop Eco System)이란?](https://onestep-log.com/hadoop/hadoop-eco/)  
[[HADOOP #1\] HDFS란 무엇인가?](https://onestep-log.com/hadoop/hdfs/)  
[[HADOOP #2\] YARN이란 무엇인가?](https://onestep-log.com/hadoop/yarn/)  
[[HADOOP #3\] Apache Hadoop 설치하기(3버전 기준)](https://onestep-log.com/hadoop/install-hadoop/)  



## Apache Zookeeper란?

이제는 너무나 식상하고 당연한 단어이긴 하지만 빅데이터 시대가 오면서, 한 대의 컴퓨터에서 동작하는 프로그램으로 감당하기에는 데이터의 사이즈가 너무 커져 버렸습니다. 이를 해결하기 위해 다수의 컴퓨터에서 동작하는 프로그램이 등장하였고, 이렇게 여러 대의 컴퓨터에서 동작하는 프로그램을 코디네이팅(Coordinating) 하기 위한 서비스가 필요하게 되었습니다. 이러한 필요에 의해 **안정적인 코디네이션(Coordination) 서비스를 제공하기 위해 등장한 것이 바로 아파치 주키퍼(Apache Zookeeper)** 입니다.



## Apache Zookeeper의 역할

앞서 언급했듯 아파치 주키퍼는 분산 시스템의 코디네이션 작업을 가능하게 해줍니다. 여기서 이야기하는 코디네이션 작업은 크게 두 가지로 나누어 집니다. 하나는 여러 장비에서 동작하고 있는 프로세스들이 함께 공통의 목표를 가지고 작업을 수행할 수 있도록 조절하는 것이며, 또 하나는 서로 동시에 가질 수 없는 역할을 두 개 이상의 프로세스가 가지려 할 때 하나의 프로세스만 해당 역할을 가질 수 있도록 조정하는 것입니다. 처음의 작업이 협업, 협력의 조정이며, 두번째 작업이 경합의 조정입니다.



앞서 이야기했던 HDFS를 예로 들어 보겠습니다. Datanode들은 현재 자신의 상태를 Active Namenode에게 알리고 이에 Active Namenode는 정상적인 상태의 Datanode들에게 데이터를 저장할 수 있도록 합니다. 이것이 프로세스들이 함께 공통의 목표를 가지고 작업을 수행할 수 있도록 조절하는 협업의 예 입니다. 그리고 하나의 프로세스만 가질 수 있는 역할을 어떤 프로세스가 가질지 조정하는 경합의 예는 다음과 같습니다. Namenode가 처음 실행되며 HA 구성된 두 개의 Namenode 중 어떤 것이 Active의 역할을 가질지, 어떤 것이 Standby의 역할을 가질지 조정을 해줍니다.



## Apache Zookeeper의 모드

아파치 주키퍼는 Stnadalone 모드와 Quorum 모드, 두가지의 모드로 실행될 수 있습니다. Standalon 모드는 말 그대로 하나의 장비에서 주키퍼가 실행되는 것입니다. 이 경우 하나의 주키퍼 서버 밖에 없기 때문에 해당 서버가 장애로 죽을 경우 고가용성(High Availability)을 보장할 수 없어 코디네이션 서비스는 중단 됩니다. Quorum 모드에서는 최소 3개의 주키퍼 서버로 구성되기 때문에 하나의 주키퍼 서버가 장애로 죽더라도 살아 있는 다른 두 개의 주키퍼 서버 중 하나가 Learder가 선출되어 서비스 중단 없이 코디네이션을 제공하게 됩니다.



## Apache Zookeeper 설치하기

아파치 주키퍼의 설치는 아파치 하둡을 설치할 때 보다 훨씬 쉽고 빠르게 진행할 수 있습니다. 순서대로 설명드리도록 하겠습니다.

### 설치 파일 다운로드

[**공식 홈페이지의 릴리즈 페이지**](https://zookeeper.apache.org/releases.html)에서 원하는 버전을 먼저 선택해주고, 아파치(Apache) 다운로드 페이지로 넘어가면 선택한 버전의 bin gzip 압축 파일을 다운로드 해줍니다. 저는 3.5.9 버전으로 선택하였습니다.  

![Zookeeper Download](https://drive.google.com/uc?export=view&id=11MPJxR4WbDsSTfLeqPF3K8SMoGh30sA8)

![Zookeeper Releases](https://drive.google.com/uc?export=view&id=1webN03P8LERIEberk_O57geyuK0q0zg2)


### 압축 해제 및 설치
다운받은 bin gzip 파일의 압축을 풀어준 뒤 접근이 편리하도록 Symbolic link를 생성해 줍니다.

```bash
tar xvfz apache-zookeeper-3.5.9-bin.tar.gz -C /opt
ln -s /opt/apache-zookeeper-3.5.9-bin /opt/zoo
```

### 환경 설정

주키퍼 디렉터리의 conf 디렉터리에 있는 zoo_sample.cfg 파일을 zoo.cfg 파일로 변경하여 설정 파일을 생성해 줍니다. 그리고 해당 파일을 열어 dataDir을 정의해주고 Quorum 모드로 설치하기 위해 다른 장비의 주키퍼 서버를 정의해 줍니다.

```bash
cd /opt/zoo/conf
cp -rfp zoo_sample.cfg zoo.cfg
vi zoo.cfg  

dataDir=/data/zoo/data
server.1=devlife-test-001:2888:3888
server.2=devlife-test-002:2888:3888
server.3=devlife-test-003:2888:3888
```

각 주키퍼 서버의 myid 파일을 생성 및 정의해 줍니다. 주의할 점은 다음과 같습니다.

- 각 주키퍼 서버는 서로 다른 ID를 정의 해야 합니다. 
- zoo.cfg 파일에 정의되어 있는 dataDir 디렉터리에 myid 파일이 존재해야 합니다. 
- myid 파일은 해당 서버의 ID로 정의할 숫자로만 되어 있어야 하며, 단일 행으로 구성되어 있어야 합니다.
  예) devlife-test-001의 myid 파일에는 1만 있어야하며, devlife-test-002의 myid 파일에는 2만 있어야 합니다.
- myid는 고유한 값이어야 하며 1에서 255까지 사용 가능합니다.

```bash
vi /data/zoo/data/myid
1
```

### 서버 실행 및 확인

~/zoo/bin/zkServer.sh 파일을 실행하여 주키퍼 서버를 실행합니다.

```bash
/opt/zoo/bin/zkServer.sh start
```

주키퍼가 정상적으로 실행되었는지 확인하는 방법으로는 세가지가 있습니다.

1. 주키퍼의 Java Process가 실행되고 있는지 확인

```bash
jps
106292 QuorumPeerMain
106991 Jps
```

2. netstat Tool을 이용하여 주키퍼 서버가 이용하는 포트(Port)가 열려있는지 확인

```bash
netstat -naltop | grep -i listen
tcp6       0      0 :::2181                 :::*                    LISTEN      106929/java      off (0.00/0/0)
tcp6       0      0 :::3306                 :::*                    LISTEN      -                off (0.00/0/0)
tcp6       0      0 192.168.75.201:3888     :::*                    LISTEN      106929/java      off (0.00/0/0)
tcp6       0      0 :::8080                 :::*                    LISTEN      106929/java      off (0.00/0/0)
```

### zookeeper port인 2181, 3888이 LISTEN 상태인지 확인

3. 주키퍼 CLI를 통한 확인

```bash
/opt/zoo/bin/zkCli.sh -server devlife-test-001:2181
/usr/bin/java
Connecting to devlife-test-001:2181
2020-03-25 19:28:45,299 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.7-f0fdd52973d373ffd9c86b81d99842dc2c7f660e, built on 02/10/2020 11:30 GMT
2020-03-25 19:28:45,301 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=devlife-test-002
2020-03-25 19:28:45,301 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_242
2020-03-25 19:28:45,303 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Private Build
2020-03-25 19:28:45,303 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-8-openjdk-amd64/jre
2020-03-25 19:28:45,326 [myid:] - INFO  [main:ClientCnxn@1653] - zookeeper.request.timeout value is 0. feature enabled=
2020-03-25 19:28:45,331 [myid:devlife-test-001:2181] - INFO  [main-SendThread(devlife-test-001:2181):ClientCnxn$SendThread@1112] - Opening socket connection to server devlife-test-001/195.169.33.201:2181. Will not attempt to authenticate using SASL (unknown error)
Welcome to ZooKeeper!
JLine support is enabled
2020-03-25 19:28:45,379 [myid:devlife-test-001:2181] - INFO  [main-SendThread(devlife-test-001:2181):ClientCnxn$SendThread@959] - Socket connection established, initiating session, client: /195.169.33.201:60280, server: devlife-test-001/195.169.33.201:2181
2020-03-25 19:28:45,392 [myid:devlife-test-001:2181] - INFO  [main-SendThread(devlife-test-001:2181):ClientCnxn$SendThread@1394] - Session establishment complete on server devlife-test-001/195.169.33.201:2181, sessionid = 0x1000a8569a70001, negotiated timeout = 30000
  
WATCHER::
  
WatchedEvent state:SyncConnected type:None path:null
[zk: devlife-test-001:2181(CONNECTED) 0] ls /
[zookeeper]
[zk: devlife-test-001:2181(CONNECTED) 1]
```



## 마치며

여기까지 Apache Zookeeper가 무엇이며 어떻게 설치하는지에 대해 알아 보았습니다. 내용 중 오류가 있거나 설치하시는데 궁금한 점이 있으시다면 댓글 부탁드리겠습니다.
