//
//  LoginViewController.swift
//  CSD Hubs
//
//  Created by Manish on 06/10/17.
//  Copyright © 2017 Manish Sharma. All rights reserved.
//

import Foundation
import DesignSystem
import Alamofire
import CoreLocation

class LoginViewController:UIViewController,PBLoginViewControllerDelegate {
    
    var login:PBLoginViewController = PBLoginViewController(header: "CSD Discovery", andTouchIdEnable: false)
    var _navSet:Bool = false;
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LocationManager.sharedLocationManager.instantiate()
        

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.setupNavBar();
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
        self.login.delegate = self;
        
        let background: CAGradientLayer = PBGradientLayer.pbHeaderGradient(PBHeaderGradient1);
        background.setPBGradientType(LinearHorizontal);
        
        login.productTagLine = "One Step away from sending packages"
        login.setBackgroundGradient(background);
        login.theme = PBLightLoginTheme;
        login.addCredential("Email", message: "CSD Hubs Sign in", andFieldPlaceholder: "Email");
        login.addCredential("Password", message: "Enter your password", andFieldPlaceholder: "Password", withSecureText: true);
            
        self.view.addSubview(login.view);

        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    func setupNavBar(){
        
        if (_navSet){
            return;
        }
        
        let gradient = PBGradientLayer.pbHeaderGradient(PBHeaderGradient1) as CAGradientLayer;
        gradient.setPBGradientType(LinearHorizontal);
        let status = CALayer() as CALayer;
        
        let frame = self.navigationController!.navigationBar.layer.frame;
        gradient.frame = CGRect(x: 0, y: -20, width: frame.size.width, height: frame.height+20);
        status.frame = CGRect(x: 0, y: -20, width: frame.size.width, height: 20);
        status.backgroundColor = UIColor.black.withAlphaComponent(0.15).cgColor;
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.layer.insertSublayer(status, at: 0);
        self.navigationController?.navigationBar.layer.insertSublayer(gradient, at: 0);
        
        _navSet = true;
    }
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
   
    
    
    // MARK: - PBLoginView Delegate Methods

    
    
    func loginViewController(_ loginViewController: PBLoginViewController!, authenticateCredentials creds: [Any]!){
        
        let userInput = (creds[0] as AnyObject).object(forKey: "input") as!  String;
        let passInput = (creds[1] as AnyObject).object(forKey: "input") as!  String;
        
        let uRL = URL(string: "http://lv426.7h2i2kmwqn.us-east-1.elasticbeanstalk.com/api/nearest-csd")!
        
        let headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        let dict = [
            "latitude":"51.515",
            "longitude": "7.453619",
            "email": userInput,
            "password": passInput
            ]
        
        Alamofire.request(uRL, method:HTTPMethod.post, parameters: dict, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            
            let json = response.result.value as? [String: Any]
            
            if ((json?["message"] as! String) == "Success"){
                
                let loginmodel = loginModel.init(dictionary: response.result.value as! NSDictionary)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let homeViewCon = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                homeViewCon?.model = loginmodel
                self.navigationController?.pushViewController(homeViewCon!, animated: true);
                
            }
            else if ((json?["message"] as! String) == "UNAUTHORIZED ACCESS"){
             
                let alertView = UIAlertController(title: "UNAUTHORIZED ACCESS", message: "No User Found", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                
                self.present(alertView, animated: true, completion: nil)

            }
            
        })
        
    }
    
    
    func loginViewController(_ loginViewController: PBLoginViewController!, forgotWithCredentials creds: [Any]!) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let forgotPassView = storyBoard.instantiateViewController(withIdentifier: "forgotPasswordID");
        self.navigationController?.pushViewController(forgotPassView, animated: true);
    }
    
    func loginViewController(_ loginViewController: PBLoginViewController!, signUpWithCredentials creds: [Any]!) {
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let signUpController = storyBoard.instantiateViewController(withIdentifier: "SignUpController");
        self.navigationController?.pushViewController(signUpController, animated: true);

        
      
        
    }
    
    // MARK: - PBSignUpView Delegate Methods
    
    
   
    
    
}
