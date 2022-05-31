---
title:  "[정규표현식 #2] 수량자와 그룹"
excerpt: "Python에서 정규표현식 사용시 수량자와 그룹에 대한 설명 "
toc: true
toc_sticky: true
toc_label: "목차"

categories:
  - Python
tags:
  - 정규표현식
---

<p>&nbsp;</p>



이번에는 지난 포스팅에 이어서 파이썬 정규표현식의 수량자(Quantifier)와 그룹(Group)에 대해서 알아보려고 합니다. 수량자와 그룹에 대해 이야기하기 앞서 지난 포스팅의 re모듈과 메타문자의 내용을 반드시 알고 계셔야 예제를 이해하실 수 있으므로 혹시 re모듈과 메타문자가 정확히 무엇인지 모르신다면 이전 포스팅을 확인하시는 것을 추천드립니다.  

[[정규표현식 #1\] re모듈과 메타문자](https://onestep-log.com/programming/re-module/)

-----

<p>&nbsp;</p>


# 수량자(Quantifier)란?

앞서 알아본 메타문자만을 가지고 매우 긴 패턴의 문자를 매칭하는 정규표현식을 만드는 것은 매우 귀찮으면서 비효율적인 일이 될 것 입니다. 예를 들어 \d는 하나의 숫자를 나타내는 메타문자로 5개의 숫자로 시작하는 패턴의 정규표현식을 만들려면 ^\d\d\d\d\d 과 같이 써야할 것입니다. 하지만 만약 50개의 숫자를 매칭해야하는 패턴은 어떻게 만들까요? 혹시 100개 이상의 숫자나 문자를 매칭해야한다면요? 바로 이때 필요한 것이 매칭하려는 문자의 수량을 표현할 수 있는 **수량자** 입니다. 가지고 있는 이름 그대로 매칭하고자 하는 문자나 숫자의 수량을 알려주는 표현식으로 다음과 같이 사용할 수 있습니다.  

- \*   : * 앞의 문자가 0개 이상인 모든 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife*"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlif', 'devlife', 'devlifee', 'devlifeee']
```

- \+   : + 앞의 문자가 1개 이상인 모든 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife+"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlife', 'devlifee', 'devlifeee']
```

- ?   : ? 앞의 문자가 0개 또는 1개인 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife?"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlif', 'devlife']
```

- {n}   : {n} 앞의 메타문자가 n개인 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife{3}"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlifeee']
```

- {n,}   : {n} 앞의 메타문자가 n개 이상인 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife{2,}"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlifee', 'devlifeee']
```

- {n, m}   : {n, m} 앞의 메타문자가 n개 이상, m개 이하인 패턴과 매칭 됩니다.  

```python
>> import re

>> string_input = "dev life devlif devlife devlifee devlifeee "
>> patter_input = "devlife{1,2}"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlife', 'devlifee']
```

-----

<p>&nbsp;</p>


# 그룹(Group)이란?

지금까지 알아본 메타문자와 수량자는 한 개의 문자에만 적용이 가능했기 때문에 다수의 특정 문자로 이루어진 패턴을 찾는데는 어려움이 있습니다. 따라서 이를 보완하기 위해 정규표현식에는 그룹이란 개념이 있습니다. 그룹은 소괄호 ( ) 를 이용하여 여러 문자를 하나로 묶어 패턴을 만드는데 이용됩니다. 이렇게 여러 문자를 그룹으로 묶은 뒤에 |(or) 메타 문자와 함께 쓰거나 그룹 뒤에 수량자를 추가하여 자주 사용 됩니다. 또한 그룹은 하나의 패턴 내에서 \\1, \\2와 같이 그룹 번호를 통해 재사용이 가능합니다.  


## 사용 예시 1(캡쳐링)

```python
>> import re

>> string_input = "dev life devlif devlife devlifefe devlifefefe "
>> patter_input = "devli(fe)+"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['fe', 'fe', 'fe']
```

사용 예시 1에서 findall() 함수를 이용하여 패턴을 찾으며 그룹으로 묶어 놓은 부분만 출력되는 것을 볼 수 있습니다. 이때 그룹으로 묶은 부분을 **캡쳐**했다고 이야기하며 파이썬 정규표현식에서 그룹으로 캡쳐한 부분이 있다면 캡쳐된 부분만 출력되게 됩니다. 캡쳐된 fe 뿐만 아니라 devli도 함께 출력하고 싶다면 그룹을 비캡쳐링 그룹으로 만들어주면 됩니다.  


## 사용 예시 2(비캡쳐링)

```python
>> import re

>> string_input = "dev life devlif devlife devlifefe devlifefefe "
>> patter_input = "devli(?:fe)+"
>> matching_output = re.findall(patter_input, string_input)
>> print(matching_output)
['devlife', 'devlifefe', 'devlifefefe']
```

사용 예시 2에서 보면 사용 예시 1과는 다르게 그룹화 된 패턴에 ?: 가 추가 된 것을 볼 수 있습니다. 바로 이 ?:가 비캡쳐링 그룹을 만드는 방법 입니다. 이렇게 비캡쳐링 그룹을 만들어주면 예시와 같이 그룹으로 묶어주지 않은 부분까지 함께 출력되게 됩니다.  

-----

<p>&nbsp;</p>


# 마치며

여기까지 수량자와 그룹 그리고 캡쳐링과 비캡쳐링까지 알아보았습니다. 앞선 포스팅과 현재 포스팅 두 편에 걸쳐서 정규표현식에 대해서 알아보았는데요 여기까지만 완벽하게 아셔도 일상적으로 정규표현식을 사용하는데 많은 도움이 되실거라 생각합니다. 좀 더 깊은 내용은 기회가 된다면 추가 포스팅하도록 하겠습니다.   


참고 : [re모듈 파이썬 공식 홈페이지](https://docs.python.org/ko/3/library/re.html)