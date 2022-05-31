---
title:  "VMWARE Player15 Ubuntu 설치 및 고정 IP 설정(vmnetcfg)"
excerpt: "VMWARE Player를 이용한 ubuntu 설치 방법과 vmnetcfg를 사용하여 고정 IP 설정 방법"
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Linux
tags:
  - Linux

---
<p>&nbsp;</p>

회사에서는 VMware workstation 15 pro 버전을 라이센스가 지급되어 편하게 사용하고 있으나, 학습을 위해 개인적으로 구매하여 사용하기에는 비용적인 부담도 있고 굳이 필요한가 싶은 부분도 있어 VMware workstation 15 player 버전을 사용하고 있습니다. 그런데 이 palyer 버전에서는 아무래도 무료이다 보니 스냅샷이나 이미지 복제 등의 편리한 고급 기능을 제공하지 않고, **무엇보다 가상 이미지에 ssh로 접근하기 위해 필요한 nat 세팅을 위한 네트워크 어댑터 설정 도구를 제공해주지 않는다는 문제점**이 있습니다. 그래서 이번 포스팅에서는 Vmware player와 별도의 vmnetcfg 프로그램을 설치하여 Ubuntu OS에서 SSH 접근이 가능하도록 네트워크 설정까지 하는 방법에 대해 알아보도록 하겠습니다.

-----

<p>&nbsp;</p>



# VMware workstation 15 player 설치

vmware workstation player의 버전이 현재 가장 최신 버전인 16이 아니라 15인 이유는 player에서 필요한 네트워크 어댑터 설정 도구인 vmnetcfg 프로그램이 16버전은 존재하지 않아 15버전으로 설치를 해야만 합니다. 사실 두 버전에서 큰 차이가 없기 때문에 vmnetcfg 프로그램 버전에 따라 15 버전을 설치해 줍니다.

