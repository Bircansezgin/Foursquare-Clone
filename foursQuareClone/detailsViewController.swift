//
//  detailsViewController.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 27.06.2023.
//

import UIKit
import MapKit
import Parse

class detailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsDiscriptionLabel: UILabel!
    let annotation = MKPointAnnotation()
    @IBOutlet weak var detailsMapView: MKMapView!
    var locationManager = CLLocationManager()
    var chosenPalceId = ""
    
    var chosenLatitude = Double()
    var chosenLonditude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFormParse()
        
      
        
        detailsMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        detailsMapView.showsUserLocation = true
    }
    
    // Map Button ekleme tiklama
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLonditude != 0.0{
            let requestLoaction = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLonditude)
            
            CLGeocoder().reverseGeocodeLocation(requestLoaction) { placesMark, error in
                if let placemark = placesMark{
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
            
        }
    }
    
    
    

    func getDataFormParse(){
        // ID gore CEKIYORUZ!
        let quary = PFQuery(className: "places")
        quary.whereKey("objectId", equalTo: chosenPalceId)
        quary.findObjectsInBackground { objects, error in
            if error != nil{
                
            }else{
                if objects != nil{
                    let chosenPlaceObject = objects![0]
                    if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                        self.detailsNameLabel.text = placeName
                    }
                    
                    if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                        self.detailsTypeLabel.text = placeType
                    }
                    
                    if let placeComment = chosenPlaceObject.object(forKey: "comment") as? String{
                        self.detailsDiscriptionLabel.text = placeComment
                    }
                    
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                        if let placeLatitudeDouble = Double(placeLatitude){
                            self.chosenLatitude = placeLatitudeDouble
                        }
                    }
                    
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitute") as? String{
                        if let placeLongitudeDobule = Double(placeLongitude){
                            self.chosenLonditude = placeLongitudeDobule
                        }
                    }
                    
                    if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                        imageData.getDataInBackground { data, error in
                            if error != nil{
                                
                            }else{
                                if data != nil{
                                    self.detailsImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    
                    // MAPS
                  
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLonditude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.030, longitudeDelta: 0.030)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    self.annotation.coordinate = location
                    self.annotation.title = self.detailsNameLabel.text
                    self.annotation.subtitle = self.detailsTypeLabel.text
                    self.detailsMapView.addAnnotation(self.annotation)
                }
            }
        }
    }
    
    
    

}//Class OUT!
