# WeatherApplication

## 개요
 날씨를 확인할 수 있게 해주는 프로젝트. 사용자가 위치한 도시의 현재 날씨와, 이후 3일 동안의 날씨를 출력. 또한, 다른 도시를 검색해서 그곳의 날씨를 확인할 수도 있음.

<br></br>
## 환경
 iOS

<br></br>
## 사용 API
 [OpenWeather](https://openweathermap.org)

<br></br>
## Files
- Decoder: JSONDecoder
- FetchData: API 호출, 데이터 Fetch
- BookMark: CoreData를 이용한 즐겨찾기 기능

<br></br>
## 작동
* 현재 위치한 도시
  - CoreLocation을 통해 사용자의 위치 정보를 받아옴.
  - 위치 정보를 이용하여 현재 위치의 도시 이름을 받아옴.
  - 받아온 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
* 다른 도시 검색 
  - 텍스트필드의 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.

<br></br>
## 문제 해결 기록
### UIAlertController의 present 중복 문제
* 에러 처리시, UIAlertController를 사용하여 사용자에게 알림. 하지만 여러 개의 에러가 연쇄되어 발생시, UIAlertController가 어러개 present되면서 에러가 발생.
* 다음과 같이 isBeingPresented를 이용하여 UIAlertController의 present상태를 확인 후 띄워줌. 
```swift
if !self.alert.isBeingPresented {
    self.alert.message = self.apiManager.errorHandler(error: error)
    self.present(self.alert, animated: true, completion: nil)
}
```

<br></br>
### MSLayoutConstraint 변경
* 텍스트 필드에 텍스트를 입력할때, 텍스트필드의 너비가 줄어들면서 숨어있던 버튼이 나오게 하려고 했는데, 단순히 새로운 값을 activate() 해주면, 같은 뷰에 제약이 두 개가 들어가며 레이아웃이 깨짐.
  - 방법 1: 텍스트 필드와 버튼을 UIStackView에 넣고 버튼.isHidden = true를 사용하여 숨기기 (실패)
  - 방법 2: NSLayoutConstraint.deactivate()를 사용하여 제약을 deactivate 후, 다시 제약을 추가 (실패)
  - 방법 3: removeConstraint()를 사용하여 제약을 제거 후, 다시 제약을 추가 (실패)
  - 방법 4: 제약의 객체 타입은 NSLayoutConstraint, 해당 객체의 constant 값을 변경 (아래의 코드)
```swift
// 변수로 선언 후, NSLayoutConstraint.activate([])로 다른 뷰들의 제약을 설정해줄때, 적절한 곳에 넣음
private lazy var trailingOfSearchTextField: NSLayoutConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
 
@IBAction func touchUpCancelButton(_ sender: UIButton) {
       searchTextField.text = ""
       searchTextField.resignFirstResponder()
}
func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.2) {
        self.trailingOfSearchTextField.constant = -50
        self.view.layoutIfNeeded()
    }
}
    
func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    UIView.animate(withDuration: 0.2) {
        self.trailingOfSearchTextField.constant = -8
        self.view.layoutIfNeeded()
    }
}
```

<br></br>
### UITableView안에 UICollectionView 넣을 때, 데이터 전달하기
* UITalbeView DataSource
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        
        cell.dayLabel.text = dayList[indexPath.row]
        cell.prepare(forecast: forecasts[indexPath.row])
        
        return cell
    }
```
* UITableViewCell
```swift
// 전달받을 변수
private var forecast: Forecast?

override func prepareForReuse() {
        super.prepareForReuse()
        guard let forecast = forecast else {
            return
        }
        prepare(forecast: forecast)
    }
    
    // prepare를 통해서 테이블뷰의 indexPath.row마다 다른 데이터를 적용
    func prepare(forecast: Forecast) {
        self.forecast = forecast
    }
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return UICollectionViewCell() }
        
        cell.timeLabel.text = AppText.getTimeText(time: forecast.list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
```
 
<br></br>
