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
## 해결하지 못한 문제
* 즐겨찾기 기능에서, fetch할 때 즐겨찾기한 순서대로 정렬하여 가져오지 못함.
* 셀 순서 바꾸기 기능 구현

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
## 개인정보처리방침
<details>
<summary>개인정보처리방침</summary>
(< 열목 >('https://github.com/ehddnr3473/WeatherApplication'이하 '열목날씨')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.

○ 이 개인정보처리방침은 2022년 8월 22부터 적용됩니다.


제1조(개인정보의 처리 목적)

< 열목 >('https://github.com/ehddnr3473/WeatherApplication'이하 '열목날씨')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

위치

위치 확인 등을 목적으로 개인정보를 처리합니다.


제2조(개인정보의 처리 및 보유 기간)

① < 열목 >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.

1. 위치
위치와 관련한 개인정보는 수집.이용에 관한 동의일로부터<지체없이 파기>까지 위 이용목적을 위하여 보유.이용됩니다.
보유근거 : 날씨 정보 제공


제3조(처리하는 개인정보의 항목) 

① < 열목 >은(는) 다음의 개인정보 항목을 처리하고 있습니다.

1. 
필수항목 : 위치

제4조(개인정보의 파기절차 및 파기방법)

① < 열목 > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

② 개인정보 파기의 절차 및 방법은 다음과 같습니다.
1. 파기절차
< 열목 > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < 열목 > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.



제5조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)

① 정보주체는 열목에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.

② 제1항에 따른 권리 행사는열목에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 열목은(는) 이에 대해 지체 없이 조치하겠습니다.

③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.

④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.

⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.

⑥ 열목은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.



제6조(개인정보의 안전성 확보조치에 관한 사항)

< 열목 >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.

1. 정기적인 자체 감사 실시
개인정보 취급 관련 안정성 확보를 위해 정기적(분기 1회)으로 자체 감사를 실시하고 있습니다.


제7조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)

열목은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.


제8조 (개인정보 보호책임자에 관한 사항)

① 열목 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자
성명 :김동욱
직책 :개발자
연락처 :01051343473, ehddnr73@naver.com
※ 개인정보 보호 담당부서로 연결됩니다.

② 정보주체께서는 열목 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 열목 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

제9조(개인정보의 열람청구를 접수·처리하는 부서)
정보주체는 ｢개인정보 보호법｣ 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다.
< 열목 >은(는) 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.


제10조(정보주체의 권익침해에 대한 구제방법)

정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.

1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)

「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.

※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.

제11조(개인정보 처리방침 변경)


① 이 개인정보처리방침은 2022년 8월 22부터 적용됩니다.)
</details>
 
## 심사 reject
* 심사를 미국에서 한다는 것을 생각하지 못하고, 아래와 같이 한국의 도시를 기준으로 데이터를 가져옴. 컨텐츠는 한국어로 처리하되, 전세계 어디에서든 앱을 실행할 수 있도록 명확하게 처리.
```swift
    private func requestCityName(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let city = DecodingManager.decode(with: data, modelType: CityName.self) else { return }
                
                DispatchQueue.main.async {
                    // 해외의 도시에서 데이터를 요청했을때, Entity/CityName의 ko(한글 도시 명을 담은 String), ascii와 같은 값을 API에서 넘겨주지 않음.
                    self.setCityName(cityName: city.koreanNameOfCity.cityName)
                    // -> self.setCityName(cityName: city[0].koreanNameOfCity.cityName ?? city[0].name)
                }
                
                DispatchQueue.global().async {
                    // 해외의 도시에서 데이터를 요청했을때, Entity/CityName의 ko(한글 도시 명을 담은 String), ascii와 같은 값을 API에서 넘겨주지 않음.
                    self.requestWeatherForecast(cityName: city.koreanNameOfCity.ascii ?? city.name)
                    // -> self.requestWeatherForecast(cityName: city[0].name)
                }
                
                guard let url: URL = self.apiManager.getCityWeatherURL(cityName: city.koreanNameOfCity.ascii ?? city.name) else { return }
                self.requestWeatherDataOfCity(url: url)
                // -> guard let url: URL = self.apiManager.getCityWeatherURL(cityName: city[0].name) else { return }
                self.requestWeatherDataOfCity(url: url)
            case .failure(let error):
                switch error {
                default:
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if !self.alert.isBeingPresented {
                            self.alert.message = self.apiManager.errorHandler(error: error)
                            self.present(self.alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
```



