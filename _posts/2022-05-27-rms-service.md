---
title:  "Apache Ranger Hive 권한 정책과 HDFS 권한 정책 연동을 위한 RMS 서비스"
excerpt: "Apache Ranger Hive 권한 정책과 HDFS 권한 정책 연동을 위한 RMS(Ranger Resource Mapping Service)"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Hadoop
tags:
  - Ranger
---



Hadoop 인프라를 관리하면서 권한 인증은 Apache Ranger를 통해서 서비스하고 있습니다. 이전에는 Sentry를 통해서 서비스를 할 때도 있었으나 자질구래한 버그들과 Group Base의 권한 관리만 가능한 단점이 있고 audit log 관리 등 종합적으로 Ranger가 더 많은 장점을 가지고 있다고 판단하여 최종적으로 지금의 Ranger를 택하게 되었습니다.  
그러나 Ranger도 더 장점이 많은 것이지 완벽하지는 않습니다. 그 중에 가장 불편한 점이 하나 있습니다.:sweat:  

바로 Hive 권한 정책을 설정해주더라도 HDFS 권한과는 동기화가 되지 않는다는 것 입니다. Sentry에서는 이 부분이 자동으로 되었는데 말이죠... 이 동기화 부분이 되지 않기 때문에 Hive와 HDFS 모두에 대해 서로 대응하는 별도의 권한 정책을 만들고 유지 관리해 주어야 합니다. 결과적으로 관리자는 매번 Hive 권한이 변경 될 때마다 HDFS에도 동일하게 권한을 변경해 주어야하기 때문에 불필요한 Human Resource를 소비하게 됩니다.

그렇다면 여기서 궁금증이 하나 생기실 수도 있습니다. Hive 권한 정책과 HDFS 권한 정책을 왜 동기화시켜 주어야 하나?
그것은 바로 Spark와 같은 비 Hive 워크로드에서 Hive 테이블 데이터를 사용하기 위해서는 Hive 권한과 동일하게 HDFS 파일 레벨의 권한을 가지고 있어야 정상적으로 데이터에 접근하고 작업을 할 수 있기 때문입니다.  
즉 Spark와 같은 서비스를 사용하지 않고 Hive만 쓴다면 굳이 Hive와 HDFS의 권한 정책을 동기화 시킬 필요는 없습니다.

그래서 이러한 불편을 해소하기 위해 여러가지 고민을 하고 있는데, 그 와중에 Cloudera에서 Ranger Resource Mapping Service(RMS)라는 서비스를 개발하여 우선 이 RMS에 대해 알아보려고 합니다. 딱 제가 원하던 역할을 해주는 서비스이기 때문에 RMS를 들여다 보고 참고 삼아 유사한 서비스를 개발해볼 예정입니다. :smile_cat: 

## Ranger Resource Mapping Service(RMS) 란?

Ranger Resource Mapping Service(RMS)는 Ranger를 통해서 Hive에 어떠한 데이터베이스나 테이블에 권한 정책을 적용하면 이에 대응하는 HDFS 파일에 유사한 권한을 적용해주는 서비스 입니다. 즉 Hive 테이블에 대한 액세스 권한이 있는 모든 사용자는 테이블의 데이터 파일에 대해 유사한 HDFS 파일 액세스 권한을 자동으로 부여받게 됩니다. 이로 인해 관리자가 Hive의 권한이 변경 될 때마다 HDFS의 권한을 함께 변경해줄 필요 없이 Hive와 대응되는 권한이 HDFS에 자동으로 적용되어 관리자의 운영 부담을 줄여주게 됩니다. 또한 RMS를 통해 설정된 모든 권한 변경은 Ranger의 Audit log에 모두 표시되게 됩니다.
  



## RMS는 어떻게 동작을 하는가?

RMS는 내부적으로 Hive 정책을 HDFS 액세스 규칙으로 변환하고 HDFS Namenode 가 이를 따르도록 합니다. Ranger에서 HDFS 권한 정책을 생성하는 것 같지만, RMS는 Ranger에서 명시적인 HDFS 정책을 생성하지 않으며 사용자에게 보이는 HDFS ACL을 변경하지도 않습니다. 대신 Ranger HDFS Plugin이 Hadoop SQL 권한을 기반으로 실행되는 동안 Hive와 동일한 권한 결정을 내릴 수 있도록하는 맵핑을 생성합니다.

![RMS interaction](https://drive.google.com/uc?export=view&id=1pxUeDLfhtsuvXlos89iKeMYeKx8FjWk2)  
    *RMS 상호작용(출처:https://blog.cloudera.com/an-introduction-to-ranger-rms/)*


RMS는 서비스가 시작될 때 마다 Hive Metastore(HMS)에 연결하고 Hive 리소스를 HDFS의 스토리지 위치에 연결하는 리소스 맵핑 파일을 생성하는 동기화 작업을 수행 합니다. 이렇게 생성된 맵핑 파일은 RMS 내의 저장소 캐시에 로컬로 저장됩니다. 또한 Ranger 서비스에서 사용하는 백엔드 데이터베이스의 특정 RMS 테이블에도 유지됩니다. 시작 후 RMS는 이 동기화 작업을 30초에 한번씩 진행하게 됩니다.

이때 RMS 프로세스는 HMS를 쿼리하여 HDFS의 기본 파일 경로에 맵핑할 데이터베이스의 이름 및 테이블의 이름과 같은 Hive 메타데이터를 수집합니다. 

HDFS 측면에서는 Namenode에서 실행되는 Ranger HDFS Plugin에 HivePolicyEnforcer라는 새로운 모듈 추가되었습니다. 이로 인해 Ranger HDFS Plugin은 Ranger Admin에서 HDFS 권한 정책을 다운로드하는 것 외에도 RMS의 맵핑 파일과 함께 Ranger Admin에서 Hive 정책을 다운로드 합니다. 즉 기존에 Ranger HDFS 정책에 의해서만 결정되던 HDFS 액세스 권한은 RMS에 의해 HDFS 권한 정책과 Hive 권한 정책 모두에 의해 결정 됩니다.

그러나 한가지 주의할 점은 RMS가 적용되어 Hive 권한 정책에 따라 HDFS 권한이 자동으로 적용되더라도 Ranger Admin에서 수동으로 생성한 HDFS 권한 정책이 RMS를 통해 적용된 권한 정책보다 우선 순위를 갖게 됩니다.


## 마치며

Cloudera에서 개발한 Ranger Hive와 HDFS 권한 정책 동기화 서비스인 RMS에 대해 간략히 알아보았습니다.   
사실 더 자세히 알아보고 싶었지만... Cloudera에서 오픈소스로 코드를 공개해주지 않았고 아직은 나온지 얼마 되지 않은 서비스라 한정적인 정보로 인해 어려움이 있었습니다 :cry:  
하지만 RMS가 어떻게 Ranger, Hive Metastore, HDFS와 상호작용을 하는지 보고 유사한 기능을 하도록 개발하는데 있어 큰 참고가 될 수 있을 것 같습니다!  
RMS만큼의 완성도를 갖을 수 있을지는 미지수이지만! 추후 해당 개발이 완료되면 저는 어떤 방식으로 이 문제를 풀어내었는지 공유드릴 수 있도록 하겠습니다.
