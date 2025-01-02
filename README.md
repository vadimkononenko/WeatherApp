# WeatherApp IOS application

## Опис проекту
  **WeatherApp** - це мобільний IOS застосунок, який дозволяє користувачам:
  – Знайти місто за текстовим пошуком
  – Дізнатись прогноз погоди за обраною локацією

Додаток звертається до сервісу (http://api.weatherapi.com/v1). Цей сервіс дозволяє отримати багато інформації стосовно прогнозу погоди за обраною локацією в форматі JSON.

Основний технологічний стек: MapKit, Alamofire, SnapKit, Kingfisher

## Інструкція по запуску
### Необхідне ПО
XCode - середовище розробки застосунків (версія 15.0+)

### Встановлення необхідних бібліотек

target 'WeatherApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherApp
	pod 'SnapKit', '~> 5.6.0'
	pod 'Alamofire'
	pod 'Kingfisher', '~> 7.0'
end

### Запуск застосунку
Для того щоб запустити даний застосунок - потрібно натиснути кнопку Run у верхньому лівому куті, після чого запуститься симулятор на якому можна як на реальному пристрої протестувати роботу застосунку.

## Demo
[![demo](https://github.com/vadimkononenko/WeatherApp/assets/56753621/e4c09250-2729-408b-b20b-871bbea58d8e)](https://github.com/vadimkononenko/WeatherApp/assets/56753621/6ad713bf-4e66-4fc0-9eaf-6d03b8044998)
