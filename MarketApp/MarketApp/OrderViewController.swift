//
//  OrderViewController.swift
//  MarketApp
//
//  Created by Furkan on 10.10.2022.
//

import UIKit
import MapKit
class OrderViewController: UIViewController {

    var products = [BasketElement]()
    var userRegLoc : MKCoordinateRegion?
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblBasketPrice: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblCargoPrice: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var locManager : CLLocationManager = CLLocationManager()
    var totalPrice = 0
    var cargoPrice = 20
    let request = MKLocalSearch.Request()
    var gestureZ : UILongPressGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationProperty()
        gestureZ = UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap))
        mapView.addGestureRecognizer(gestureZ!)
        getOrderTotal()
    }
    
    func getOrderTotal(){
        for product in products {
            totalPrice += Int(product.price!)!
        }
        lblBasketPrice.text = "Basket Price : \(totalPrice)$"
        lblCargoPrice.text = "Cargo Price : \(cargoPrice)$"
        totalPrice += cargoPrice
        lblTotal.text = "Total Price : \(totalPrice)$"
    }
    
    //loc manager searchbar map view properties
    func getLocationProperty(){
        searchBar.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    //Selected Location Add Annotations
    @objc func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        mapView.removeAnnotations(mapView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = locationCoordinate
        self.mapView.addAnnotation(pin)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
    }
    
    @IBAction func checkOutOrder(_ sender: Any) {
        var orders = ""
        for i in products{
            orders += "." + i.productId! + "-" + i.piece! + "."
        }
        var loc = ""
        
        if segmentedController.selectedSegmentIndex == 0 && self.mapView.annotations.count > 1{
            loc = String("\(self.mapView.annotations[1].coordinate.latitude) / \(self.mapView.annotations[1].coordinate.latitude)")
        }else if segmentedController.selectedSegmentIndex == 1{
            loc = String("\(self.userRegLoc!.center.latitude) - \(self.userRegLoc!.center.longitude)")
        }
        
        if loc != ""{
            addOrder(Orders: orders, UserId: User.userId!, Total: String(totalPrice),Location: loc)
            
                  let alertController = UIAlertController(title: "Order Succesfully", message: "your order will be sent to \(loc)", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .destructive, handler: { [self]_ in
                      print("Ok Button Clicked")
                      self.navigationController?.popViewController(animated: true)
                      for product in products {
                          delete2Basket(Id: product.id!, piece: "0")
                      }
                  })
                  alertController.addAction(okButton)
                  self.present(alertController, animated: true)
        }
  
    }
    
    func delete2Basket(Id:String,piece:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/setBasket.php")!)
        request.httpMethod = "POST"
        request.httpBody = "id=\(Id)&piece=\(piece)".data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
    
    func addOrder(Orders:String,UserId:String,Total:String,Location:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/addOrder.php")!)
        request.httpMethod = "POST"
        let params = "orders=\(Orders)&userId=\(UserId)&total=\(Total)&location=\(Location)"
        print(params)
        request.httpBody = params.data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
    
}

extension OrderViewController:UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate{
  
    //Searched Location
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        request.naturalLanguageQuery = searchBar.text!
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        let arama = MKLocalSearch(request: request)
        arama.start(completionHandler: { response,error in
            if error != nil{
                self.mapView.region = self.userRegLoc!
            }else if response?.mapItems.count == 0{
                self.mapView.region = self.userRegLoc!
            }else{
                if let region = response?.boundingRegion{
                    self.mapView.region = region
                }
            }
        })
    }
    
    // Current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoc : CLLocation = locations[locations.count-1]
        let place = CLLocationCoordinate2D(latitude: lastLoc.coordinate.latitude, longitude: lastLoc.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        userRegLoc = MKCoordinateRegion(center: place,span: span)
        mapView.setRegion(userRegLoc!, animated: true)
        mapView.showsUserLocation = true
    }
}
