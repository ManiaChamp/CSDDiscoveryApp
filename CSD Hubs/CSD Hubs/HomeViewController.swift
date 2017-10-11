//
//  HomeViewController.swift
//  CSD Hubs
//
//  Created by Manish on 06/10/17.
//  Copyright © 2017 Manish Sharma. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import DesignSystem
import MapKit



class HomeViewController: UIViewController,MKMapViewDelegate {
    
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var spinner:PBLogoActivityIndicatorView?
    @IBOutlet weak var mapView:MKMapView?
    
    @IBOutlet weak var lblHeading:UILabel?
     @IBOutlet weak var lblStatus:UILabel?
    @IBOutlet weak var btnAction:UIButton?
    
    
    var isSearched:Bool = false
    
    var model:loginModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        spinner?.isHidden = true
      
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        
        lblStatus?.isHidden = true
        

        centerMapOnLocation(coordinates: (LocationManager.sharedLocationManager.currentLocation?.coordinate)!)
        
        
    }
    //18.5158,73.909
    
    func getRevereMapp(_ coordinate:CLLocationCoordinate2D,complettionHandler:@escaping (String, Error?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        let lcoation  = CLLocation(latitude:coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(lcoation) { (placemarks, error) in
            
            
            let placemark = placemarks?[0]
            
            let dict =  placemark?.addressDictionary
            
            
            let addressArr = dict?["FormattedAddressLines"] as! NSArray
            
            let address = addressArr.componentsJoined(by: " ,")
            
            complettionHandler(address,error)
            
        }
       
    }
    
    
    @IBAction func btnSearchClicked(_ sender:Any){
        
        
        
        if isSearched == false {
            spinner?.isHidden = false
            spinner?.startAnimating()
            
            var annotationArr = [AnnotationModel]()
            
            for csdDevice in  (model?.csds)!{
                
                let cordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(Float(csdDevice.latitude!)!) , longitude: CLLocationDegrees(Float(csdDevice.longitude!)!))
                
               
                 let annotaion = AnnotationModel.init(coordinate: cordinate, titleString: csdDevice.csd_id!, addressText: "")
                 annotationArr.append(annotaion)
            }
            
            
            
            dropMultiplePin(withInfo: annotationArr)
            isSearched = true
            
            btnAction?.setTitle("Send Request", for: UIControlState.normal)
            lblHeading?.text = "Send Shipping Request to nearest CSD"
        }
        else{
            
            let alertController = UIAlertController(title: "Send Shipping Request", message: "Please enter number of packages you want to send", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.placeholder = "Number of Packages"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                 let alertController1 = UIAlertController(title: "Send Shipping Request", message: "Request has been send successfully. Wait till CSD Owner confirms your shipping request", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                    
                    self.btnAction?.isHidden = true
                    self.lblHeading?.isHidden = true
                    self.lblStatus?.isHidden = false
                    self.lblStatus?.text = "Waiting for confirmation ......"
                }
                
                alertController1.addAction(cancelAction1)
                
                self.present(alertController1, animated: true, completion: nil)
                self.spinner?.isHidden = false
                self.perform(#selector(self.confirmation), with: self, afterDelay: 10.0)
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
     }
    
    
    
    
    func confirmation() -> Void {
        
        spinner?.isHidden = true
        
        let alertController1 = UIAlertController(title: "Shipping Confirmation", message: "Your shipping request has been approved. Please let us know the mode of tranport", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
             self.lblStatus?.text = "Shipping Order Confirmed"
            
            
            let alertActionSheet = UIAlertController (title: "Mode of Tranport", message: "Choose one mode of tranport for packages.", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let option1 = UIAlertAction(title: "Dropoff to CSD Hub", style: UIAlertActionStyle.default, handler: { (action) in
                
                self.spinner?.isHidden = false
                 let cordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(Float((self.model?.nearest?.latitude!)!)!) , longitude: CLLocationDegrees(Float((self.model?.nearest?.longitude!)!)!))
                
                self.getRevereMapp(cordinate, complettionHandler: { (address, error) in
                    
                 
                    self.spinner?.isHidden = true
                    
                    let alertController1 = UIAlertController(title: "Drop Off Address Details", message: address, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        
                          self.lblStatus?.text = String(format: "Drop to CSD Hub : %@", address)
                    }
                    
                    alertController1.addAction(cancelAction1)
                    
                    self.present(alertController1, animated: true, completion: nil)
                    
                })
                
                
            })
            
            let option2 = UIAlertAction(title: "Uber Rush", style: UIAlertActionStyle.default, handler: { (action) in
                self.spinner?.isHidden = false
                self.perform(#selector(self.uberconfirmation), with: self, afterDelay: 10.0)
                
            })
          
            alertActionSheet.addAction(option1)
            alertActionSheet.addAction(option2)

            self.present(alertActionSheet, animated: true, completion: nil)
            
        }
        
        alertController1.addAction(cancelAction1)
        
        self.present(alertController1, animated: true, completion: nil)
    }
    
    
    func uberconfirmation() -> Void {
        
        spinner?.isHidden = true
        
        let alertController1 = UIAlertController(title: "Uber Rush Confirmation", message: "Your pickup has been shechuled for 9 Oct 2017 at 1:00 PM. Taxi No.: BM 1456 # Color:Red # Driver Name: Jony # Phone no: 987226347", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
            self.lblStatus?.text = "Uber Rush Pickup has been scheduled"
        }
        
        alertController1.addAction(cancelAction1)
        
        self.present(alertController1, animated: true, completion: nil)
    }
    
    
    //MARK:- Common Methods
    
    func centerMapOnLocation(coordinates: CLLocationCoordinate2D)
    {
        //Running inside main queue just to compliment other methods that are below.
        DispatchQueue.main.async() {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates,
                                                                      self.regionRadius * 2.0, self.regionRadius * 2.0)
            self.mapView?.setRegion(coordinateRegion, animated: true)
        }
    }
    
    
    func didChangeLocation(userInfo:NSDictionary) -> Void {
        
    }
    
    public func dropMultiplePin(withInfo annotations:[AnnotationModel]) -> Void{
        
        var annotionsArray = [MKPointAnnotation]()
        for annotationInfo in annotations {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = annotationInfo.coordinates
            annotation.title = annotationInfo.title
            
            
            self.getRevereMapp(annotationInfo.coordinates, complettionHandler: { (address, error) in
                 annotation.subtitle =  address
                
                
            })
            
            annotionsArray.append(annotation)
        }
        mapView?.addAnnotations(annotionsArray)
        centerMapOnLocation(coordinates: annotations[0].coordinates)
        
        spinner?.isHidden = true
        
    }

    
    //MARK:- Annotation  Delegate
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            
            var marker  = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as MKAnnotationView!
            
            if marker == nil {
                marker =  MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
            }
            marker?.canShowCallout = true
            
            let bundle = Bundle(for:self.classForCoder)
            
            marker?.image = UIImage(named:"DS_CurrentLocation" , in: bundle, compatibleWith: nil)
            
            return marker
        }
        else{
            var marker  = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as MKAnnotationView!
            
            if marker == nil {
                marker =  MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
            }
            marker?.canShowCallout = true
            
            marker?.image = UIImage(named: "csd")
            return marker!
        }
        
    }
  
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
     
            return MKTileOverlayRenderer(tileOverlay: overlay as! MKTileOverlay)
        
        
    }
    
}
