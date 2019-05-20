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
    
    let realm : Realm
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
    
    
    // intialisers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
       
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // intialisers
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
       
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopRun()
        self.distanceLabel.text = "Distance:"
        self.timeLabel.text = "Time:"
        self.paceLabel.text = "Pace:"
        
    }
    
    
   
    
    // function that exccutes when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        milesLabel.text = "Challenge: \(String((selectedChallenge?.miles)!)) miles"
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
        
    }

    // Function to allow update display eachsecond
    func eachSecond() {
        seconds += 1
        updateDisplay()
        
    }
    
    // Function to update the stats when the challenge starts
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
                    
                    
                    
                    run = newRun
                    timer?.invalidate()
                    
                    let result = Result()
                    result.user = userLoggedIn
                    result.details = run
                    
                    if result.details != nil {
                         realm.add(result)
                    }
                    
                    selectedChallenge?.results.append(result)
                
                }
                
                
                
                
                let alertController = UIAlertController(title: "Challenge Finished",
                                                        message: "Do you wish to see your challenge attempt?",
                                                        preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                    self.stopRun()
                    alertController.dismiss(animated: true, completion: nil)
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
        
//       destinationVC.selectedChallengeName = selectedChallenge?.name

    }
    
    
    
    //To start challenge
    @IBAction func startTapped(_ sender: Any) {
        startRun()
    }
    
    //Unused method
    // @IBAction func stopTapped(_ sender: Any) {
////        let alertController = UIAlertController(title: "End Challenge?",
////                                                message: "Do you wish to end your challenege attempt?",
////                                                preferredStyle: .actionSheet)
////        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
////
////        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
////            self.stopRun()
////            _ = self.navigationController?.popToRootViewController(animated: true)
////        })
////
////        present(alertController, animated: true)
//    }
    
    
    // func to take user back to the home screen
    @objc func home(){
        
        let alertController = UIAlertController(title: "Are you sure you want to go to the main menu?", message: "Attempt will not be saved", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
             self.stopRun()
             self.navigationController?.popToRootViewController(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
       
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // func that starts the run
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
    
    //func to stop the run
    private func stopRun() {
      
        locationManager.stopUpdatingLocation()
    }
    
    // func to start location methods
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 5
        locationManager.startUpdatingLocation()
    }
    
}

// allows receiving location updates
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
    
    
    

    


