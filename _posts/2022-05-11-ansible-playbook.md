---
title:  "[ANSIBLE #2] Ansble Playbook 작성하기(+tip)"
excerpt: "Ansible Playbook 작성하는 방법에 대한 설명과 Playbook을 작성할 때 도움이 되는 소소한 팁"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - OSS
tags:
  - Ansible

---

<p>&nbsp;</p>

지난 포스팅의 Ansible이란 무엇인가에 이어서 오늘은 Ansible Playbook 작성하는 방법과 작성하는데 참고 할만한 꿀팁을 알려드리도록 하겠습니다. 지난 포스팅이 궁금하시다면 아래 링크를 참조해 주세요.



[[ASIBLE #1\] 개념정리! Ansible(앤서블)이란?](https://onestep-log.com/oss/what-is-ansible/)

![ansible-logo](https://drive.google.com/uc?export=view&id=1RcCRpM-djzrok3m0e470iAhU7uGL1ocs)

<p>&nbsp;</p>

## Playbook을 작성하기 전 알아야할 Tip

- 최대한 심플(Simple)하게 작성한다.
  – 꼭 필요한 경우에만 고급 기능을 사용하고, 사용하고자 하는 기능에 가장 적합한 기능을 선택한다. 복잡하게 느껴지는 부분이 있다면 더 간단하게 작성할 수 있는 부분이 없는지 확인 한다.
  – 예를 들면, 외부 인벤토리 파일을 사용하면서 동시에 vars, vars_files, vars_prompt, –extra-vars가 모두 필요한지 확인해본다.

- Version 관리를 한다.
  – 플레이북, 인벤토리, 변수 파일을 git과 같은 버전 관리 시스템에 보관하고 변경 시 저장소에 커밋한다.
  – 버전 관리를 통해 플레이 북을 변경한 시기와 이유를 확인할 수 있다.

- 공백을 사용하여 가독성을 향상시킨다.
  – 각 블럭(block)이나 테스크(task) 앞에 공백을 사용하여 구분해주면 플레이 북의 가독성을 향상시킬 수 있다.

- 테스크(task)의 이름을 항상 정의해 준다.
  – 테스크의 이름을 정의해 주는 것은 필수 사항은 아니지만 매우 유용한 옵션이다. 앤서블 플레이북 실행시 출력되는 화면에서 현재 실행되고 있는 테스크 이름을 확인할 수 있다. 
  – 이때 테스크의 이름은 수행하는 작업을 설명할 수 있는 적정할 이름으로 정의한다.

- 모듈(module)의 상태(state) 변수를 설정한다.
  – 모듈의 상태 변수 역시 선택 사항이지만 모듈 마다 기본(Default) 값이 다르기 때문에 명시적으로 설정하여 모듈의 역할을 명확히 해준다.

- 주석을 사용하여 코멘트(comment)를 달아준다.
  – 테스크 이름을 정해주고 모듈의 상태를 설정해 주더라도 테스크나 변수에 대해 추가 설명이 필요한 경우가 있다.
  – 주석(#)을 사용하여 테스크들에 부가 설명을 추가한다면, 다른 사람이나 미래의 내 자신이 플레이 북을 이해하는데 큰 도움이 된다.

<p>&nbsp;</p>

## Playbook 작성하기

Ansible 플레이 북은 **YAML 형식**으로 환경 변수를 선언할 수 있으며, 다수의 장비에 실행시킬 작업 프로세스의 순서를 정의합니다. 그리고 이렇게 작성된 플레이 북은 반복적으로 재사용이 가능하며, 다수의 장비에 정의된 순서로 작업을 수행시킬 수 있는 기능을 제공합니다. [Ansible Playbook Example Github 페이지](https://github.com/ansible/ansible-examples)에서 다양한 예제를 확인 할 수 있습니다.  

**플레이 북은 특정 목표를 갖는 하나 이상의 플레이(play)로 구성**되어 있으며 위에서 아래로 순서대로 실행되며, 테스크 안에서도 위에서 아래로 각 모듈이 실행됩니다. 플레이 북을 여러 플레이로 구성할 경우에는 각 플레이 마다 적용되는 호스트 그룹을 다르게 하여 각각 다른 목표를 갖는 작업을 진행하도록 할 수 있습니다.  

각 **플레이는 최소한 두 가지를 포함**하고 있어야 합니다.  

\1. 작업을 수행할 관리 노드(Managed Node)
\2. 실행할 하나 이상의 테스크

```yaml
---
- name: Update devlife
  hosts: dev
  remote_user: root

  tasks:
  - name: Write config file
    ansible.builtin.template:
      src: /data/httpd.j2
      dest: /data/http/httpd.conf
  - name: vim latest version
    ansible.builtin.yum:
      name: vim
      state: latest

- name: Update blog
  hosts: life
  remote_user: root

  tasks:
  - name: mysql latest version
    ansible.builtin.yum:
      name: mysql
      state: latest
     
...
```

  

위 코드는 플레이 북 예시 입니다. YAML 형식을 갖기 때문에 YAML 파일의 시작을 선언하는 — 으로 시작됩니다. 첫번째 플레이는 Update devlife라는 이름을 가지며 dev 그룹의 장비들을 대상으로 합니다. 이때 관리 장비에 SSH 연결을 하여 플레이에 작성된 테스크를 수행할 유저는 root로 설정합니다.   

여기서 name, hosts, remote_user를 [Playbook Keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords) 라고 하며 이외에 다른 키워드를 플레이 또는 테스크 단위에 추가하여 Ansible이 동작하는 방식에 영향을 줄 수 있습니다. 플레이 북 키워드를 사용하면 root 권한 사용 여부, 오류 처리 방법, 연결 플러그인 사용 등을 설정할 수 있습니다.  



테스크(tasks)는 특정 인수로 모듈을 실행하며, hosts에 해당하는 모든 장비에서 동일한 테스크의 모듈이 실행 됩니다. 테스크에서 각 모듈이 모든 장비에 순환하며 실행되다가 어떤 장비에서 해당 모듈이 실패하면 뒤에 실행해야 할 모듈이 남아있더라도 플레이는 중단 됩니다.  

일부 모듈(Shell 모듈 등)을 제외한 대부분의 모듈은 원하는 최종 상태가 달성 되었는지 확인하고 이미 최종 상태가 달성 되어 있다면 해당 모듈을 수행하지 않고 종료 됩니다. 따라서 테스크를 반복하더라도 최종 상태가 변경되지 않습니다. 이러한 방식으로 동작하는 것을 멱등성(Idempotent) 이라고 부릅니다.  

<p>&nbsp;</p>

## Playbook 확인

플레이 북 작성을 완료하였으면 실행하기 전 문법 상 오류나 기타 이슈가 없는지 확인이 필요합니다. 이때 사용 가능한 다양한 옵션으로는 –check, –diff, –list-hosts, –list-tasks, –syntax-check 등이 있습니다.  

위의 옵션을 사용하는 방법 외에도 ansible-lint 명령어를 사용하면 작성한 플레이 북에 대한 자세한 피드백을 얻을 수 있습니다.  

```bash
$ ansible-lint devlife-blog.yml
[403] Package installs should not use latest
devlife-blog.yml:7
Task/Handler: ensure apache is at the latest version
```

<p>&nbsp;</p>

## Playbook 실행하기

```bash
$ ansible-playbook -i <Inventory File> my_playbook.yml --verbose
```

플레이 북은 ansible-playbook 명령어를 통해 실행 됩니다. -i 플래그에는 관리 대상 장비 리스트인 인벤토리 파일의 경로와 이름을 지정해주고 뒤에는 실행할 플레이 북의 경로와 이름을 지정해 줍니다. 마지막에는 –verbose 플래그(flag)를 붙여 성공한 모듈과 실패한 모듈의 상세 내용을 확인 합니다.  

<p>&nbsp;</p>

## 마치며

이렇게 Ansible Playbook에 대한 작성 요령과 작성 방법, 실행 방법까지 알아 보았습니다. 여기서 언급한 내용 외에도 Ansible을 사용하는데 정말 유용한 정보를 [Ansible 공식 문서](https://docs.ansible.com/ansible/latest/user_guide/index.html#writing-tasks-plays-and-playbooks)에서 다양하게 제공하고 있습니다. Ansible에 대해 제대로 알아보고 싶으시다면 공식 문서의 링크를 따라가면서 쭉 살펴보시길 추천 드리겠습니다.  
