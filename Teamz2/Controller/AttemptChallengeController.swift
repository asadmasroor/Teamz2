//
//  AttemptChallengeController.swift
//  Teamz2
//
//  Created by Asad Masroor on 01/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class AttemptChallengeController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var milesLabel: UILabel!
    
    private var run: Run?
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    var selectedChallenge : Challenge? {
        didSet {
            
            self.title = "\((selectedChallenge?.name)!)"
            
        }
    }
    
    var userLoggedIn : User? 

    func eachSecond() {
        seconds += 1
        updateDisplay()
        
    }
    
    private func updateDisplay() {
        
        
        
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        
        
        
        print("\(distance)")
        print("\(formattedDistance)")
        
        
        var miles = formattedDistance.replacingOccurrences(of: " ", with: "")
         miles.removeLast(2)

        
        let milesString = String(miles)
        
        let challangeMiles = Double((selectedChallenge?.miles)!)
        
        if let miles = Double(milesString) {
            
            if (miles >= challangeMiles) {
        
                print("Done")
                self.stopRun()
                
                try! realm.write {
                    let newRun = Run()
                    newRun.distance = distance.value
                    newRun.duration = Int16(seconds)
                    newRun.timestamp = Date()
                    
                    for location in locationList {
                        let locationObject = Location()
                        locationObject.timestamp = location.timestamp
                        locationObject.latitude = location.coordinate.latitude
                        locationObject.longitude = location.coordinate.longitude
                        newRun.locations.append(locationObject)
                    }
                    
                    distanceLabel.text = "Distance:  \(distance.value)"
                    timeLabel.text = "Time:  \(newRun.duration)"
                    paceLabel.text = "Pace:  \("Hello")"
                    
                    run = newRun

                    
                    let result = Result()
                    result.user = userLoggedIn
                    result.details = run
                    
                    
                    selectedChallenge?.results.append(result)
                
                }
                
                
               
                
                let alertController = UIAlertController(title: "Challenge Finished",
                                                        message: "Do you wish to see your challenge attempt?",
                                                        preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                    self.stopRun()
                    
                    self.performSegue(withIdentifier: "viewResultSegue", sender: self)
                    
                })
                
                present(alertController, animated: true)
              
                
            } else {
                print("Not done yet")
            }
            
        } else {
            
        }
        
        
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChallenegeAttemptsViewController
        
        destinationVC.selectedChallenge = selectedChallenge
        destinationVC.userLoggedIn = userLoggedIn
    }
    
    

    @IBAction func startTapped(_ sender: Any) {
        startRun()
    }
    
    @IBAction func stopTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "End Challenge?",
//                                                message: "Do you wish to end your challenege attempt?",
//                                                preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
//            self.stopRun()
//            _ = self.navigationController?.popToRootViewController(animated: true)
//        })
//
//        present(alertController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        milesLabel.text = "Challenge: \(String((selectedChallenge?.miles)!)) miles"
        // Do any additional setup after loading the view.
    }
    
    private func startRun() {
        
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
      
        locationManager.stopUpdatingLocation()
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 5
        locationManager.startUpdatingLocation()
    }
    
//    private func saveRun() {
//        let newRun = Run()
//        newRun.distance = distance.value
//        newRun.duration = Int16(seconds)
//        newRun.timestamp = Date()
//        
//        for location in locationList {
//            let locationObject = Location()
//            locationObject.timestamp = location.timestamp
//            locationObject.latitude = location.coordinate.latitude
//            locationObject.longitude = location.coordinate.longitude
//            newRun.locations.append(locationObject)
//        }
//        
//        run = newRun
//    }
    
}

extension AttemptChallengeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
        
            locationList.append(newLocation)
        }
        
        
    }
}
    
    
    

    


