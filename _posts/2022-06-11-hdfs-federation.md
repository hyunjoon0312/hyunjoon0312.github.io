---
title:  "[HADOOP #4] HDFS ROUTER-BASED FEDERATION"
excerpt: "Apache Hadoop 3버전에서 새롭게 도입된 기능인 HDFS Router Based Federation에 대한 설명"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Hadoop
tags:
  - Router

---

이번 포스팅은 Hadoop의 네번째 시리즈로 Hadoop 3 버전에서 처음으로 생긴 서비스인 HDFS Router Based Federation에 대해서 이야기하려고 합니다.  
Hadoop의 Federation에 대한 필요성은 계속 해서 대두되어 왔고, Hadoop2 버전에서도 ViewFS를 이용하여 Federation을 구현하도록 지원하고 있었습니다. 하지만 ViewFS를 이용하는 방법은 HDFS와 YARN에서는 호환이 잘 되었지만 이외에 Hive나 Impala 등 다른 에코 서비스와는 호환성이 좋지 않아 실제 라이브 프로덕트 환경에서는 거의 쓰이지 않았습니다.  
그에 반해 Router Based Federation(RBF) 방식은 ViewFS를 활용하는 방법보다 훨씬 심플하며 HDFS와 YARN 뿐만 아니라 Hive, Impala 등 다른 에코 서비스를 사용하더라도 호환성에 문제가 없어 이미 몇년 전부터 마이크로소프트나 우버 같은 대형 빅테크 기업에서는 굉장히 잘 활용하고 있는 서비스 입니다.  
본격적으로 RBF에 대해 이야기 하기 앞서 HDFS와 YARN에 대해 궁금하신 분은 아래 링크를 참조 부탁드리겠습니다.  



