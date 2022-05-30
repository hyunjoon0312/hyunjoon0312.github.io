---
title:  "[ANSIBLE #3] ANSIBLE 조건문 사용하기"
excerpt: "Ansible Playbook 작성시에 조건문을 사용하는 방법"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - OSS
tags:
  - Ansible

---

<p>&nbsp;</p>

이번 포스팅에서는 Ansible Playbook을 작성하면서 조건문을 사용하고 테스트하는 방법에 대해서 알아보도록 하겠습니다. Ansible 조건문을 사용하면 변수 또는 이전 작업의 결과 값에 따라서 다른 작업의 실행을 결정할 수 있습니다. 조건문은 Jinja2 테스트 및 필터를 사용합니다.  

Ansible의 개념 및 Ansible playbook 작성 방법 아래은 링크에서 확인하실 수 있습니다  


- [[ANSIBLE #1\] 개념정리! Ansible(앤서블)이란?](https://onestep-log.com/oss/what-is-ansible/)
- [[ANSIBLE #2\] Ansible Playbook 작성하기(+Tip)](https://onestep-log.com/oss/ansible-playbook/)

-----

<p>&nbsp;</p>

# when을 이용하여 Ansible 조건문 사용하기

가장 간단한 Ansible 조건문은 하나의 테스크에 적용되며 when문을 사용합니다. 이때 when 절은 이중 중괄호를 사용하지 않는 Jinja2 표현식을 사용합니다. when이 적용된 테스크 또는 플레이북을 실행하면 모든 대상 호스트에 대해 조건문 테스트를 진행합니다. 그리고 그 조건문 테스트에서 True를 반환하는 호스트에 대해서만 해당 테스크를 실행합니다.  

```yaml
tasks:
  - name: Create Directory
    file:
      path: /data/apps
      state: directory
    when: ansible_selinux.status == "enabled"
```

위 예시에서 ansible_selinux.status 테스트를 진행하여 enabled 되어 있을 때만 /data/apps 라는 디렉터리를 생성 합니다.  



<p>&nbsp;</p>

## ansible_facts를 이용하여 Ansible 조건문 사용하기

ansible_facts란 IP 주소, OS, 파일시스템 상태 등을 나타내는 호스트(장비)의 속성 입니다. 그리고 이러한 속성을 이용해서 어떤 테스크를 실행하거나 건너 뛸 수 있습니다. 예를 들면 OS가 특정 버전인 경우에만 패키지를 설치할 수도 있고 특정 IP 주소를 가진 호스트에만 방화벽 설정을 할 수 있습니다.   

ansible_facts에는 다음과 같은 조건을 사용할 수 있습니다.  

**OS 배포판**  
**– ansible_facts[‘distribution’]**  
**– ansible_facts[‘os_family’]**  
**(아래 값은 예시이며 가능한 모든 값은 아닙니다.)**  

- Alpine
- Altlinux
- Amazon
- Archlinux
- ClearLinux
- Coreos
- CentOS
- Debian
- Fedora
- Gentoo
- Mandriva
- NA
- OpenWrt
- RedHat
- Slackware
- SLES
- SMGL
- SUSE
- Ubuntu
- VMwareESX

**OS 배포판 버전 – ansible_facts[‘distribution_major_version’]**  
**(아래 값은 예시이며 가능한 모든 값은 아닙니다.)**  

- 14
- 16
- 18
- 20

OS 주 버전으로 Ubuntu 20.04의 경우 값은 20이 됩니다.



위에 기입한 ansible_facts 예시 외에 더 많은 예시를 확인하고 싶다면 아래와 같이 플레이 북을 작성하여 debug 테스크로 확인할 수 있습니다.

```yaml
- name: Show facts available on the system
  ansible.builtin.debug:
    var: ansible_facts
```

<p>&nbsp;</p>

## ansible_facts 예시

예시로 시스템을 Shutdown 하고 싶은 OS는 Ubuntu 20.04 버전인 호스트 입니다. 이럴 경우 아래와 같이 두가지 경우로 쓸 수 있습니다. 첫번째는 and 논리 연산자를 이용하여 두 조건을 모두 만족하는 경우에만 Shutdown 할 수 있게 하며, 두번째는 and 논리 연산자를 사용한 것과 같은 효과로 리스트 형식에 있는 모든 조건이 True 일 때만 Shutdown이 실행 되게 합니다.

```yaml
### First Case
tasks:
  - name: Shut down Ubuntu 20.04
    ansible.builtin.command: /sbin/shutdown -t now
    when: ansible_facts['distribution'] == "Ununtu" and ansible_facts[
    'distribution_major_version'] == "20"
### Sencond Case
tasks:
  - name: Shut down Ubuntu 20.04
    ansible.builtin.command: /sbin/shutdown -t now
    when:
      - ansible_facts['distribution'] == "Ubuntu"
      - ansible_facts['distribution_major_version'] == "20"
```

-----

<p>&nbsp;</p>

# 등록한 변수로 조건문 사용하기

아마 Ansible 조건문을 사용하는 가장 많은 경우는 직접 이전의 작업 결과를 특정 변수에 등록한 뒤, 그 변수를 조건으로 다른 작업을 실행시키는 경우일 것 입니다. 이때 사용하는 방법이 작업의 결과를 register 키워드를 사용하여 변수에 등록하는 것입니다. 이렇게 등록된 변수에는 변수를 생성한 작업의 상태와 작업이 생성한 모든 결과가 포함됩니다. **변수는 when 절의 조건문에서 사용할 수 있으며 variable.stdout을 사용해서 등록된 변수의 내용을 이용할 수 있습니다.**

```yaml
---
- name: Test Ansible
  hosts: all
  
  tasks:
  
    - name: Register a variable
      ansible_builtin.shell: cat /data/devlife
      register: devlife_contents
      
    - name: Check variable devlife_contents
      ansible.builtin.shell: echo "Good Devlife"
      when: devlife_contents.stdout.find('Good') != -1
```

  

등록된 변수가 리스트인 경우에는 loop 문을 통해서 변수의 내용을 확인 할 수 있습니다. 또한 등록된 변수가 리스트가 아니지만 리스트로 변환하고 싶은 경우에는 loop 문을 사용하면 됩니다.

```yaml
---
- name: Registe variable loop list
  hosts: all
  
  tasks:
  
    - name: Directory list
      ansible.builtin.command: ls /data
      register: data_dirs
      
    - name: Create app Directory
      ansible.builtin.file:
        path: /data/{{ item }}
        state: directory
      loop: "{{ data_dirs.stdout_lines }}"
        
```

loop 문은 위와 같이 stdout_lines를 사용할 수도 있지만 stdout.split()으로 사용도 가능합니다.  

<p>&nbsp;</p>

## 작업의 성공, 실패, skip에 따른 조건문

앞서 언급했든 Ansible 조건문에서 register를 이용하여 변수를 등록하면 어떤 작업의 결과물 뿐만 아니라 작업의 성공, 실패, Skip 여부도 등록 됩니다. 단, 등록하는 작업이 실패한 경우에도 계속 해서 다음 작업을 진행할 수 있도록 에러를 무시하고 계속 진행하도록 해주는 ignore_errors: true 설정이 추가 되어야 합니다.

```yaml
tasks:
  - name: Register a command result
    ansible.builtin.command: /bin/test.sh
    register: test_result
    ignore_errors: true

  - name: Run only test_result is failed
    ansible.builtin.command: /bin/filed.sh
    when: test_result is failed

  - name: Run only test_result is succeeds
    ansible.builtin.command: /bin/succeeded.sh
    when: result is succeeded

  - name: Run only test_result is skipped
    ansible.builtin.command: /bin/skipped.sh
    when: result is skipped
```

-----

<p>&nbsp;</p>

# Ansible 조건문 테스트 하기

이제 변수를 등록하고 Ansible 조건문을 작성해 보았으니 등록한 변수가 어떤 내용을 포함하여 등록되어 있고 조건문은 내가 의도한 바와 같이 동작하는지 확인을 해볼 필요가 있습니다.   

<p>&nbsp;</p>

## register 변수 내용 확인

```yaml
---
- name: Registe variable loop list
  hosts: all
  
  tasks:
  
    - name: Directory list
      ansible.builtin.command: ls /data
      register: data_dirs
      
    - name: Print data_dirs
      debug:
        msg: "{{ data_dirs.stdout }}"
```

debug 모듈과 msg 파라미터를 이용하여서 등록한 변수에 어떤 내용이 들어있는지 출력해 볼 수 있습니다.  



## 조건문 실행 테스트

```yaml
tasks:
  - name: Register a command result
    ansible.builtin.command: /bin/test.sh
    register: test_result
    ignore_errors: true

  - name: Test test_result is failed
    debug:
      msg: "test_reult is failed"
    when: test_result is failed

  - name: Test test_result is succeeds
    msg: "test_result is succeeded"
    when: result is succeeded

  - name: Test test_result is skipped
    debug:
      msg: "test_result is skipped"
    when: result is skipped
```

실제로 Ansible 조건문이 적용된 플레이 북을 실행하기 전에 알맞은 조건에서 작업이 실행되는지 반드시 확인해볼 필요가 있습니다. 이때 직접 실행시키고자 하는 작업을 테스트로 수행해보는 것은 리스크가 있기 때문에 debug 모듈의 msg를 출력을 통해 조건문이 내가 의도했던 바와 동일하게 동작하는지 확인 해야 합니다.  

<p>&nbsp;</p>

## 마치며

Ansible Playbook을 작성하며 Ansible 조건문을 사용하는 방법과 예시를 알아보았습니다. 그리고 조건문을 작성한 뒤 테스트하는 방법에 대해도 알아보았습니다. 이외에도 Ansible 조건문을 사용하는 방식은 몇 가지가 더 있으나 해당 포스팅에 있는 내용만 알아도 원하는 조건문은 충분히 작성할 수 있지 않을까 싶습니다. 그러나 좀 더 자세히 알고 싶은 분들은 [Ansible Documentaion 조건문](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html#conditionals-based-on-variables) 에서 확인해보시는 것도 좋을 것 같습니다. 
