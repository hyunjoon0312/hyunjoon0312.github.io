---
title:  "[ANSIBLE #4] Ansible Role 제대로 사용하기"
excerpt: "Ansible Playbook에서 Role에 대해 이해하고 Role을 사용하는 방법"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - OSS
tags:
  - Ansible

---

<p>&nbsp;</p>


Ansible 시리즈의 네번째 포스팅으로 Ansible Role에 대해서 알아보려고 합니다. 우리는 지난 포스팅에서 Ansible이 무엇인지 알아보고 playbook은 어떻게 작성하며, 조건문은 어떤 방식으로 사용해야 하는지 알았습니다. 그리고 그렇게 작성된 playbook으로 수 많은 장비를 관리할 수도 있게 되었습니다. 그러나 시간이 지날 수록 점차 수 많은 playbook이 작성될 것이며, 우리는 playbook을 작성할 때 마다 동일한 task를 쓰고 또 쓰고, 그리고 또 쓰는 반복적인 작업을 하게 될 것입니다.   

바로 이때 등장하는 것이 Role 입니다. Ansible Role을 사용하게 되면 표준화 된 디렉터리 구조를 기반으로 하여 관련된 변수(vars), 파일(files), 테스크(tasks), 핸들러(handlers) 등을 패키징(packaging) 할 수 있습니다. 그리고 이렇게 패키징된 Role을 통해서 반복적인 테스크를 작성하지 않고도 테스크의 재사용이 가능해 집니다.  

