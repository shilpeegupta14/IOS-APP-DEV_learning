//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager=WeatherManager()
    let locationManager=CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        locationManager.delegate=self
        
        weatherManager.delegate=self
        // Do any additional setup after loading the view.
        searchTextField.delegate=self
    }
    
    
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    //when search button is pressed
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    //user pressed on return/go button from keyboard
    func textFieldShouldReturn(_textfield:UITextField)->Bool{
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder="Type Something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city=searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_weatherManager:WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async{
            //update ui
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.cityName
            
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: -CLLocationManager
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            locationManager.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            weatherManager.fetchWeather(longitude: lon,latitude: lat)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
