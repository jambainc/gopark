//
//  ParkingController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import ClusterKit

// MGLPointAnnotation subclass
class MyCustomPointAnnotation: MGLPointAnnotation {
    var bayid = -1
    var duration = -1
    var typeDesc = ""
}


class ParkingController: UIViewController, MGLMapViewDelegate {
    
    
    @IBOutlet weak var btnCenterUser: UIButton!
    @IBAction func btnCenterUser(_ sender: Any) {
        centerViewOnUserLocation()
    }
    var mapView: MGLMapView!
    let locationManager = CLLocationManager()
    let dispatchGroup = DispatchGroup()
    var api1Decodables: [API1Decodable]!
    var annotations = [MyCustomPointAnnotation]() // define an array to store annotation that need to be displayed
    var selectedAnnotation: MyCustomPointAnnotation?
    let CKMapViewDefaultAnnotationViewReuseIdentifier = "annotation"
    let CKMapViewDefaultClusterAnnotationViewReuseIdentifier = "cluster"
    var segueBayid = 0
    var segueDuration = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_title", comment: "")
        
        // Setup map view
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.delegate = self
        mapView.tintColor = UIColor(red: 117/255, green: 188/255, blue: 236/255, alpha: 1) // Set map user annotation style (light blue)
        view.addSubview(mapView)
        
        view.bringSubview(toFront: btnCenterUser)
        
        setClusterManager() //set up cluster manager
        checkLocationServices() // after the view is load, check the location service
        
        requestDataFromAPI1() //get data from API1
        //readDataFromFile() //read data from a json file
        
        dispatchGroup.notify(queue: .main){
            self.addParkingSignAnnotation() // add Annotations to the map
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){ // if location service is enabled
            locationManager.delegate = self // set up location manager delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest// set up location manager
            checkLocationAuthorization() // and check location authorization
        }else{
            // show an alert to ask user to turn on location service
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: // if have this permission,
            mapView.showsUserLocation = true // map display user's current location
            centerViewOnUserLocation() // center the screen to user location
            locationManager.startUpdatingLocation() //
            break
        case .denied: // if permission is denied, tell them how to do setting
            break
        case .notDetermined: // if permission is not determined, ask for 'authorizedWhenInUse' permission
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways: // do not do anything
            break
        }
    }
    
    func centerViewOnUserLocation(){
        // if the location of locationManager is not null, center the view to user location
        if let location = locationManager.location?.coordinate{
            mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 13, animated: true)
        }
    }
    
    func setClusterManager(){
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 300
        mapView.clusterManager.algorithm = algorithm
        mapView.clusterManager.marginFactor = 1
    }
    
    func readDataFromFile(){
        let path = Bundle.main.path(forResource: "map", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        //let jsons = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        //print(jsons)
        let api1Decodables = try! JSONDecoder().decode([API1Decodable].self, from: data)
        self.api1Decodables = api1Decodables
    }
    
    func requestDataFromAPI1(){
        //enter
        self.dispatchGroup.enter()
        
        let url = URL(string: "http://52.65.239.40/parking.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                if data == nil {
                    return
                }
                //let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                //print(jsons)
                
                //decode the data and store in an array call users
                let api1Decodables = try JSONDecoder().decode([API1Decodable].self, from: data!)
                //print(api1Decodables)
                self.api1Decodables = api1Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
        }.resume()
    }
    
    func addParkingSignAnnotation(){
        // loop through the parkingSignDecodables array
        for parkingSignDecodable in self.api1Decodables{
            //create annotation
            let myCustomPointAnnotation = MyCustomPointAnnotation()
            myCustomPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: parkingSignDecodable.lat, longitude: parkingSignDecodable.lon)
            // set callout title
            myCustomPointAnnotation.title = parkingSignDecodable.typedesc
            // set myCustomPointAnnotation added attributes
            myCustomPointAnnotation.bayid = parkingSignDecodable.bayid
            myCustomPointAnnotation.duration = parkingSignDecodable.duration
            myCustomPointAnnotation.typeDesc = parkingSignDecodable.typedesc
            // append the annotation to the array
            annotations.append(myCustomPointAnnotation)
        }
        // add annotations using the annotation array
        //mapView.addAnnotations(annotations)//do not use clustering
        mapView.clusterManager.annotations = annotations
    }
    
    
    // MARK: MGLMapViewDelegate
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let cluster = annotation as? CKCluster else {return nil}
        if cluster.count > 1 {
            return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier) ??
                MBXClusterView(annotation: annotation, reuseIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier, count: Int(cluster.count))
        }
        return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier) ??
            MBXAnnotationView(annotation: annotation, reuseIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        guard let cluster = annotation as? CKCluster else {return true}
        return cluster.count == 1 //如果count唯一，就允许callout
    }
    
    // MARK: - Change map language according to perfer language
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        style.localizeLabels(into: nil)
    }
    
    // MARK: - How To Update Clusters
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        mapView.clusterManager.updateClustersIfNeeded()
    }
    
    // MARK: - How To Handle Selection/Deselection
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let cluster = annotation as? CKCluster else {
            return
        }
        if cluster.count > 1 { //if count>1，zoom in
            let edgePadding = UIEdgeInsetsMake(200, 150, 200, 150) //40, 20, 44, 20
            let camera = mapView.cameraThatFitsCluster(cluster, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
        } else if let annotation = cluster.firstAnnotation { //if=1，select the annotation
            mapView.clusterManager.selectAnnotation(annotation, animated: false);
            let myCustomPointAnnotation = annotation as! MyCustomPointAnnotation // convert the Annotation back to MyCustomPointAnnotation
            selectedAnnotation = myCustomPointAnnotation //set to instance variable selectedAnnotation
            segueBayid = myCustomPointAnnotation.bayid
            segueDuration = myCustomPointAnnotation.duration
            performSegue(withIdentifier: "ParkingToPopupNavigaitonSegue", sender: nil) //popup ParkingPopupController
        }
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        guard let cluster = annotation as? CKCluster, cluster.count == 1 else {
            return
        }
        mapView.clusterManager.deselectAnnotation(cluster.firstAnnotation, animated: false);
    }
    
    // Unwill method. It is called when Navigate button of ParkingPopupController is clicked.
    @IBAction func unwillParkingPopupController(sender: UIStoryboardSegue){
        let originWaypoint = Waypoint(coordinate: mapView.userLocation!.coordinate, coordinateAccuracy: -1, name: "Origin")
        let destinationWaypoint = Waypoint(coordinate: selectedAnnotation!.coordinate, coordinateAccuracy: -1, name: "Destination")
        let navigationRouteOptions = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(navigationRouteOptions, completionHandler: { (waypoints, routes, error) in
            if (error == nil) {
                let navigationViewController = NavigationViewController(for:(routes?.first)!)
                self.present(navigationViewController, animated: true, completion: nil)
            }
        })
    }
    
    //this method is excuted only when the list from listController is clicked
    func showAnnotaitonSelectedFromList(bayid: Int) {
        for annotation in annotations {
            if annotation.bayid == bayid {
                mapView.clusterManager.selectAnnotation(annotation, animated: true)
                let location = annotation.coordinate
                mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 17, animated: true)
            }
        }
    }
    
     // MARK: - Navigation
     
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingToPopupNavigaitonSegue"
        {
            let parkingPopupNavigationController = segue.destination as? ParkingPopupNavigationController
            parkingPopupNavigationController?.selectedBayid = segueBayid
            parkingPopupNavigationController?.selectedDuration = segueDuration
        }
     }
    
}


