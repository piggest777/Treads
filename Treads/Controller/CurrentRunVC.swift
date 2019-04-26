//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-12.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipeBGImageView: UIImageView!
    
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    fileprivate var startLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    
    fileprivate var runDistance  = 0.0
    fileprivate var counter = 0
    fileprivate var timer = Timer()
    fileprivate var pace = 0
    fileprivate var coordinateLocations = List<Location>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender: )))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
   
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func startTimer() {
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace (time seconds: Int, kilometers: Double) -> String {
        pace = Int(Double(seconds) / kilometers)
        return pace.formatTimeDurationToString()
    }
    
    func pauseRun(){
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
        startLocation = nil
        lastLocation = nil
    }
    
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 64
        let maxAdjust: CGFloat = 103
        if let sliderView = sender.view {
           if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
            let translation = sender.translation(in: self.view)
            if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust) {
                sliderView.center.x = sliderView.center.x + translation.x
            } else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                endRun()
                dismiss(animated: true, completion: nil)
            } else {
                sliderView.center.x = swipeBGImageView.center.x - minAdjust
                
            }
            
            sender.setTranslation(CGPoint.zero, in: self.view)
            }
           else if sender.state == UIGestureRecognizer.State.ended {
            UIView.animate(withDuration: 0.1) {
                sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
            }
            }
        }
    }
    
    @IBAction func pauseBtnWasPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
    }
    
}

extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, kilometers: runDistance.metersToMiles(places: 2))
            }
            
        }
        lastLocation = locations.last
    }
    
}
