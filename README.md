# WeatherApplication

## 개요
 날씨를 확인할 수 있게 해주는 프로젝트. 사용자가 위치한 도시의 현재 날씨와, 이후 3일 동안의 날씨를 출력. 또한, 다른 도시를 검색해서 그곳의 날씨를 확인할 수도 있음.
 
 <img src = "https://user-images.githubusercontent.com/55693272/197079608-18192112-ab70-4842-972c-90a60d94c839.mp4" width = 250>
 
 
<br></br>
## 사용 기술
|구현 내용|도구|
|---|---|
|아키텍처|MVC|
|UI|UIKit|
|로컬 데이터 저장소| Core Data Framework의 Persistence|
|네트워크|URLSession|
|동시성 프로그래밍|GCD|
|위치 정보|Core Location Framework|

<br></br>
## 프로젝트 기간
- 기획 및 개발 ~ 앱스토어 배포: 2022.08.01 ~ 2022.08.24


<br></br>
## 사용 API
 [OpenWeather](https://openweathermap.org)


<br></br>
## 동작
* 현재 위치한 도시
  - CoreLocation을 통해 사용자의 위치 정보를 받아옴.
  - 위치 정보를 이용하여 현재 위치의 도시 이름을 받아옴.
  - 받아온 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
* 다른 도시 검색 
  - 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.


<br></br>
