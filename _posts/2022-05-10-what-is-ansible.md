---
title:  "[ANSIBLE #1] 개념정리! Ansible(앤서블)이란?"
excerpt: "프로비저닝 도구인 Ansible에 대한 개념 설명"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - OSS
tags:
  - Ansible

---
<p>&nbsp;</p>

오늘은 Provisioning(프로비저닝)과 소프트웨어 배포 도구로 유명한 Ansible(앤서블)에 대해서 이야기 해보려 합니다. 오늘 포스팅에서는 Ansible(앤서블)이 무엇인지에 대한 개념과 관련된 용어 및 구조에 대해서 살펴보도록 하겠습니다.   


<p>&nbsp;</p>

# 프로비저닝이란?

앞서 앤서블이 프로비저닝 도구라고 하였습니다. 그렇다면 프로비저닝은 무엇인지 간단하게 짚고 넘어가겠습니다. 프로비저닝은 Provision(공급)에서 나온 말로 -ing 가 붙어서 ” 공급하는 것” 이라는 단어가 되었습니다. 즉, **사용하는 사람이 원하는 조건이나 요구에 맞게 인프라나 소프트웨어 등의 자원, 서비스 등을 제공해주는 것**을 프로비저닝 이라고 합니다.  



![ansible-logo](https://drive.google.com/uc?export=view&id=1RcCRpM-djzrok3m0e470iAhU7uGL1ocs)

<p>&nbsp;</p>

# Ansible이란?

앤서블은 python으로 개발된 오픈 소스 프로그램으로 **다수의 장비를 대상으로 프로비저닝, 구성 관리, 소프트웨어 배포** 등을 가능하게 해주는 도구 입니다. 앤서블이 세상에 나오기 전에도 Ruby로 개발된 Puppet이나 Chef와 같은 유명한 프로비저닝 도구가 있었습니다. 하지만 Master-Agent 구조를 가지고 있으며 배우기 어렵고 복잡하다는 단점으로 인해 앤서블이 세상에 나온 뒤에는 그 입지가 매우 좁아졌습니다.  

이렇게 앤서블이 인기를 얻게된 앤서블의 특징으로는 다음과 같습니다.  

- Agentless  
  – Master-Agent 구조를 가지는 Puppet이나 Chef과는 다르게 관리하는 장비에 Daemon을 설치할 필요가 없습니다.   
  – 패스워드 없이 접근을 위한 SSH-KEY가 배포되어 있고 Python이 설치되어 있는 장비라면 바로 앤서블의 명령을 실행할 수 있습니다.  

- 배우고 이해하기 쉬움  
  – Playbook이라는 YAML 형식의 파일과 모듈 기반의 작업을 수행하기 때문에 배우기 쉽고, 작성자가 아니더라도 어떤 작업을 수행하는 것인지 이해하기 쉽습니다.  

- 멱등성(Idempotence)
  – 동일한 명령어를 반복적으로 수행하더라도 한번 명령어가 실행되었을 때와 동일한 결과를 보장합니다.

- AD-HOC 명령어 사용 가능  
  – Playbook을 통해 명령어를 작성하지 않더라도 일회성의 AD-HOC 명령어를 사용할 수 있도록 지원합니다.

<p>&nbsp;</p>

# Ansible 사용에 필요한 개념

앤서블에는 Control Node, Managed Node, Inventory, Module, Task, Playbook 등 앤서블을 사용하는데 필수적으로 알아야 할 개념들이 있습니다. 각 개념을 이해하고 있어야 앤서블을 제대로 사용할 수 있기 때문에 각 개념에 대해 알아보도록 하겠습니다.  

## Control Node

Control Node는 앤서블이 실제로 설치되는 장비 입니다. 말 그대로 조작을 수행하는 장비를 이야기합니다. Control Node에서는 수행해야할 명령어를 작성한 문서인 playbook을 이용하여, 각 관리 장비에 원하는 작업을 수행할 수 있습니다.    Ansible은 Python 기반의 프로그램이기 때문에 Control Node에서 앤서블을 실행시키려면 반드시 Python이 설치되어 있어야 합니다. 그러나 높은 성능을 요구하지 않기 때문에 노트북, 데스크탑, 서버 등 어떤 장비로도 구성할 수 있으나 OS의 경우에는 반드시 Mac OS, Ubuntu, CentOS 등 Unix 계열의 OS를 사용해야 합니다. Windows OS로는 Control Node를 구성할 수 없습니다. 또한 원한다면 Control Node는 여러 대로 구성할 수도 있습니다.  



## Managed Nodes

앤서블로 관리되는 모든 장비를 Managed Nodes라고 생각하면 됩니다. Managed Nodes를 때때로 Hosts라고 부르는 경우도 있으며 Managed Nodes에 앤서블이 설치될 필요는 없습니다. 단, 앤서블이 수행되기 위한 Python은 반드시 설치되어 있어야 합니다.  



## Inventory

앤서블로 관리되는 모든 장비들의 리스트를 Inventory라고 합니다. Managed Nodes를 Hosts로 부르기도 하듯이 Inventory도 Hostfile이라고 부르기도 합니다. Inventory에는 관리하는 장비에 대한 IP 주소와 Hostname 같은 정보가 있습니다. Inventory는 관리 장비들에 대한 그룹을 만들어 좀 더 쉽게 관리할 수 있도록 할 수도 있으며, 그룹 간에는 중복되는 관리 장비들이 있어도 무관합니다.  



Inventory에 대해 좀 더 자세히 알고 싶다면 [다음 페이지](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#intro-inventory)를 참고하시면 됩니다.  



## Modules

Module은 앤서블에서 실행할 수 있는 명령어 코드의 단위 입니다. 각 모듈은 file에 대한 조작, 네트워크에 대한 조작, 데이터베이스에 대한 조작 등 각각 특정 용도를 가지고 있습니다. 우리는 앤서블에서 이 모듈들을 이용하여 장비에 원하는 작업들을 수행할 수 있습니다. 수백개의 모듈이 존재하고 시시각각 새로운 모듈이 생기기도 하기 때문에 자주 사용하는 모듈을 제외하면 필요에 따라 어떤 모듈이 있는지 검색하여 사용하는 것이 현명합니다. 현재 앤서블의 모든 모듈 리스트는 [여기서](https://docs.ansible.com/ansible/latest/collections/index_module.html) 확인이 가능합니다.  



## Tasks

앤서블에서 명령어를 실행하는 작업의 단위 입니다. AD HOC 명령으로 단일 테스크를 실행할 수 있으며 Playbook을 통해 한개 이상의 테스크를 실행시키는 것도 가능합니다.  



## Playbooks

앤서블에서 관리 장비에 실행시키고자 하는 명령어를 순차적으로 작성해 놓은 파일 입니다. 동일한 작업이 필요할 때 마다 재활용하여 사용할 수 있습니다. 플레이북에는 작업에 대한 명령어 뿐만 아니라 원하는 변수를 포함시킬 수도 있으며 각 명령이 수행되는 조건을 추가하는 것도 가능합니다. 플레이북의 파일 형식은 YAML 형식으로 작성되며 작성 편의성과 가독성이 좋고 구조화되어 있는 형식이기 때문에 누가 봐도 코드를 이해하기 쉽습니다. 플레이북에 대한 자세한 내용은 다음 [페이지를 참조](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#about-playbooks)하면 됩니다.  

<p>&nbsp;</p>

# 마치며

이번 포스팅에서는 Ansible이 무엇이고 어떤 개념을 가지고 있는지에 대해 알아보았습니다. 다음 포스팅에서는 이번 내용에 이어서 앤서블의 핵심인 Playbook을 어떻게 작성하고 변수는 어떻게 할당하며, 조건문은 어떻게 걸 수 있는지에 대해 알아보도록 하겠습니다. 