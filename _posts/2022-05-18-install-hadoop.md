---
title:  "[HADOOP #3] APACHE HADOOP3 설치하기"
excerpt: "Apache Hadoop3를 기준으로 Hadoop 구성 방법"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - hadoop
tags:
  - Hadoop

---

이번 포스팅에서는 세번째 시리즈로 실제로 Apache Hadoop을 설치하고 구성하는 방법에 대해 알아보도록 하겠습니다. 설치할 버전은 3.2.2 버전으로 3.3.1버전이 릴리즈 되어 있기는 하지만 현재까지는 가장 안정적인 버전으로 판단하여 3.2.2 버전을 기준으로 진행하겠습니다.



HDFS와 YARN에 대한 개념적 내용이 궁금하신 분은 아래 링크를 참조 부탁 드리겠습니다.



[1. HDFS란 무엇인가?](https://onestep-log.com/hadoop/hdfs/)  

[2. YARN이란 무엇인가?](https://onestep-log.com/hadoop/yarn/)



## 설치 전 참고 사항

이번 포스팅의 OS 기준은 **Ubuntu를 기준**으로 작성하였습니다. Ununtu나 CentOS나 패키지 설치를 제외하고는 거의 비슷하니 CentOS를 사용하시는 분들도 어려움은 없으실 것이라 판단됩니다. 그리고 하둡 클러스터를 설치 전에 정말 중요한 부분이 **Apache Zookeeper가 먼저 선행되어 설치가 되어 있어야 한다는 것**입니다. ” HDFS란 무엇인가? ” 포스팅에서 얘기하였듯 하둡 클러스터의 Namenode가 HA(High Availability) 구성이 되기 위해서는 Zookeeper가 필수 이기 때문입니다. 따라서 우선 Zookeeper가 설치되어 있다는 가정하에 하둡 설치 방법에 대해 이야기하도록 하겠습니다. Zookeeper에 대한 개념과 설치 방법은 바로 다음 포스팅에 준비할 예정이니 작성되는데로 링크를 추가하도록 하겠습니다.



## 사전 작업

하둡 Java로 짜여진 프로그램으로, Java Virtual Machine으로 실행되기 때문에 반드시 먼저 JDK가 설치되어 있어야 합니다. 현재 Oracle Java는 유료화 되었기 때문에 OpenJDK를 사용하여 설치해줍니다. 버전으로는 OpenJDK 1.8.0_252 이상 버전을 추천드리며 1.8.0의 최신 버전을 설치하셔도 관계 없습니다. 간혹 JDK 버전 호환성 문제로 Namenode나 Datanode 데몬이 실행이 되지 않는 경우가 있는데 이럴 때는 다른 버전의 OpenJDK를 설치해보시길 추천 드립니다. 참고로 포스팅 하는 시점의 OpenJDK1.8.0 가장 최신 버전은 OpenJDK 1.8.0_292 버전 입니다. 사전 작업은 **클러스터로 구성할 모든 장비에 진행**을 해줘야 합니다.



## OpenJDK 1.8.0 설치

```bash
apt update
apt install -y openjdk-8-jdk

java -version
openjdk version "1.8.0_292"
OpenJDK Runtime Environment (build 1.8.0_292-8u292-b10-0ubuntu1~18.04-b10)
OpenJDK 64-Bit Server VM (build 25.292-b10, mixed mode)

javac -version
javac 1.8.0_292
```

다음과 같이 apt를 이용하여 openjdk 1.8.0 최신 버전을 설치해주고 설치가 완료되면 java -version 명령어와 javac -version 명령어를 통해 java가 정상적으로 설치되었는지 확인해 줍니다. 저와 유사하게 나왔다면 정상적으로 java가 설치된 것 입니다.



## hdfs 서비스 계정 생성

```bash
addgroup --gid 2001 hdfs
useradd --create-home --shell /bin/bash --uid 2001 --gid 2001 hdfs
chage -E -1 -M 99999 hdfs
echo 'hdfs:hdfs' | sudo chpasswd
```

Namenode 및 Datanode 등 HDFS와 관련된 서비스를 실행할 hdfs 서비스 계정을 생성해줍니다. hdfs user와 hdfs group, 그리고 계정의 패스워드가 만료되지 않도록 chage 명령어를 통해 설정해 줍니다. 마지막으로 hdfs 계정의 패스워드를 생성해주면 됩니다.



## yarn 서비스 계정 생성

```bash
addgroup --gid 2002 yarn
useradd --create-home --shell /bin/bash --uid 2002 --gid 2002 yarn
chage -E -1 -M 99999 yarn
echo 'yarn:yarn' | sudo chpasswd
```

역시 동일하게 Resourcemanager 및 Nodemanager 등 YARN에 관련된 yarn 서비스 계정을 생성해 줍니다.



## Master Node의 Data Directory 생성

```bash
mkdir -p /data/hdfs/namenode
mkdir -p /data/hdfs/jornalnode
chown -R hdfs:hdfs /data/hdfs
mkdir -p /data/yarn
chown -R yarn:yarn /data/hdfs
```

Master Node로 사용할 장비에 다음과 같이 Namenode가 사용할 데이터 디렉터리, Journalnode가 사용할 데이터 디렉터리를 생성해주고 디렉터리들의 owership은 hdfs:hdfs로 설정해 줍니다. 그리고 Resourcemanager가 사용할 데이터 디렉터리도 생성해주고 역시 ownership은 yarn:yarn으로 설정해줍니다. 



## Worker Node의 Data Directory 생성

```bash
mkdir -p /data/hdfs/datanode
chown -R hdfs:hdfs /data/hdfs
mkdir -p /data/yarn
chown -R yarn:yarn /data/yarn
```

Worker Node로 사용할 장비에는 Datanode와 Nodemanager가 사용할 데이터 디렉터리를 생성해주고 각각의 ownership은 hdfs:hdfs와 yarn:yarn으로 설정해 줍니다. 그리고 만약 Worker Node에 데이터 디스크가 한개 이상 있다면 모든 디스크에 동일하게 데이터 디렉터리를 생성해줍니다. 일반적으로 하둡 클러스터는 대용량 데이터를 저장하기 때문에 Worker Node는 한 개 이상의 데이터 디스크를 가지고 있습니다.



## Apache Hadoop 설치하기

### 설치파일 다운로드

공식 홈페이지에서 제공하는 [다운로드 페이지](https://hadoop.apache.org/releases.html)에서 Binary 압축 파일을 다운로드 합니다.

![hadoop download](https://drive.google.com/uc?export=view&id=1Z7A_7xwZO64Fgi0wbhrhiASuhSufz85h)



## SSH KEY 배포

대부분 하나의 Namenode에서 HDFS 전체 서비스를 SSH 통신을 통해 제어하므로 모든 노드에게 해당 Namenode의 SSH KEY를 배포해줍니다. 

```bash
ssh-keygen
ssh-copy-id {hostname}
```

### 압축 해제 및 필요 디렉터리 생성

다운 받은 Binary 압축 파일의 압축을 풀어주고 서비스에 필요한 pids 디렉터리 및 logs 디렉터리 등을 생성해 줍니다.

```bash
tar xvfz hadoop-3.2.2.tar.gz -C /opt
mkdir /opt/hadoop-3.2.2/pids
mkdir /opt/hadoop-3.2.2/logs
chown -R hdfs:hdfs /opt/hadoop-3.2.2
chmod 757 /opt/hadoop-3.2.2/pids
chmod 757 /opt/hadoop-3.2.2/logs
```

### hdfs 및 yarn 계정 환경 변수 설정

hdfs와 yarn 계정으로 절대 경로로 실행시키지 않고 어디서든 편하게 hdfs 및 yarn 관련 명령어를 실행시키기 위해 환경 변수를 등록해 줍니다.

```bash
$ vi ~/.bashrc

export HADOOP_HOME=/opt/hadoop-3.2.2
export HDFS_NAMENODE_USER="hdfs"
export HDFS_DATANODE_USER="hdfs"
export YARN_RESOURCEMANAGER_USER="yarn"
export YARN_NODEMANAGER_USER="yarn"

export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

### 환경 변수 설정

HDFS와 YARN에 관련된 모든 환경 설정 파일들은 ~/hadoop-3.2.2/etc/hadoop 디렉터리에 위치해 있습니다. 

```markup
### hadoop-env.sh

export HADOOP_HOME=/opt/hadoop-3.2.2
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_LOG_DIR=${HADOOP_HOME}/logs
export HADOOP_PID_DIR=${HADOOP_HOME}/pids
export HDFS_NAMENODE_USER="hdfs"
export HDFS_DATANODE_USER="hdfs"
export YARN_RESOURCEMANAGER_USER="yarn"
export YARN_NODEMANAGER_USER="yarn"
### core-site.xml

<configuration>
 
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://devlife-cluster</value>
    <description>NameNode URI</description>
  </property>
   
  <property>
    <name>io.file.buffer.size</name>
    <value>131072</value>
    <description>Buffer size</description>
  </property>


  <!-- HA Configuration -->
   
  <property>
    <name>ha.zookeeper.quorum</name>
    <value>zookeeper-001:2181,zookeeper-002:2181,zookeeper-003:2181</value>
  </property>
   
  <property>
    <name>dfs.ha.fencing.methods</name>
    <value>sshfence</value>
  </property>
   
  <property>
    <name>dfs.ha.fencing.ssh.private-key-files</name>
    <value>/home/hdfs/.ssh/id_rsa</value>
  </property>
### hdfs-site.xml

<configuration>
     
   
  <property name="dfs.replication" value="3" />

  <property name="dfs.permissions" value="false" />

  <property name="dfs.namenode.name.dir" value="file:///data//hdfs/namenode />

  <property name="dfs.datanode.data.dir" value="file:///data1/hdfs/datanode, file:///data2/hdfs/datanode, file:///data3/hdfs/datanode" />

  <property name="dfs.datanode.use.datanode.hostname" value="false" />

  <property name="dfs.namenode.datanode.registration.ip-hostname-check" value="false" />

  <property name="dfs.webhdfs.enabled" value="true" />
  
  <property name="dfs.permissions.superusergroup" value="supergroup" />

  <property name="dfs.namenode.acls.enabled" value="true" />


  <!-- HA Configuration -->
   

  <property name="dfs.journalnode.edits.dir" value="/data/hdfs/journalnode" />
  
  <property name="dfs.nameservices" value="devlife-cluster" />

  <property name="dfs.ha.namenodes.camp1" value="namenode1,namenode2" />

  <property name="dfs.namenode.rpc-address.devlife-cluster.namenode1" value="namenode-001:9820" />

  <property name="dfs.namenode.rpc-address.devlife-cluster.namenode2" value="namenode-002:9820" />
  
  <property name="dfs.namenode.http-address.devlife-cluster.namenode1" value="namenode-001:9870" />

  <property name="dfs.namenode.http-address.devlife-cluster.namenode2" value="namenode-002:9870" />

  <property name="dfs.namenode.shared.edits.dir" value="qjournal://namenode-001:8485;namenode-002:8485;namenode-003:8485/devlife-cluster" />

  <property name="dfs.client.failover.proxy.provider.devlife-cluster" value="org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider" />
  
  <property name="dfs.ha.automatic-failover.enabled" value="true" />

  <property name="dfs.journalnode.http-address" value="0.0.0.0:8480" />

  <property name="dfs.journalnode.https-address" value="0.0.0.0:8481" />

  <property name="dfs.journalnode.rpc-address" value="0.0.0.0:8485" />
### worker

datanode-001
datanode-002
datanode-003
datanode-004
datanode-005
```

### Zookeeper Failover Controller 포맷

```bash
hdfs zkfc -formatZK
```

## Journalnode 실행 및 Namenode 포맷

```bash
hdfs --daemon start journalnode
hdfs namenode -format
hdfs namenode -initializeSharedEdits
```

### Active Namenode 실행 및 ZKFC 실행

```bash
hdfs --daemon start namenode
hdfs --daemon start zkfc 
```

### 전체 Datanode 실행

```bash
hdfs --daemon start datanode
```

### Standby Namenode 실행

```bash
hdfs namenode -bootstrapStandby
hdfs --daemon start namenode
hdfs start zkfc
```

### YARN 실행

```bash
start-yarn.sh
```

### 설치 및 실행 확인

```bash
jps
26023 DFSZKFailoverController
25817 JournalNode
25642 NameNode
46844 Jps
26532 ResourceManager
```

이렇게 Java Process가 떠있는 것을 확인하는 것 외에도 Namenode WebUI에서도 확인할 수 있습니다. Namenode WebUI의 주소는 http://namenode-001:9870 으로 접근할 수 있습니다.



## 마치며

이렇게 이번 포스팅에서는 Apache Hadoop을 설치하는 방법에 대해서 알아보았습니다. 환경 설정 파일이 길어서 복잡해 보이실 수 있지만 차분히 보시면 그리 복잡하지 않아 모두 구성하실 수 있으실 것으로 생각됩니다. 혹시 제가 작성한 문서에 오타나 오류가 있다면 언제든 댓글로 제보 부탁드리겠습니다.