---
title:  "하둡 에코 시스템(HADOOP ECO SYSTEM)이란?"
excerpt: "하둡 에코 시스템(HADOOP ECO SYSTEM)을 이루고 있는 대표적인 서비스들에 대한 설명"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - OSS
tags:
  - Hadoop
---


Hadoop Eco System은 불과 십여 년 전까지만 해도 꽤나 선진 기술에 들어갔으며, 실제로 이를 사용하는 회사도 그리 많지 않았습니다. 그러나 요즘에 와서는 “우리는 데이터 가지고 일한다” 라고 말할 수 있는 수준의 회사들은 대부분 Hadoop 클러스터를 운영하고 있다고 합니다. 실제로 엔씨소프트, 카카오페이, SK텔레콤, 카카오뱅크, 원스토어 등 이름만 들으면 알만한 회사들은 이미 훨씬 오래전부터 Hadoop 클러스터를 운영하고 있습니다. 

이번 포스팅을 시작으로 이러한 Hadoop에 관련된 다양한 다양한 서비스들에 대해서 이야기 해보려고 합니다.
여기에 해당하는 서비스는 HDFS부터 YARN, Hive, Spark, Ranger, Hue 등등 다양한 서비스들이 존재하기 때문에 여러 편의 포스팅에 걸쳐 하나 하나 살펴나갈 예정입니다.  

 

## Hadoop Eco System의 구성

![Hadoop Eco System](https://drive.google.com/uc?export=view&id=1ZMXAgTgbq1h72afc4QLNJkeitMRZaRHQ)

Hadoop Eco System은 대략적으로 위의 그림과 같이 구성되어 있습니다. 제가 모든 서비스들을 표시하지는 않았지만 가장 일반적으로 많이 쓰는 서비스들을 표기하였습니다. 각 서비스 별 자세한 설명은 별도의 포스팅에서 진행하기로 하고 우선은 정말 간략하게 설명하겠습니다.  

- HDFS : Hadoop Distribute File System의 약자로 근본이 되는 시스템 입니다. 클러스터에서 데이터를 저장하는 역할을 하며 저장되는 모든 데이터는 128MB 또는 256MB로 나누어져 블럭이라는 단위로 저장되게 됩니다. 또한 이러한 블럭은 기본적으로 3copy가 되어 각기 다른 3개의 서버에 저장됨으로써 혹시나 한 개 또는 두 개의 서버에 문제가 생기더라도 데이터의 유실을 방지해 줍니다. ( [Apache Hadoop 공식 홈페이지로 이동](https://hadoop.apache.org/) )

- Kudu : 컬럼 기반의 저장소로 특정 컬럼의 데이터만 조회 할 때에 가장 뛰어난 성능을 보여 줍니다. 일반적인 DBMS와 같이 Primary Key를 지원하여 Random Access 성능이 매우 뛰어나다는 특징이 있습니다. Kudu는 Cloudera에서 개발된 프로젝트로 2015년에 Apache 프로젝트로 선정되었습니다. ( [Apache Kudu 공식 홈페이지로 이동](https://kudu.apache.org/) )

-  YARN : Hadoop 클러스터에서 다양한 분산 Application Job를 실행시키기 위한 자원을 관리해주는 Framework 입니다. 위의 그림에서 보이는 MapReduce, Spark, Hive 모두 이 Yarn에서 리소스 관리를 하게 됩니다. ( [Apache Hadoop 공식 홈페이지로 이동 ](https://hadoop.apache.org/))

-  Hive : Hadoop 기반의 데이터 웨어하우스 솔루션으로 분산 저장된 데이터를 마치 DB에서 사용하듯 데이터를 모델링하고 프로세싱할 수 있게 해줍니다. Hive가 개발되기 이전에 HDFS 데이터를 이용하기 위해서는 반드시 MapReduce 프로그래밍을 할 줄 알아야 가능했습니다. 하지만 Hive가 개발되며 프로그래밍을 하지 못하는 기존의 SQL 분석가들도 HDFS 데이터를 이용하여 분석이 가능하게 되었습니다. 실질적으로 Hive에서 SQL과 유사한 HQL로 실행되는 쿼리들은 내부적으로 MapReduce로 변형되어 실행됩니다. [( Apache Hive 공식 홈페이지로 이동 )](https://hive.apache.org/)

-  MapReduce : 대용량 데이터를 처리하기 위한 분산 처리 Framework로 현재에는 느린 속도로 인하여 현업에서의 사용률이 많이 줄었습니다. ( [Apache Hadoop 공식 홈페이지로 이동](https://hadoop.apache.org/) )

-  Spark : 인메모리 방식의 대용량 데이터 처리를 위한 분산 처리 엔진으로 인메모리라는 특징을 가지고 있어 비교적 빠른 처리 속도를 보여줍니다. 또한 Scala, Java, Python 등 다양한 언어로 개발이 가능하며 Spark Shell 등의 인터프리터를 통해 대화형 개발이 가능합니다.[ ( Apache Spark 공식 홈페이지로 이동 )](https://spark.apache.org/)

- Impala : 인메모리 쿼리 엔진으로 Hive Metastore를 이용하여 클러스터상의 데이터를 질의할 수 있게 해줍니다. 뛰어난 성능으로 인해 AD HOC 쿼리 조회에 적합하며 HDFS 뿐만 아니라 Kudu에 저장된 데이터도 Impala를 통해 조회 가능합니다. [( Apache Impala 공식 홈페이지로 이동 )](https://impala.apache.org/) 

-  Zookeeper : 클러스터에서 사용되는 다양한 분산 시스템의 안정적인 운영을 위한 코디네이션 역할을 합니다. 일반적으로 하나의 Leader와 두 개의 Follower가 세트로 구성되며 Leader에게 문제가 생길 경우 두 Follower 중 하나가 Leader가 되어 이어서 역할을 수행합니다. ( Apache Zookeeper 공식 홈페이지로 이동 )

- Hue : Hive, Imapala 등의 Hadoop 클러스터에 사용되는 다양한 서비스를 좀 더 쉽게 사용할 수 있도록 웹 기반 사용자 친화적인 인터페이스를 제공하는 서비스 입니다. [( Apache Hue 공식 홈페이지로 이동 )](https://gethue.com/)

## 마치며

여기까지 간략히 설명 드린 서비스들 외에도 보안 인증 서비스(Ranger), Data Ingestion 서비스(Sqoop / Nifi), 스케쥴링 서비스(Oozie) 등 훨씬 많은 서비스들이 Hadoop 생태계에 존재합니다. 그리고 어떤 데이터를 적재하고 어떻게 활용할지에 따라 필요한 서비스들을 조합하여 유기적인 인프라를 구성하는 것입니다.   

최소 3~4가지 이상의 서비스들을 유기적으로 연동되는 것이 Hadoop 인프라이기 때문에 배우기도 쉽지 않고 배울 것도 너무나 많은 것이 사실입니다. 하지만 Hadoop을 모르고 빅데이터를 다룬다는 것은 거의 불가능한 것이기 때문에 점진적으로 각 서비스들에 알아가면 좋을 것 같습니다.   

오늘은 이렇게 대략적인 Hadoop Eco System의 구성과 이를 구성하는 서비스들의 정의 및 역할에 대해 알아 보았습니다. 앞서 언급했듯이 다음 포스팅부터는 각 서비스에 대해 Deep Dive하도록 하겠습니다. 각기 서비스가 어떻게 구성되며, 가지고 있는 성격과 역할은 무엇인지 그리고 어떻게 설치할 수 있는지, 어떤 옵션들을 가지고 있는지에 대해 알아보도록 하겠습니다.