**[[HADOOP #1\] HDFS란 무엇인가?](https://onestep-log.com/hadoop/hdfs/)**  
**[[HADOOP #2\] YARN이란 무엇인가?](https://onestep-log.com/hadoop/yarn/)**  
**[[HADOOP #3\] Apache Hadoop 설치하기(3버전 기준)](https://onestep-log.com/hadoop/install-hadoop/)**  



## HDFS Router based Federation 소개
HDFS에서 namenode는 파일 및 디렉터리의 정보를 가지고 있는 inode와 파일 블럭의 정보를 가지고 있는 메타 데이터와 datanode로부터 받는 하트비트 수 그리고 클라이언트의 HDFS RPC 요청 수로 발생하는 오버헤드 때문에 클러스터의 규모를 무한히 확장할 수는 없습니다.   
따라서 이를 해결하기 위한 가장 이상적인 솔루션은 대형 클러스터를 더 작은 서브 클러스터(subcluster)로 나눠서 HDFS 연합(Federation)으로 만든 뒤, 클라이언트는 해당 HDFS 연합을 통합적으로 볼 수 있도록 해주는 것 입니다.  
하지만 이때 문제는 여러 개로 나눠져 있는 서브클러스터(e.g 네임스페이스)에 어떤 파일과 어떤 디렉터리가 있는지를 어떻게 관리 하는가와 클라이언트에게는 원하는 파일과 디렉터리가 어떤 서브클러스터에 있는지 어떻게 알려줄 것인가 입니다.  



## 아키텍쳐  
![HDFS Router based federation Architecture](https://drive.google.com/uc?export=view&id=1Zgjppr_v6RDsmTZOba_wQgkvPzWoVNLo)HDFS Router based federation Architecture(출처 : apache hadoop 공식 페이지)



우선 여러 개로 나눠져 있는 서브클러스터를 관리하는 방법은 서브 클러스터, 즉 네임 스페이스의 연합을 관리하는 담당 소프트웨어 계층을 추가하는 것 입니다. 이 소프트웨어 계층을 HDFS Router Based Federation(RBF)에서는 State Store가 담당하고 있으며, State Store를 통해서 클라이언트는 모든 서브 클러스터에 즉각적으로 접근할 수 있고, 서브 클러스터는 자체 블록 풀을 독립적으로 관리할 수 있습니다. 나중에 원한다면 서브 클러스터간에 데이터 리밸런싱(rebalancing)도 가능합니다.  
RBF의 서브 클러스터는 반드시 독립적인 HDFS 클러스터일 필요는 없습니다. ViewFS를 통해 구현된 Federation 클러스터와 독립 클러스터간에도 가능하며, 독립 클러스터만 가지고도 구성할 수 있습니다. 개인적으로는 RBF를 구성하겠다면 독립 클러스터만을 가지고 구성하는 것을 추천드립니다.  
State Store는 클라이언트가 서브 클러스터에 접근할 수 있도록 하기 위해, 서브 클러스터에 대한 블록 액세스를 관리하며 각 서브클러스터의 네임스페이스 상태 정보를 주기적으로 확인하고 유지합니다. 또한 원격 마운트 테이블과 서브 클러스터에 대한 사용률(load/capacity) 정보를 함께 가지고 있습니다.  
State Store는 RBF에 있어 이러한 중요한 역할을 담당하기 때문에 확장 가능하고 고가용성(HA)이며 내결함성(Fault Tolerant)의 특징을 갖을 필요가 있습니다.  
Router는 State Store가 가지고 있는 정보를 바탕으로 Namenode의 인터페이스와 동일하게 클라이언트 요청에 따라 올바른 서브 클러스터로 전달하게 됩니다.



## Router의 역할

Router는 반드시 하나여야하는 것은 아니며 다수의 Router로 RBF를 구성할 수도 있습니다. 각 라우터는 다음과 같은 역할을 하게 됩니다.



**– Federated inferface**  
라우터는 클라이언트 요청을 받고 state store에서 올바른 서브 클러스터에 대한 정보를 확인하여, 해당 서브 클러스터의 active 네임노드에 요청을 전달 합니다. 그리고 해당 서브 클러스터의 active 네임노드에 정상적으로 라우터의 요청이 전달되면, 해당 active 네임노드는 라우터에게 응답을 보내게 됩니다.  
라우터는 성능을 위해서 마운트 테이블 목록과 서브 클러스터 상태 정보를 캐시할 수도 있습니다. 하지만 라우터는 가지고 있는 정보에 변경사항이 없는지 확인하기 위해 주기적으로 state store에 하트비트를 통해 확인을 하며, state store에는 이렇게 보낸 라우터의 하트비트를 통해 라우터의 상태를 확인하고 유지합니다.



**– NameNode heartbeat**  
라우터는 주기적으로 네임노드의 상태를 확인하고 HA 상태와 load/capacity 상태를 state store에 저장합니다. 네임노드 HA의 성능을 위해 라우터는 state store의 HA 상태 정보를 사용하여 active일 가능성이 가장 높은 네임노드에 요청을 전달 합니다.



**- Availability and Fault Tolerance**  
라우터는 stateless한 서비스로 모든 metadata 작업은 각 네임노드에서 이루어집니다. 따라서 한 라우터가 사용할 수 없는 상태가 되더라도, 다른 어떠한 라우터라도 대신할 수 있습니다.



만약 라우터가 state store에 연결할 수 없는 경우, 클라이언트의 요청을 처리할 수 없는 안전 모드 상태가 됩니다. 클라이언트는 안전 모드의 라우터는 standby 네임노드로 취급하고 다른 라우터에게 요청을 시도합니다.



고가용성(HA)과 유연성을 위해 여러 라우터가 동일한 네임노드를 모니터링하고 State Store에 정보를 보낼 수 있습니다. 따라서 State store에서 충돌하는 네임노드의 정보는 쿼럼을 통해 각 라우터에 의해 해결 됩니다.



만약 라우터가 active 네임노드에 연결할 수 없다면, 동일 서브클러스터의 다른 네임노드에게 연결을 시도합니다. 먼저 standby 상태로 알고 있는 네임노드에 연결을 시도하고 그래도 연결이 안될 경우 사용할 수 없는 네임노드에 연결을 시도합니다. 어떠한 네임노드에도 연결할 수 없다면 해당 서브 클러스터는 예외처리 됩니다.



만약 네임노드의 상태정보가 일정 시간 동안 state store에 기록되지 않으면, 해당 네임노드는 제외되고 액세스를 시도하는 라우터가 없는 것으로 기록합니다. 추후 다시 하트비트가 전달되어 네임노드의 상태 정보가 기록되면 라우터는 해당 네임노드를 다시 복원 합니다.



## 인터페이스  
사용자 및 관리자와 상호 작용하기 위해 라우터는 여러 인터페이스를 제공합니다.



**– RPC :** RPC는 클라이언트가 HDFS와 상호 작용하는데 사용하는 가장 일반적인 인터페이스 입니다. ㅎ현재 구현은 MR, Spark, Hive on Tez로 작성된 분석 워크로드를 사용하여 테스트 하였습니다.



**– Admin :** 관리자는 클러스터에서 정보를 쿼리하고 RPC를 통해 마운트 테이블에서 항목을 추가/제거 할 수 있습니다. 이 인터페이스는 federation으로 부터 정보를 얻고 수정하기 위해 command line으로 제공합니다.



**– Web UI :** 라우터는 현재 네임노드 WebUI를 모방하여 federation 상태를 시각화하는 WebUI를 제공합니다. 해당 WebUI에서는 마운트 테이블에 대한 정보, 각 서브 클러스터에 대한 정보 및 라우터 상태를 제공 합니다.



**– WebHDFS :** 라우터는 RPC 외에 HDFS REST 인터페이스를 제공합니다.



**– JMX :** 네임노드를 모방한 JMX를 통해 메트릭스를 제공합니다. 이는 WebUI에서 클러스터 상태를 가져오는데 사용 됩니다.



**– RBF에서 제공 되지 않는 기능**  
– 다른 두 네임서비스 간의 파일/디렉터리 이동  
– 다른 두 네임서비스 간의 파일/디렉터리 복사  



## State Store의 역할
state store는 중요한 두가지 역할을 합니다.  



**– Membership 관리**
라우터는 membership에 포함되어 있는 서브클러스터의 네임노드와 주기적(5초)으로 하트비트를 받으며, 스토리지 용량 및 노드 수와 같은 클러스터 정보와 함께 네임노드 상태를 확인하여 state store에 저장 합니다.  
라우터는 네임노드와 하트비트를 주고 받을 때, 일정 시간(5분)동안 정상적인 하트비트가 네임노드로부터 오지 않으면 해당 네임노드를 membership에서 제거함.



**– Mount Table 저장**
Mount Table은 디렉터리 및 파일과 subcluster 간의 매핑 정보를 저장함.



## 마치며

여기까지 HDFS Router Based Federation에 대해서 알아보았습니다. 제가 여기서 소개해드린 기능 외에도 RBF는 마운트 테이블 레벨에서의 파일/디렉터리 수 제한 및 데이터 사이즈 제한 등의 기능도 있습니다. 아키텍쳐는 비교적 매우 심플한 서비스이지만 실제 다수의 클러스터 운영에 사용시에는 매우 강력한 기능을 제공해주는 서비스로 RBF에 대해 정보를 찾고 계시는 분들에 도움이 되셨으면 좋겠습니다.



참고 : https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs-rbf/HDFSRouterFederation.html