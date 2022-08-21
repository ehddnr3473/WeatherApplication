# WeatherApplication

## 개요
 날씨를 확인할 수 있게 해주는 프로젝트입니다. 사용자가 위치한 도시의 현재 날씨와 이후 3일 동안의 날씨를 출력합니다. 또한, 다른 도시를 검색해서 그곳의 날씨를 확인할 수도 있습니다.
 
## 환경
 iOS
 
## 사용 API
 [OpenWeather](https://openweathermap.org)

## Files
- Decoder: JSONDecoder
- FetchData: API 호출, 데이터 Fetch
- BookMark: CoreData를 이용한 즐겨찾기 기능

## 작동
* 현재 위치한 도시
  - CoreLocation을 통해 사용자의 위치 정보를 받아옵니다.
  - 위치 정보를 이용하여 현재 위치의 도시 이름을 받아옵니다.
  - 받아온 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옵니다.
* 다른 도시 검색 
  - 텍스트필드의 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옵니다.
