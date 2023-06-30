//
//  MapsAddViewController.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 27.06.2023.
//

import UIKit
import MapKit
import Parse
class MapsAddViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        loading.isHidden = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveClick))
        
        let isAlertShown = UserDefaults.standard.bool(forKey: "isAlertShown")
        
        if isAlertShown == false {
            makeAlerts(title: "Warning", message: "Press and hold for 3 seconds to Mark on the Map")
            UserDefaults.standard.set(true, forKey: "isAlertShown")
        }
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }// ViewDidLoad Finish!
    
    @objc func chooseLocation(gestureRecognizer: UITapGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            // Tiklanilan Noktalari almak
            let touches = gestureRecognizer.location(in: self.mapView)
            // Tiklanilan yeri Kordinata cevirmek
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            // Kordinatlari Almak!
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
            
        }
    }
    
    @objc func saveClick(){
        
        //Verileri Kaydetmek!
        let placeModel = PlaceModel.sharedInstance
        
        let dimView = UIView(frame: UIScreen.main.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView.alpha = 0.5
        self.view.addSubview(dimView)

        
       let object = PFObject(className: "places")
        object["accountUser"] = placeModel.accountName
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["comment"] = placeModel.placeComment
        object["latitude"] = placeModel.placeLatitude
        object["longitute"] = placeModel.placeLongitude
        
       // Gorsel icin Data cevirmek gerek
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
         
            self.loading.startAnimating()
            self.loading.isHidden = false
            
            object.saveInBackground { success, error in
            DispatchQueue.main.async{
                if error != nil{
                    self.loading.isHidden = true
                    dimView.removeFromSuperview()
                    self.makeAlerts(title: "Error", message: "\(String(describing: error?.localizedDescription))")
                }else{
                    self.performSegue(withIdentifier: "goBack", sender: nil)
                }
            }
        }
    }
 
 
}// class Finish


extension MapsAddViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    func makeAlerts(title:String, message:String){
        let alerts = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default)
        alerts.addAction(okButton)
        self.present(alerts, animated: true)
    }
}
