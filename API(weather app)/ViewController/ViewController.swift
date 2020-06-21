//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Антон Скидан on 21.06.2020.
//  Copyright © 2020 Anton Skidan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var icon = UIImageView(image: UIImage(named: "sun.min", in: .none, with: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 150), scale: .default)))
    var cityLabel = UILabel(text: "City",font: .Helvetica30())
    var temperatureLabel = UILabel(text: "0 °C", font: .Kefa70())
    var temperatureFeelsLikeLabel = UILabel(text: "Feels like 1 °C", font: .Kefa20())
    var searchButton = UIButton(type: .system)
   
    
    var networkManager = NetworkManager()
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
         searchButton.addTarget(self, action: #selector(self.searchButtonPressed), for: .touchUpInside)
    }
    
    @objc
    func searchButtonPressed() {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] cityName in
        self.networkManager.fetchCurrentWeather(requestType: .cityName(city: cityName))
        }
    }
    
    func updateInterface(weather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString) °C"
            self.temperatureFeelsLikeLabel.text = "Feels like \(weather.feelsLikeTemperatureString) °C "
            self.icon.image = UIImage(systemName: weather.systemIconNameString, withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 150), scale: .default))
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.fetchCurrentWeather(requestType: .coordinates(latitude: latitude, longitude: longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - presentSearchAlertController
extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Amsterdam", "Moscow", "New York", "Berlin", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
              
                let cityName = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(cityName)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - setupConstraints
extension ViewController {
    
    private func setupConstraints() {
        let searchConfiguration = UIImage.SymbolConfiguration(font: .Helvetica30()!, scale: .default)
        searchButton.setImage(UIImage(named: "magnifyingglass.circle.fill", in: .none, with: searchConfiguration ), for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [cityLabel, searchButton])
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureFeelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(icon)
        view.addSubview(temperatureLabel)
        view.addSubview(temperatureFeelsLikeLabel)
        stackView.addSubview(cityLabel)
        stackView.addSubview(searchButton)
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor , constant: 300),
        ])
        NSLayoutConstraint.activate([
            temperatureFeelsLikeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureFeelsLikeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 3),
            temperatureFeelsLikeLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            temperatureFeelsLikeLabel.trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor)
        ])
    }
}






