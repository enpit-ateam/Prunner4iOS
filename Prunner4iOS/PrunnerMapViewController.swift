//
//  PrunnerMapViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/18.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import GooglePlacePicker
import CoreLocation
import SwiftyJSON

import APIKit

class PrunnerMapViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var placePicker: GMSPlacePicker?
    var placeClient: GMSPlacesClient?
    
    // distance valuewill send distanceTextField
    var distance: NSString = ""
    
    @IBOutlet weak var mapView: PrunnerMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.clear()
        
        placeClient = GMSPlacesClient()
        // 位置情報サービスが利用できるかどうかをチェック
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            // 測位開始
            locationManager?.startUpdatingLocation()
        }
        mapView.isMyLocationEnabled = true
        
        // mapの設定
        // TODO:
        //  なぜかMakerが表示されない
        setMapView(from: distance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMapView(from distance: NSString) {
        // Cameraの設定
        let zoom = 20 - log2(distance.doubleValue/10)
        let camera = GMSCameraPosition.camera(withLatitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude, zoom: Float(zoom))
        mapView.camera = camera
        
        // Placeを取得してmapに表示させる
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = GMPlaceRequest.NearBySearch()
        request.queryParameters = [
            "key": appDelegate.apiKey as AnyObject,
            "location": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude) as AnyObject,
            "radius": distance as AnyObject
        ]
        Session.send(request) { result in
            switch result {
            case .success(let response):
                let places = response
                places.forEach{(place) in
                    let  position = CLLocationCoordinate2DMake((place.geometry.location.lat)!, (place.geometry.location.lng)!)
                    let marker = GMSMarker(position: position)
                    marker.title = place.name
                    marker.map = self.mapView
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, zoom: mapView.camera.zoom)
        mapView.camera = camera
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
