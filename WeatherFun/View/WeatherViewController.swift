//
//  ViewController.swift
//  JustWeather
//
//  Created by Bogdan on 9/28/20.
//  Copyright © 2020 Bogdan Zarioiu. All rights reserved.
//


// lat: 45.46
// long: 9.19
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private var containerStackView = UIStackView()
    private var containerStackViewMain = UIStackView()
    
    private var cityNameLabel = UILabel()
    private var temperatureLabel = UILabel()
    private var weatherImageView = UIImageView()
    private let jokeLabel = UILabel()
    private let refreshButton = UIButton()
    
    var weatherManager = WeatherManager()
    
    private var latitude: CLLocationDegrees!
    private var longitude: CLLocationDegrees!
    private let locationManager = CLLocationManager()
    var lat = 45.46  // test lat
    var lon = 9.19  //test lon
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 3) {
            self.weatherImageView.layer.contentsScale = 0.5
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        setStackView()
        setupWeatherImageView()
        setupJokeLabel()
        setupRefreshButton()
        
        
    }
    
    func setStackView() {
        view.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 0
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.alignment = .fill
        
        
        //constraints
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16).isActive = true
        
        
        
        cityNameLabel.text = "Bucharest"
        cityNameLabel.font = UIFont(name: "AvenirNext-Heavy", size: 50)
        cityNameLabel.adjustsFontSizeToFitWidth = true
        cityNameLabel.minimumScaleFactor = 0.5
        
        temperatureLabel.text = "19℃"
        
        temperatureLabel.font = UIFont(name: "AvenirNext-Heavy", size: 40)
        
        weatherImageView.image = UIImage(systemName: "sun.max")
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintColor = .black
        //weatherImageView.backgroundColor = .systemGreen
        
        containerStackView.addArrangedSubview(cityNameLabel)
        containerStackView.addArrangedSubview(temperatureLabel)
        
        view.addSubview(weatherImageView)
    }
    
    
    
    func setupWeatherImageView() {
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 20).isActive = true
        weatherImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weatherImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weatherImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        weatherImageView.tintColor = .systemGray
    }
    
    func setupJokeLabel() {
        view.addSubview(jokeLabel)
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        jokeLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 30).isActive = true
        jokeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        jokeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        jokeLabel.numberOfLines = 0
        jokeLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
        
        
    }
    
    func setupRefreshButton() {
        view.addSubview(refreshButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        //        refreshButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 30).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        
        refreshButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.text = "Test"
        refreshButton.backgroundColor = .black
        refreshButton.tintColor = .systemBackground
        refreshButton.clipsToBounds = true
        refreshButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 30)
        refreshButton.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)
        
        
        
        
    }
    @objc func refresh(_ sender: UIButton) {
        print("hello")
        jokeLabel.text = WeatherJokes().jokes.randomElement()!
        UIView.animate(withDuration: 0.05, animations: {
            self.refreshButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { (done) in
            UIView.animate(withDuration: 0.05) {
                self.refreshButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString) ºC"
            self.weatherImageView.image = UIImage(systemName: weather.conditionName)
            UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
                self.weatherImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { (done) in
                UIView.animate(withDuration: 0.5) {
                    self.weatherImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                }
            }
            self.jokeLabel.text = WeatherJokes().jokes.randomElement()!
            
            
            
            
        }
        print(WeatherJokes().jokes.randomElement()!)
    }
    
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
