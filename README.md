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
- 리팩토링, 업데이트: 진행중

<br></br>
## 사용 API
 [OpenWeather](https://openweathermap.org)

<br></br>
## Files
- Decoder: JSONDecoder
- FetchData: API 호출, 데이터 Fetch
- BookMark: CoreData의 Persistence를 이용하여 즐겨찾기 기능 구현

<br></br>
## 동작
* 현재 위치한 도시
  - CoreLocation을 통해 사용자의 위치 정보를 받아옴.
  - 위치 정보를 이용하여 현재 위치의 도시 이름을 받아옴.
  - 받아온 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
* 다른 도시 검색 
  - 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.


<br></br>
## 심사 reject 기록
![reject image](./rejectImage/reject.png)
* 심사를 미국에서 한다는 것을 생각하지 못하고, 한국의 도시를 기준으로 데이터를 가져옴. 콘텐츠는 한국어로 처리하되, 전 세계 어디에서든 앱을 실행할 수 있도록 명확하게 처리.


<br></br>
## 1.1 업데이트
1. Localization: 어플 이름 한글 표기
2. UINavigationController → UITabBarController
3. 일부 지역에서 날씨 정보를 가져오지 못하던 문제 해결
4. Core Location 관련하여 버그가 발생하는 코드 수정
5. 각 도시의 예보 데이터가 뒤섞이던 버그 수정
6. 그 외 리팩터링


<br></br>
## 1.2 업데이트
1. async/await 패턴 적용
2. UIActivityIndicatorView를 사용하여 날씨 정보 다운로드 진행 상황을 표시
3. 그 외 리팩터링

