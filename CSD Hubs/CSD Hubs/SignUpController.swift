//
//  SignUpController.swift
//  CSD Hubs
//
//  Created by Manish on 07/10/17.
//  Copyright © 2017 Manish Sharma. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignUpController: UIViewController {
    
    @IBOutlet weak var txtName:UITextField?
    
    @IBOutlet weak var txtEmail:UITextField?
  
    @IBOutlet weak var txtPassword:UITextField?
    
    @IBOutlet weak var txtPhone:UITextField?
 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title =  "Sign Up"
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
   
    
    @IBAction func btnSignUpClicked(_ sender:Any){
        
        let lattitude = String(format: "%f", (LocationManager.sharedLocationManager.currentLocation?.coordinate.latitude)!)
        let longitude = String(format: "%f", (LocationManager.sharedLocationManager.currentLocation?.coordinate.longitude)!)
        
        let uRL = URL(string: "http://lv426.7h2i2kmwqn.us-east-1.elasticbeanstalk.com/api/login")!
        
        let headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
      //  CSD200 | 18.5158   | 73.9272   |
        
        
        let dict = ["name": (txtName?.text)!,
                    "email": (txtEmail?.text)!,
                    "phone_number": (txtPhone?.text)!,
                    "password": (txtPassword?.text)!,
                    "latitude": lattitude,
        "longitude": longitude] as [String:String]
        
        Alamofire.request(uRL, method:HTTPMethod.post, parameters: dict, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            
            let json = response.result.value as? [String: Any]
            
            if ((json?["message"] as! String) == "Success"){
                
                let alertController1 = UIAlertController(title: "CSD SignUp", message: "Signed Up Successfully.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                    
                     self.navigationController?.popViewController(animated: true)
                }
                
                alertController1.addAction(cancelAction1)
                
                self.present(alertController1, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
}
