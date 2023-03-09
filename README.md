# ✈ 프로젝트 이름

<p align="center">
민방위대피시설 안내 어플리케이션 '여기로가'
</p>


## 🚩 프로젝트 소개

<p align="justify">

**프로젝트 개요/동기**

</p>

<p align="center">

최근 사회재난과 자연재해로 인해 사고 발생 빈도가 급격히 증가하는 것을 볼 수 있다. 따라서 **애플리케이션 ‘여기로 가’는 자연, 사회 및 비상 재난 발생 시 사용자 위치에 따른 최적 대피시설 안내를 목적**으로 한다. 부가적으로 재난별 행동 요령을 제공함으로써 사용자들이 재난 상황에 신속하게 대응할 수 있도록 한다. 또한 친구 사용자 간 위치 공유 기능을 지원하여 위급상황에서 상호 위치를 공유할 수 있도록 지원한다.

</p>

## 💻 기술 스택

#### 개발 환경

| Android Studio | Flutter |
|----------------|---------|
|<img src="https://img.shields.io/badge/Android-Studio-3DDC84?style=for-the-badge&logo=androidstudio&logoColor=white">| <img  src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">|

#### 언어

| Dart | JavaScript | HTML | CSS |
|------|------------|------|-----|
|<img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">|<img  src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black">|<img  src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white">|<img  src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white">|

#### DB

| Firebase | SQLite |
|----------|--------|
|<img  src="https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">|<img  src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white">|

#### 협업
| Git | Github |
|--|--|
| <img  src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> | <img  src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> |


<br>

## 📣 구현 기능


### 기능 1 - 대피소 안내
<p align="justify">
현재 위치 기준 근방 1km 내 대피소를 출력해준다. 마커를 눌러 특정 시설 정보 확인 및 가장 가까운 대피소까지의 길 안내 제공. (Kakao Map API 이용)
</p>

### 기능 2 - 행동지침
<p align="justify">
행동지침 데이터를 json 형식을오 변환하여 어플 내부에 저장한다. 그리고 안내문 형식의 행동지침을 제공하여 인터넷이 되지 않는 상황을 고려하여 행동지침을 제공한다.
</p>

### 기능 3 - 재난문자
<p align="justify">
HTTP POST 방식을 이용하여 실시간으로 응답받은 재난문자를 SQLite를 활용해 내부 DB에 저장해준다. 지역별로 필터링을 할 수 있으며, 최근 순으로 제공된다. 해당 재난문자 데이터는 최근 3일간의 데이터만 저장되고, 유효기간이 지나면 삭제한다.
</p>

### 기능 4 - 친구관리 및 위치공유
<p align="justify">
사용자 간 아이디 검색을 통해 친구 추가를 할 수 있으며, 이를 관리할 수 있는 기능도 추가하였다. 또한 재난 상황 시 친구 간의 위치 공유를 통해 서로의 위치를 파악할 수 있는 기능을 제공한다.
</p>

<br>

## 알고리즘

<!--알고리즘 사진 첨부-->
![플로우차트](https://user-images.githubusercontent.com/76736548/201462363-d2564821-ad8f-4a2b-809b-3ccad1e8cc9c.png)

<br>

## 영상

<!-- 영상 제작 후 링크 추가-->
[![여기로가 시연 영상](https://img.youtube.com/vi/z6AdZMuiQEg/0.jpg)](https://youtu.be/z6AdZMuiQEg)
<br>

## 배운 점 & 아쉬운 점
실생활에 필요한 것을 생각하고 이를 구현해 사용자에게 필요한 기능을 제공할 수 있었던 프로젝트였다.

<br>

## 라이센스
Copyright @ HW & HS & DM
<!-- Refernces -->
