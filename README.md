<p align="center">
 <img src="/Document/AppIconImage/YeolmokWeatherIcon.png" width=10%>
</p>

# 열목날씨

## 개요
날씨를 확인할 수 있게 해주는 애플리케이션 프로젝트입니다. 
- 사용자가 위치한 도시의 현재 날씨와, 이후 3일 동안의 날씨를 볼 수 있음.
- 다른 도시를 검색해서 날씨를 확인할 수 있음.



<br></br>
## 프로젝트 기간
- 기획 및 개발 ~ 앱스토어 배포: 2022.08.01 ~ 2022.08.24
- 이후 리팩터링 및 업데이트


<br></br>
## 사용 기술
|구현 내용|도구|
|---|---|
|아키텍처|MVC|
|UI|UIKit|
|네트워크|URLSession|
|동시성 프로그래밍|Swift Concurrency|
|위치 정보|Core Location|
|로컬 데이터 저장소| Core Data의 Persistence|
|테스트|XCTest|



<br></br>
## 아키텍처 및 상세 구조
### 아키텍처
<p align="center">
 <img src="/Document/Images/mvc.png">
</p>

- **Controller**가 delegate, dataSource, target, 그리고 까다로운 비즈니스 로직 등 많은 책임을 가지게 됨. 
- 따라서 아래의 상세 구조와 같이, 여러 부분에서 사용하는 공통부분을 Service로 분리해주고, **Model**에서 관련 비즈니스 로직과 데이터 변환을 수행.


<br></br>
### 상세 구조
 <p align="center">
  <img src="/Document/Images/DetailedStructure.png">
 </p>


<br></br>
## 뷰 및 동작
<p align="center">
 <img src="/Document/SimulatorRecording/1.3/Simulator Recording ver2.0.gif" width="24%">
 <img src="/Document/Images/snow.png" width="24%">
 <img src="/Document/PreviewImage/1.3/6.7/6.7_3.png" width="24%">
 <img src="/Document/PreviewImage/1.3/6.7/6.7_4.png" width="24%">
</p>

* 현재 위치한 도시
  - CoreLocation을 통해 사용자의 위치 정보를 받아옴.
  - 위치 정보를 이용하여 현재 위치의 도시 이름을 받아옴.
  - 받아온 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
  - 데이터 가공 후 **View** 업데이트
* 다른 도시 검색 
  - 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
  - 데이터 가공 후 **View** 업데이트



<br></br>
## 테스트

### 유닛 테스트
- 네트워크 작업을 통해 올바른 날씨 데이터를 다운로드하는지 확인하는 테스트 케이스를 작성
- 현지화가 잘 적용되었는지 **Test Plan**을 사용해서 영어 및 한국어, 두 가지 **Configuration**으로 테스트를 진행

### UI 테스트
- 도시 검색 작업에 대해서 의도대로 작동하는지 확인하는 UI 테스트 케이스를 작성



<br></br>
## 개선 내용 히스토리
|내용|블로그 링크|
|---|---|
|Swift Concurrency|[Async/await](https://yeolmok.tistory.com/3)|
|Diffable DataSource|[Diffable DataSource](https://yeolmok.tistory.com/7)|
