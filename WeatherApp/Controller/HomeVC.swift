//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 15.06.2023.
//

import UIKit
import SnapKit
import Kingfisher
import CoreLocation

class HomeVC: UIViewController {
    
    //MARK: - Variables
    
    private let locationManager = CLLocationManager()
    private var latitude: Double?
    private var longitude: Double?
    
    //MARK: - Views
    
    private let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 68)
        lbl.textColor = .white
        return lbl
    }()
    
    private let locationInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let avgTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter city"
        textField.font = .systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var loadForecastBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Load forecast", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 20
        return btn
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearchButtonPressed))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChosenLocation), name: Notification.Name("ChoseLocation"), object: nil)
    }
    
    //MARK: - Helpers
    
    @objc private func handleChosenLocation(_ notification: Notification) {
        if let lat = notification.userInfo?["lat"] as? Double, let lon = notification.userInfo?["lon"] as? Double {
            loadWeatherForLocation(latitude: lat, longitude: lon)
        }
    }
    
    @objc private func handleSearchButtonPressed() {
        navigationController?.pushViewController(SearchVC(), animated: true)
    }
    
    private func loadWeatherForCity(city: String) {
        NetworkService.shared.getWeeklyWeather(city: city) { result in
            switch result {
            case .success(let forecast):
                self.updateUI(forecastModel: forecast)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func loadWeatherForLocation(latitude: Double, longitude: Double) {
        NetworkService.shared.getWeeklyWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let forecast):
                self.updateUI(forecastModel: forecast)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func updateUI(forecastModel: WeeklyForecast) {
        let temp = "\(forecastModel.current.tempC)°"
        let location = "\(forecastModel.location.name), \(forecastModel.location.country)"
        let minTemp = Int(floor(forecastModel.forecast.forecastday[0].day.mintempC))
        let maxTemp = Int(floor(forecastModel.forecast.forecastday[0].day.maxtempC))
        let minMaxTemp = "min: \(minTemp)° max: \(maxTemp)°"
        guard let url = URL(string: "http:\(forecastModel.current.condition.icon)") else {
            return
        }
        
        DispatchQueue.main.async { [self] in
            self.tempLabel.text = temp
            self.locationInfoLabel.text = location
            self.avgTempLabel.text = minMaxTemp
            self.weatherImageView.kf.setImage(with: url)
        }
    }
    
    //MARK: - Layouting
    
    private func configure() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "bg")
        view.addSubview(tempLabel)
        view.addSubview(locationInfoLabel)
        view.addSubview(weatherImageView)
        view.addSubview(avgTempLabel)
    }
    
    private func setupConstraints() {
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.centerX.equalToSuperview()
        }
        locationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(locationInfoLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(200)
        }
        avgTempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }

}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        loadWeatherForLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
