---
title:  "[#1] Java(JDK) 및 이클립스(Eclipse) 설치하기"
excerpt: "Java JDK 설치 방법과 IDE인 Eclipse 설치 방법 "
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Programming
tags:
  - Java
---

<p>&nbsp;</p>

이번 포스팅에서는 자바 개발을 위해서 필요한 JDK(Java Development Kit)와 자바 개발을 편리하게 도와주는 IDE를 설치하는 방법에 대해서 알아 보려 합니다. 대표적인 자바 IDE로는 무료인 오픈소스 IDE 이클립스(Eclipse)가 있으며, 유료 IDE로는 Jet Brains 사에서 개발한 InteliJ가 있습니다. 여기서는 무료인 이클립스를 설치하는 방법에 대해서 알아볼 것입니다.  


또한 JDK 버전으로는 오라클(Oracle)사의 LTS(Long Term Support) 버전 중 하나인 11 버전을 설치해볼 것입니다. 참고로 오라클 JDK는 개인이 사용하는 것은 무료이지만 회사에서 사용하게 된다면 라이센스 위반이기 때문에, 회사에서 사용시 주의하셔야 합니다.  

-----

<p>&nbsp;</p>

# JDK 11 다운로드

Google 등 검색 사이트를 이용하여 오라클 공식 홈페이지에 접속합니다. 최초 접속시에는 쿠키 관련 여부를 팝업차으로 물어보면 “모든 쿠키 수락”을 클릭합니다. 상단 탭 가장 오른쪽에서 “개발자”를 클릭하고 아래에 “개발자 리소스 센터”를 클릭합니다.  

