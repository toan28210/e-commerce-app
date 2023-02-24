//
//  MapViewController.swift
//  AppDATN
//
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func getAddress(quan: String, huyen: String, city: String)
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: MapViewControllerDelegate?
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared().getLocation(from: "My An, Ngu Hanh Son, Viet Nam") { location in
            if let location = location {
                let latitude = location.latitude
                let longitude = location.longitude
                let locationn: CLLocation = .init(latitude: latitude, longitude: longitude)
                self.center(location: locationn)
                
            }
            
        }
        
    }
    func center(location: CLLocation) {
            mapView.setCenter(location.coordinate, animated: true)
        //zoom
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        self.addAnnotation(location: location)
        }

    @IBAction func movetoCurrentLocaltion(_ sender: Any) {
        LocationManager.shared().getCurrentLocation { location in
            print(location)
            self.center(location: location)
        }
//        LocationManager.shared().getCurrentLocation { (location) in
//            print("Location: ",location)
//            self.center(location: location)
//        }
    }
    
    func addAnnotation(location: CLLocation) {
            let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            annotation.title = ""
            annotation.subtitle = ""
        LocationManager.shared().getAddressFromLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { address, error in
            if error != nil {
                print(error ?? "")
            } else if let address = address {
                let addressFull = address.components(separatedBy: ", ")
                self.delegate?.getAddress(quan: addressFull[1], huyen: addressFull[2], city: addressFull[3])
                let navigation = UpdateAddressViewController()
                navigation.quan = addressFull[1]
                navigation.huyen = addressFull[2]
                navigation.city = addressFull[3]
                self.navigationController?.pushViewController(navigation, animated: true)
            }
        }
            mapView.addAnnotation(annotation)
        }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.animatesDrop = true
        pin.pinTintColor = .red
        
        return pin
    }
}
