//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 15.06.2023.
//

import UIKit
import SnapKit
import Kingfisher

class HomeVC: UIViewController {
    
    //MARK: - Views
    
    private let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "23"
        lbl.font = .boldSystemFont(ofSize: 68)
        lbl.textColor = .white
        return lbl
    }()
    
    private let locationInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Kyiv, Ukraine"
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
        lbl.text = "24"
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
        
        loadWeather(city: "Berlin")
    }
    
    //MARK: - Helpers
    
    @objc private func handleSearchButtonPressed() {
        
    }
    
    private func loadWeather(city: String) {
        NetworkService.shared.getWeeklyWeather(city: city) { result in
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
