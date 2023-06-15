//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 15.06.2023.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    //MARK: - Views
    
    private let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "23"
        lbl.font = .boldSystemFont(ofSize: 68)
        return lbl
    }()
    
    private let locationInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Kyiv, Ukraine"
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "moon")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let tempInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "24"
        lbl.font = .systemFont(ofSize: 18)
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
        
        loadWeather(city: "London")
    }
    
    //MARK: - Helpers
    
    private func loadWeather(city: String) {
        NetworkService.shared.getCurrentWeather(city: city) { result in
            switch result {
            case .success(let currentForecast):
                self.updateUI(forecast: currentForecast)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func updateUI(forecast: CurrentForecast) {
        let temp = "\(forecast.current.tempC)°"
        let location = "\(forecast.location.name), \(forecast.location.country)"
        let feelslike = "Feels \(Int(floor(forecast.current.feelslikeC)))°"
        
        DispatchQueue.main.async { [self] in
            self.tempLabel.text = temp
            self.locationInfoLabel.text = location
            self.tempInfoLabel.text = feelslike
        }
    }
    
    //MARK: - Layouting
    
    private func configure() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tempLabel)
        view.addSubview(locationInfoLabel)
        view.addSubview(weatherImageView)
        view.addSubview(tempInfoLabel)
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
            make.top.equalTo(locationInfoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        tempInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

}