- [[ANSIBLE #1\] 개념정리! Ansible(앤서블)이란?](https://onestep-log.com/what-is-ansible/)
- [[ANSIBLE #2\] Ansible Playbook 작성하기(+Tip)](https://onestep-log.com/ansible-playbook/)
- [[ANSIBLE #3\] Ansible 조건문 사용하기](https://onestep-log.com/ansible-condition/)

-----

<p>&nbsp;</p>

# Ansible Role의 디렉터리 구조

앞서 Ansible Role은 표준화 된 디렉터리 구조를 기반으로 패키징을 한다고 하였습니다. 이 표준화 된 디렉터리 구조는 8개의 디렉터리로 이루어져 있으며, 각 role은 최소 하나 이상의 디렉터리로 구성되어야 합니다. 즉, 반드시 8개의 디렉터리가 있어야하는 것은 아니며, 사용하지 않는 디렉터리는 생성하지 않아도 됩니다.

```bash
# Role Tree
/roles
  README.md
  /defaults
    main.yml
  /files
    main.yml
  /handlers
    main.yml
  /meta
    main.yml
  /tasks
    main.yml
  /templates
    main.yml
  /tests
    inventory
    test.yml
  /vars
    main.yml
```
  
Ansible Role 트리 구조에서 각 디렉터리 내부에 있는 main.yml 파일은 포함된 디렉터리와 관련된 내용을 갖습니다.  

- defaults/main.yml – role의 [기본 변수](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#playbooks-variables)로, 사용 가능한 모든 변수 중 가장 낮은 우선 순위를 가지며 인벤토리 변수를 비롯한 다른 변수로 쉽게 변경될 수 있습니다.
- files/main.yml – role을 통해 배포되는 파일
- handler/main.yml – role에서 사용할 수 있는 핸들러
- meta/main.yml – role의 종속성을 포함한 role에 대한 metadata
- tasks/main.yml – role이 실행하는 테스크의 목록
- templates/main.yml – role이 배포하는 template
- vars/main.yml – role에 대한 [다른 변수](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#playbooks-variables)

-----

<p>&nbsp;</p>

# tasks 디렉터리 YAML 파일 예제

```yaml
### tasks/main.yml example
- name: Install Web Server for RedHat OS
  import_task: redhat_os.yml
  when: ansible_facts['os_family']|lower == 'redhat'
  
- name: Install Web Server for Ubuntu OS
  import_task: ubuntu_os.yml
  when: ansible_facts['os_family']|lower == 'ubuntu'
  
### tasks/redhat_os.yml example
- name: Install Web Server
  ansible.builtin.yum:
    name: 'httpd'
    state: present
    
### tasks/ubuntu_os.yml example
- name: Install Web Server
  ansible.builtin.apt:
  name: 'apache2'
  state: present
  
...
```
  
위의 예시는 Ansible role의 디렉터리들 중 tasks 디렉터리의 예시입니다.  
첫번째에 있는 main.yml 파일의 테스크는 Web Server를 설치하는 것으로 when 조건문을 사용하여 OS 종류에 따라 알맞은 테스크를 실행시키게 됩니다.   
그리고 두번째, 세번째 테스크는 각각 redhat과 ubuntu의 Web Server를 설치하는 테스크로 main.yml에서 호출되어 사용됩니다.  

-----

<p>&nbsp;</p>

# Ansible Role 사용하기

Ansible Role을 사용하는 방법에는 세가지가 있습니다.
- roles 옵션이 있는 play에서 사용하기 : playbook에서 role을 사용하는 가장 기본적인 방법 입니다.  
- include_role 을 이용하여 테스크에서 사용하기 : include_role을 사용하여 play의 어느 테스크에서나  role을 동적으로 재사용할 수 있습니다.
- import_role을 이용하여 테스크에서 사용하기 : import_role을 사용하여 play의 어느 테스크에서나 role을 정적으로 재사용할 수 있습니다.


## roles 옵션으로 play에서 사용하기

```yaml
---
- hosts: devlife
  roles:
    - write_blog
...
```
  
다음과 같이 play에서 roles 옵션을 사용하여 role을 사용하는 경우 아래와 같이 동작 합니다.

- roles/write_blog/tasks/main.yml 이 존재하는 경우, 해당 파일의 테스크를 play에 추가합니다.
- roles/write_blog/handlers/main.yml이 존재하는 경우, 해당 파일의 핸들러를 play에 추가합니다.
- roles/write_blog/vars/main.yml이 존재하는 경우, 해당 파일의 변수를 play에 추가합니다.
- roles/write_blog/defaults/main.yml이 존재하는 경우, 해당 파일의 변수를 play에 추가합니다.
- roles/write_blog/meta/main.yml이 존재하는 경우, 해당 파일의 모든 role 종속성을 role 목록에 추가합니다.

<p>&nbsp;</p>

외에도 roles/write_blog/~ 경로에 있는 모든 디렉터리의 파일을 상대적 또는 절대적 경로를 지정하지 않고도 참조할 수 있습니다.  

<p>&nbsp;</p>

play에서 roles 옵션을 사용하면 앤서블은 role을 정적으로 처리하며 플레이 북에서 다음과 같은 순서로 실행 됩니다.  


1. play에 정의된 모든 pre_tasks를 실행합니다.
2. pre_tasks에 의해 조건이 된 핸들러를 실행합니다.
3. roles: 에 나열된 순서대로 role이 실행되며, role의 meta/main.yml이 먼저 실행되어 해당 파일에 정의된 [role 종속성](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-dependencies)에 따라 실행됩니다.
4. play에 정의된 테스크가 있다면 해당 테스크가 실행됩니다.
5. roles 또는 테스크에 의해 조건이 된 핸들러를 실행합니다.
6. play에 정의된 post_tasks를 실행합니다.
7. post_tasks에 의해 조건이 된 핸들러를 실행합니다.

<p>&nbsp;</p>


## include_role을 이용하여 테스크에서 사용하기

include_role을 사용하여 play의 어느 테스크에서나 role을 동적으로 재사용할 수 있습니다. 바로 위의 방법처럼 roles를 사용하여 role을 사용했을 경우에는 roles: 에 정의된 role 부터 실행됩니다. 그러나 include_role을 사용했을 경우에는 정의된 테스크의 순서에 따라 실행됩니다. 따라서 include_role의 테스크 전에 다른 테스크가 있는 경우에는 다른 테스크가 먼저 실행 됩니다.

```yaml
---
-hosts: devlife
 tasks:
  - name: Print Hello
    ansible.builtin.debug:
      msg: "Hello"
      
  - name: Include Role 
    include_role:
      name: include_role_example
      
  - name: print Bye
    ansible.builtin.debug:
      msg: "Bye"
```
  
이렇게 play가 작성되어 있을 경우 Hello가 가장 먼저 출력 되고 바로 다음에 include_role_example role이 실행됩니다. 그리고 마지막에 Bye가 출력됩니다.

```yaml
---
- hosts: devlife
  tasks:
    - name: Include devlife role
      include_role:
        name: devlife_role
      vars:
        dir: '/data/blog'
        app_port: 8088
      tags: good_blog
...
```
  
include_role을 사용하여 role을 포함할 때, 변수 및 태그를 포함한 다른 키워드를 전달 할 수 있습니다.  

<p>&nbsp;</p>


## import_role을 이용하여 role 사용하기

import_role을 이용하여 play의 어느 테스크에서나 role을 정적으로 사용할 수 있습니다. 여기서 정적이라는 의미는 roles를 이용하여 role을 사용할 때와 같이 어느 테스크 보다 role이 먼저 실행 된다는 것입니다.

```yaml
---
-hosts: devlife
 tasks:
  - name: Print Hello
    ansible.builtin.debug:
      msg: "Hello"
      
  - name: Import Role 
    import_role:
      name: import_role_example
      
  - name: print Bye
    ansible.builtin.debug:
      msg: "Bye"
...
```
  
include_import와 유사하게 테스크와 테스크 사이에 import_role을 사용하여 role을 사용하였습니다. 그러나 실행 순서는 가장 먼저 import_role_example이 실행되고 Hello, Bye 순으로 실행됩니다.  

-----

<p>&nbsp;</p>

# Playbook에서 Ansible Role의 반복 사용

위와 같이 blog라는 role이 두번 정의 되더라도 blog role은 반복하여 두번 실행되지는 않습니다.

```yaml
---
- hosts: devlife
  roles:
    - { role: blog, message: "Hello" }
    - { role: blog, message: "Bye" }
    
###### Same syntax #####
---
- hosts: devlife
  roles:
    - role: blog
      message: "Hello"
    - role: blog 
      message: "Bye"
...
```
  
그러나 이와 같이 동일한 role이지만 서로 다른 매개변수를 전달하면 두 번 실행되게 됩니다.  


```yaml
---
- hosts: devlife
  roles:
    - role: blog
      message: "Hello"
    - role: blog 
      message: "Bye"
      
### roles/blog/meta/main.yml
---
allow_duplicates: true
...
```
  
만약 서로 다른 매개변수를 주지 않고 blog role을 두번 실행시키고 싶다면, blog role의 meta 디렉터리 main.yml 파일에 allow_duplicates: true 설정을 해주면 됩니다.  

-----

<p>&nbsp;</p>

# 마치며

이렇게 이번 포스팅에서는 Ansible Role에 대해서 알아보았습니다. 코딩에서와 마찬가지로 playbook 작성시에도 role을 활용하여 재사용성을 높일 수 있다면 관리 용이성 및 앞으로 playbook을 작성하시는데 있어서 더욱 편리하게 하실 수 있으실 것이라 생각됩니다. 더 다양한 내용은 [Ansible Documetation](https://docs.ansible.com/)을 참조 부탁드리겠습니다.