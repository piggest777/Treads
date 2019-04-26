//
//  BeginRunVC.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-11.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lastRunView: UIView!
    
    @IBOutlet weak var runDate: UILabel!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
         setUpMapView()
    }
    
    func setUpMapView(){
        if let overlay = addLastRunToMap(){
         
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
        }
        else {
            lastRunView.isHidden = true
        }
    }
    
    func addLastRunToMap () -> MKPolyline?{
        guard let lastRun = Run.getAllRuns()?.first else {
            return nil
        }
        runDate.text = "Last Run: \(lastRun.date.getDateString())"
        pace.text = "Pace: \(lastRun.pace.formatTimeDurationToString())"
        distance.text = "Distance: \(lastRun.distance.metersToMiles(places: 2)) km"
        duration.text = "Duration: \(lastRun.duration.formatTimeDurationToString())"
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        lastRunView.isHidden = true
    }
    
    @IBAction func centerMapBtnPressed(_ sender: Any) {
    }
}

extension BeginRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let render = MKPolylineRenderer(polyline: polyline)
        render.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        render.lineWidth = 4
        return render
    }
}