[VMware Workstation 15.5.7 Player 다운로드 페이지](https://customerconnect.vmware.com/en/downloads/details?downloadGroup=PLAYER-1557&productId=800&rPId=55787)

 

![vmware 다운로드](https://drive.google.com/uc?export=view&id=11C1jY2w-Afo8bCtTUynXUnnOB6aC0gpy)



대부분 windows 64bit 환경을 사용하시고 계실 것이라고 예상 되기 때문에 첫번째의 for Windows 64-bit Operating Systems 파일을 다운로드 해주시면 됩니다. 그리고 다운로드가 완료되면 특별한 작업 없이 Next 만 반복적으로 눌러서 설치를 완료해 주시면 됩니다.

![vmware workstation 15 player](https://drive.google.com/uc?export=view&id=1nnP0imxq_ZBdbNtR-6AeQMWrboIGJp48)

다음과 같이 15 버전의 vmware player가 설치되고 정상적으로 실행 된 것을 보실 수 있습니다.

-----

<p>&nbsp;</p>


# vmnetcfg 설치

VMware player에서 nat 설정을 위해서는 별도의 네트워크 어댑터 설정 프로그램이 필요하므로 vmnetcfg 프로그램을 player와 동일한 버전으로 설치를 해 줍니다. 저희는 15.5.7 버전의 player를 설치하였으므로 역시 vmnetcfg 프로그램도 15.5.7 버전으로 설치해주겠습니다.

[vmnetcfg 프로그램 다운로드 페이지](https://www.tobias-hartmann.net/2018/12/download-vmnetcfg-exe-fuer-vmware-workstation-15-x-player/)

 

![vmnetcfg 다운로드](https://drive.google.com/uc?export=view&id=1BjAwRGVzBlrHMWaUgLTrk0GXf9aTwnMy)

다운로드 페이지로 접근한 뒤에 페이지를 조금만 내려가면 다음과 같이 Download Virtual Network Editor 다운로드 링크들이 보입니다. 가장 하단에 15.5.7 버전의 vmnetcfg 파일을 다운로드 해줍니다. 다운로드하면 zip 파일로 압축이 되어 있기 때문에 압축을 풀어주면 vmnetcfg.exe 실행 파일을 확인할 수 있습니다. vmnetcfg는 별도의 설치 과정 없이 vmnetcfg.exe 파일을 VMware Player가 설치되어 있는 디렉터리에 복사 또는 잘라내기 하여 붙어넣기 해주면 됩니다. 

저의 경우에는 VMware Player를 default 경로로 설치하여 C:\Program Files (x86)\VMware\VMware Player 경로에 넣어 주었습니다. 그 뒤에 vmnetcfg.exe 파일을 더블 클릭하여 실행시켜 주면 다음과 같이 정상적으로 Virtual Network Editor가 실행되는 것을 확인할 수 있습니다.

![vmware network editor](https://drive.google.com/uc?export=view&id=1UIj5aei39OjKqQxaVm-3tosX8YT2Cuzn)

-----

<p>&nbsp;</p>


# VMware Ubuntu 설치 및 네트워크 설정

앞서 vmnetcfg.exe 파일까지 올바른 위치에 이동시켜 Virtual Network Editor가 정상적으로 실행되는 것을 확인하였다면 Vmware Player 설치 및 세팅은 완료되었습니다. 이제 Ubuntu를 설치하고 SSH 접근을 위하여 네트워크 설정을 해보도록 하겠습니다. 제가 사용할 ubuntu 버전은 18.04 Server 버전 입니다. 가장 최신 LTS 버전은 20.04 이기 때문에 편하신 버전을 사용하시면 됩니다. 다만 16.04 이하의 버전은 세팅 방법이 다르기 때문에 저의 방법을 그대로 적용하기는 어려운 점이 있으실 것 같습니다.  

<p>&nbsp;</p>

## VMware Ubuntu 설치

[Ubuntu 다운로드 페이지](https://releases.ubuntu.com/18.04/)  

우선 위의 다운로드 페이지로 접근하여 Ubuntu 18.04의 Server insatll image를 다운로드 합니다.   

![create virtual machine](https://drive.google.com/uc?export=view&id=19N6U6R59C0--fLwLWzks-8ZR1MiwMYhb)

다운로드가 완료되었으면, VMware player에서 Create a New Virtual Machne을 클릭하여 새로운 가상 머신을 생성해 줍니다.  

![create virtual machine](https://drive.google.com/uc?export=view&id=1Q5sn2jJCmdg0tLk3kBxXoYVgKusM8aWt)

New Virtual Machine Wizard가 열리면 우리는 Ubuntu ISO 파일을 이용하여 Ubuntu 설치를 진행할 것이기 때문에 Installer disc image file (iso)를 선택해주고 Browse를 선택하여 앞서 다운 받은 Ubuntu ISO 파일을 선택해 줍니다.  

Next를 누르면 user name과 password를 입력하는 단계가 나오고 원하는 user name과 password를 입력해 줍니다. Full name도 중요하지 않기 때문에 원하는 name으로 대충 입력해주시면 됩니다.  

다음으로 Virtual machine name 역시 원하는 이름으로 지정해주시고 Location은 디스크 용량이 큰 별도의 디스크가 있다면 해당 디스크를 선택해주고 없다면 그대로 변경 없이 진행하면 됩니다.  

Disk Capacity의 경우 기본 설정으로 20GB가 되어 있으나 너무 작기 때문에 50GB 정도로 변경하여 줍니다.   

마지막으로 Customaize Hadrware를 눌러서 메모리 등을 설정해주고 Finish를 누르면 가상 이미지 생성은 완료됩니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1813nInYuXuX5fL8oa9yqDHP0ueTFFVrg)

가상 머신 생성이 완료되면 자동으로 실행되고 설치 첫 화면으로 언어 선택 페이지가 나옵니다. 
English를 선택해주고 엔터를 눌러줍니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1AP3GWoAG37VFr9nkmRcDx6vXnm6KRPO5)

22.02 버전으로 업그레이드가 가능하다는 문구와 함께 업그레이드를 진행할지 물어보게 됩니다. 저희는 원하는 버전으로 설치를 하였기 때문에 업그레이드 없이 진행하도록 Continue without updating 을 선택하고 엔터를 입력해 줍니다.  

다음 화면에서는 Keyboard 레이아웃에 대한 설정이 나오며 기본으로 English (US)로 되어 있으면 변경 없이 Done을 선택하여 넘어가 줍니다.  

네트워크 설정에서도 기본값으로 DHCPv4로 설정되어 있으며, OS 설치를 완료 후에 변경해 줄 것이기 때문에 우선은 변경 없이 Done을 선택하여 넘어가 줍니다. 이어서 Proxy 설정도 변경없이 넘어가주면 됩니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1Om1O0Qavx22wpUzoab3zNKxUhzR6hQ4c)

Ubuntu archive mirror 설정에서는 기본적으로 kr.archive.ubuntu.com 로 되어 있는 것을 좀 더 빠르게 다운 받을 수 있도록 카카오의 mirror archive로 변경해 줍니다. Mirror address 항목에 **http://mirror.kakao.com/ubuntu**를 입력해 주면 됩니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1R1ZfysSP1f5aSSWlGozJvispKgHHihfH)

Storage 설정에서는 Set up this disk as an LVM group에 체크 되어 있는 것을 해제하여 LVM 을 사용하지 않도록 해줍니다. 그러면 다음 페이지에서 File system summary라고 하여 디스크 요약 정보가 나오고 수정 없이 그대로 Done을 선택하여 진행주면 됩니다.  

Profile setup 페이지가 나오고 Ubuntu OS에서 사용할 sudo 계정을 생성해주는 것으로 원하는 이름과 패스워드를 입력해 주면 됩니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1leyDLhW3IFJwI09t8lZd1UqAu532v-C0)

SSH setup 페이지에서는 우리는 네트워크 설정 후 SSH 클라이언트 프로그램을 사용하여 접근할 것이기 때문에 Install OpenSSH server를 체크해주고 Done을 선택 해 줍니다. 그 뒤에 나오는 Featured Serve Snaps 페이지에서는 별도 체크 없이 지나가면 됩니다.  

여기까지 진행을 하면 Install이 시작되고 Install Log가 출력되는 것을 확인할 수 있습니다. 잠시 뒤 우분투 설치가 완료되면 Reboot Now를 선택하여 OS 재시작으로 해주고, 앞서 설정한 sudo 계정과 password를 입력하여 로그인 합니다. 그리고 네트워크 설정 변경을 위해 우선 종료를 해줍니다.  

```bash
$ sudo shutdown -h now
```
<p>&nbsp;</p>


## VMware Ubuntu 네트워크 설정

![ubuntu install](https://drive.google.com/uc?export=view&id=1t_NGWKH4qT_nDntIB0NhUi91BPEOji6v)

방금 생성한 가상 머신을 선택 후 오른쪽 클릭하여 Settings에 들어가 줍니다.  

![ubuntu install](https://drive.google.com/uc?export=view&id=1z8QVj8evdCy-kS9EbgyhxiY2PHNAlRK1)

가상 머신 세팅에서 Network Adapter를 선택하고 오른쪽 Network connection에서 Custom을 선택하여 **VMnet8(NAT)**를 선택해 줍니다.  

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1ZmxNHJsEqgh0dMeiRBqBaMKSuWv08hDp)

이제 앞서 다운 받았던 vmnetcfg.exe 를 실행한 뒤, 하단에 Change Settings을 눌러 관리자 권한으로 Virtual Network Editor를 실행 해 줍니다.  

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1tnKOvlJQ9heFeCzxmIqpfbaiJORc7_in)

그럼 이렇게 기존에 비활성화 되어있던 부분들이 활성화 된 것을 확인 할 수 있습니다. 하단에 Subnet IP를 확인해주고 변경을 하고 싶을 경우 192.168.55.0 등으로 변경을 하셔도 무관합니다. 단, 하단의 Subnet IP를 변경하였을 경우 NAT Settings와 DHCP Settings에서 동일한 IP 대역으로 변경해주어야 합니다.  

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1JyTTY_tVTRlNrRZyO3ootgpfKUzdJsxW)

NAT Settings를 눌러서 현재 Gateway IP가 어떻게 되어 있는지 확인 합니다. 192.168.77.2 로 되어 있으나 192.168.77.5 등 원하는 IP로 변경해도 무관합니다.  

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1zPUINOF8phZSNxc0sDPRwTrXBrtUBsTT)

그리고 DHCP Settings를 눌러서 설정 가능한 Starting IP address와 Ending IP address를 확인해 줍니다. 여기까지 설정이 완료되었으면 OK를 눌러서 설정을 마무리 해줍니다.  

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1Y8Fchj5Vl96p1dY5XXp_7jtcpNmRnvnI)

이제 다시 우분투를 실행하고 Ubuntu 18.04부터는 ifconfig가 아닌 netplan으로 네트워크 설정이 바꼈기 때문에 아래와 같이 네트워크 설정 파일을 열어 주면 위와 같이 설정되어 있는 것을 확인할 수 있습니다.  

```bash
$ sudo vi /etc/netplan/00-installer-config.yaml
```

![vmware 고정IP](https://drive.google.com/uc?export=view&id=1MXOZ_0BWCnTIAjUA9F81bBK1YOZKo0Re)

DHCP4로 설정되어 있는 부분을 false로 설정하여 고정 IP 사용으로 설정해주고 앞서 확인 했던 IP 대역을 이용하여 네트워크 설정을 진행해 줍니다. 저의 경우 192.168.77.0 번대 대역의 130부터 IP를 시작한다고 설정해 놓았으므로 192.168.77.135로 설정해 주었습니다. 그리고 nameservers는 DNS 서버를 정의하는 부분으로 8.8.8.8 로 Google DNS 서버를 바라보도록 하였습니다.   

```bash
$ sudo netplan apply
```

설정이 완료되었으면 netplan apply 명령어를 사용하여 설정값을 적용시켜 줍니다. 만약 문법상 오류가 있을 경우에는 netplan apply 실행시 에러 메시지가 출력되므로 에러 메시지를 확인후 수정 해주면 됩니다.  

```bash
$ ping google.com
```

마지막으로 google.com 으로 ping을 날려서 정상적으로 접근이 되는지 확인하고 ping이 정상적으로 나가면 네트워크 설정이 완료 되었습니다.