// MARK: - Custom annotation view

class MBXAnnotationView: MGLAnnotationView {
    var imageView: UIImageView!
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let image = UIImage(named: "marker")
        imageView = UIImageView(image: image)
        addSubview(imageView)
        frame = imageView.frame
        isDraggable = true
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)
        switch dragState {
        case .starting:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = self.transform.scaledBy(x: 2, y: 2)
            })
        case .ending:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }
}

class MBXClusterView: MGLAnnotationView {
    init(annotation: MGLAnnotation?, reuseIdentifier: String?, count: Int?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let imageView = UIImageView(image: UIImage(named: "cluster")) //image view for icon
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 35)) //a label to display the count of parking spots
        label.text = String(count ?? 0) //set the text of the label
        label.font = label.font.withSize(12)
        label.adjustsFontSizeToFitWidth = true //allow frame to adjust size based on the length of text
        label.textAlignment = .center //set text center to label frame
        label.center = CGPoint(x: imageView.frame.size.width  / 2, y: imageView.frame.size.height / 2) //set label center to image view
        imageView.addSubview(label) //add ui view to image view.
        addSubview(imageView) //add image to mapview
        frame = imageView.frame
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}




extension ParkingController: CLLocationManagerDelegate{
    //This method deal with updating location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //guard let location = locations.last else {return} // if last location is the same (nil), the following code do not run
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) // if have new location, create a center according to the new location
        //mapView.setCenter(CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude), zoomLevel: 17, animated: true) // set center to the map. zoomLevel should be consistent with centerViewOnUserLocation()
    }
    
    // this method deal with the Authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // if the Authorization is changed, check which Authorization the user gives and handle each case accordingly
        checkLocationAuthorization()
    }
    
}