![JDK 다운로드](https://drive.google.com/uc?export=view&id=1obnTXUInbcbTfW1sGcrkmyWKE4b_jE0u)


페이지가 이동되면 선호하는 언어로 개발에서 “Java”를 클릭합니다.  

![jdk 다운로드](https://drive.google.com/uc?export=view&id=1FRgG_vL9DTL75VMqnQFi6tEA_-AsnzVf)

Java 화면으로 넘어가면 중앙에 “Java 다운로드하기” 를 클릭합니다.  

![jdk 11](https://drive.google.com/uc?export=view&id=1Xe_Z99EjSwUf_Q4NwBa_ZzFN17gvrJRm)

자바 다운로드 화면으로 넘어가면, 중앙 탭에서 “Java archive” 를 클릭합니다.  

![jdk 다운로드](https://drive.google.com/uc?export=view&id=1WIHNYIqjiuKqmRe0Y0YFRWVFizOtjEdU)

왼쪽에 Java SE downloads 리스트에서 우리가 다운받고자하는 버전인 “Java SE 11″을 클릭합니다.  

![jdk11](https://drive.google.com/uc?export=view&id=1cJtt-f77KaMwnx_1SFmDlTWBuonlqMLA)

Java SE Development Kit 11 다운로드 페이지에서 각자 사용하고 있는 OS에 맞는 Install 파일을 다운로드 합니다. 저의 경우 64bit Windows에 설치할 것이기 때문에 Windows x64 Installer를 다운받았습니다.  

![jdk 다운로드](https://drive.google.com/uc?export=view&id=1Cu90qotO5cK2SugEtR-J1flCVpugd3tV)

다운로드에 앞서 Java SE에 대한 오라클 라이센스 정책에 동의하고 다운로드하겠냐는 체크박스가 뜨는데 동의한다고 체크하고 다운로드를 진행합니다.  

![jdk 11](https://drive.google.com/uc?export=view&id=1ox4S0G-ZQWTnSInbkzjuhcDIz9An58XJ)

다운로드시에는 반드시 오라클 계정 로그인이 필요하기 때문에, 계정이 없으실 경우 생성해주셔야 합니다.  

![oracle login](https://drive.google.com/uc?export=view&id=1fxO3pCA2YrA9gUCyLkY2s7Np2ZL3qBOO)

이렇게 로그인까지 진행하여 다운로드가 완료되었다면 각자의 OS 방식에 맞게 JDK를 설치해주시면 됩니다. Windows의 경우에는 다운 받은 exe 파일을 실행시켜 별도 설정 없이 다음 다음을 누르며 설치를 마치시면 됩니다. 

JDK 다운로드 링크 : https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html

-----

<p>&nbsp;</p>

# JDK 환경변수 등록
JDK의 설치가 완료되었으면 OS의 환경변수에 JDK의 위치를 등록해주어야 한다. 그래야만 IDE 등에서 JDK를 쉽게 불러서 사용할 수 있습니다. 저는 Windows 기반으로 설치하였기 때문에 Windows 기반으로 설명드리겠습니다. Linux 기반으로 설치하신 분들은 오히려 Window 더 쉽게 .bashrc 나 /etc/profile, /etc/bash_bashrc 파일 등에 환경변수를 등록할 수 있습니다.  

먼저 윈도우 탐색기의 “내 PC”에서 오른쪽 마우스 버튼을 클릭한 후 “속성”을 클릭합니다.  

![윈도우 속성](https://drive.google.com/uc?export=view&id=1KQm66kdkSVCDqBnhgcYnyjcyuFI8RNGG)

“시스템” 화면이 실행되면 오른쪽에서 “고급 시스템 설정”을 클릭 합니다.  

![시스템](https://drive.google.com/uc?export=view&id=1_yEFZM0-gEMgrQtIAVrLMhcy7h8EDhLe)

“시스템 속성” 에서 고급탭을 확인하고 하단에 “환경 변수(N)”을 클릭해 줍니다.  

![시스템속성](https://mr-devlife.com/wp-content/uploads/2021/12/11-min.webp)

“환경 변수” 창에서 “시스템 변수”의 “새로 만들기(W)”를 클릭합니다.  

![환경변수](https://drive.google.com/uc?export=view&id=1UXuWOQE-MAZJkTtzS_i9mm_J8XAl6yjS)

“새 시스템 변수”에서 “변수 이름”에는 JAVA_HOME으로 해주고 변수 값에는 실제 JDK가 설치된 경로를 “디렉터리 찾아보기”로 설정해 줍니다. 자바 설치시 별도 변경 없이 다음 다음을 눌러서 설치하였다면 C:\Program Files\Java\jdk-11.0.13 의 경로에 있습니다.  


![환경변수 등록](https://drive.google.com/uc?export=view&id=1YvZVF7qr-gcNRRNI1Q3gELeZ5cN9rj0-)

“새 시스템 변수”를 만들어 주었다면, “시스템 변수” 목록 중에 변수명이 “Path” 인 것을 찾아서 “편집”을 눌러 줍니다.  

![path](https://drive.google.com/uc?export=view&id=1STSsCZiqouHhgLHSeyLNcZBn37HqpMcy)

오른쪽 버튼 중 “새로 만들기”를 눌러서 자바 실행 파일들이 들어 있는 %JAVA_HOME%\bin 경로를 등록해 줍니다.  

![path 편집](https://drive.google.com/uc?export=view&id=1w-LgLM1SdKjxZVKx_2sswbLApQ5bmPb9)

마지막으로 JAVA_HOME 변수를 만들어주었던 것과 동일하게 시스템 변수의 “새로 만들기(N)” 버튼을 눌러 CLASSPATH를 등록해 줍니다. CLASSPATH는 자바의 라이브러리 파일이 들어 있는 경로를 등록해 주는 것 입니다.  

![classpath](https://drive.google.com/uc?export=view&id=1DhDmQZj6Hsf6kec1IMAVCpE_8ylBenYj)

여기까지하면 자바 설치부터 환경변수 등록까지 완료되었습니다. 이제 실제로 자바 개발을 위해 Eclipse를 설치해보도록 하겠습니다.  

-----

<p>&nbsp;</p>

# 이클립스(Eclipse) 다운로드 및 설치

Google 검색창에 이클립스라고 검색하여, Eclipse Downloads 페이지에 접속합니다.  

다운로드 페이지 : https://www.eclipse.org/downloads/

![이클립스 다운로드](https://drive.google.com/uc?export=view&id=1N-73yprS095qtHC0RfFyg3IUbCQwB7r4)

이클립스 다운로드 페이지에서 가장 최신 버전의 이클립스를 다운로드 버튼을 누릅니다.  

![이클립스 다운로드](https://drive.google.com/uc?export=view&id=1hfJdng7RAjbD1ciITBnD2wheunwxt3k4)

다운로드 받게 될 파일명과 파일 서버의 위치가 나오고 다시 한번 다운로드 버튼을 눌러 줍니다. 저의 경우에는 카카오의 파일 서버에서 이클립스 파일을 받아오는 것을 확인할 수 있습니다.  

![이클립스 다운](https://drive.google.com/uc?export=view&id=1ZzshyIJULHOcu1ubRwH3r5xYXL47nwKc)

다운로드 받은 파일을 실행하여 Eclipse Installer가 실행되면 가장 위에 있는 “Eclipse IDE for Java Developers”를 클릭 합니다.  

![이클립스 installer](https://drive.google.com/uc?export=view&id=1QPE3G9h70cfEu9dh9Igz_AcklLXpHx_b)

이클립스가 설치될 폴더를 확인해주고 연결될 JDK 파일 디렉터리도 확인해 줍니다. 모두 원하는 경로에 설정이 되어 있으면 “INSTALL”을 클릭 합니다.  

![이클립스 설치](https://drive.google.com/uc?export=view&id=1wh-HMUnCPmrsrHEA5auXulpgL-935fOK)

이클립스 설치가 진행되는 것을 확인할 수 있습니다. 설치 중간에 설치를 취소하고 싶다면 “Cancel Installation”을 클릭해줍니다.  

![이클립스 설치](https://drive.google.com/uc?export=view&id=1jfnRFBxXz2n2SrZ67PxzkPY2R95fPqhP)

이클립스 설치가 완료되면 “LAUNCH” 버튼을 눌러서 실행합니다. 시작 메뉴나 바로가기 아이콘을 만들고 싶지 않다면, “create start menu entry”와 “create desktop shortcut” 체크 박스를 해제해 줍니다.  

![이클립스 실행](https://drive.google.com/uc?export=view&id=13r2gQE5Ip9bdebrQq0N1PWUTI9BJ07oM)

이클립스를 실행시키면, 가장 먼저 앞으로 자바 파일이 생성될 워크스페이스를 선택해 줍니다. 설정한 경로에 자바 class 파일 및 라이브러리 등 모든 파일이 생성 됩니다.  

![이클립스 워크스페이스](https://drive.google.com/uc?export=view&id=1aCfKOtybZxo34NJL0b00PBOwJD3oFiJq)

마지막으로 이클립스 사용시 필수 설정으로 이클립스의 텍스트 인코딩을 변경해 줍니다.   

이클립스 탭에서 “Preferences”를 선택하고 “General -> Workspace -> Text file encoding”에서 “Other: UTF-8″을 선택해 주고 “Apply and close” 를 클릭해 줍니다.  

해당 인코딩 설정을 해주지 않고 윈도우에서 코드에 주석 등으로 한글을 입력하고 git이나 Linux 등에서 열어보면 한글이 모두 깨져서 보이는 것을 확인할 수 있습니다. 이는 윈도우에서 기본 인코딩을 MS949를 사용하기 때문입니다.  

![이클립스 인코딩](https://drive.google.com/uc?export=view&id=1uvTvwNC7ILfvMcuwrnUCqnNk4hO8m3XV)

이렇게 자바를 설치해보고 자바 IDE인 이클립스까지 설치를 해보았습니다.  
아마 대부분 어렵지 않게 설치를 완료하셨을 것이라 생각이 들며 혹시 수정해야할 사항이나 궁금한 점이 있으시다면 댓글로 부탁드리겠습니다.  