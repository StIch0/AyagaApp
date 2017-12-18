//
//  DevelopersViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 02/09/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ProfileViewController: UIViewController {
    
    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var textFieldPasswd: UITextField!
    @IBOutlet weak var textFieldLogin: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()                                
        
        if revealViewController() != nil {                                    
            btnMenuButton.target = revealViewController()                        
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))                                            
        }
        if Profile.shared.sign {
         // let defautls = UserDefaults.standard
           // print(UserDefaults.standard.string(forKey: "login")!)
//            textFieldPasswd.text = defautls.string(forKey: "pswd")
//            textFieldLogin.text = defautls.string(forKey: "login")
            performSegue(withIdentifier: "segueProfile", sender: self)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnLogin(_ sender: Any) {
        if textFieldLogin.text != "" && textFieldPasswd.text != "" {
            request(baseURL + "/api/sign-in", method: .post, parameters: [
                "login":textFieldLogin.text!,
                "pass":textFieldPasswd.text!]).responseJSON{
                        responseJSON in
                    switch responseJSON.result{
                    case .success(_):
                        guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                          if jsonArray["status"]! as! String != "ОК" {
                            SingleTonUltimateBlood.shared.showAlert(title: jsonArray["status"] as! String, message: "", viewController: self)
                          }else {
                            Profile.shared.id = jsonArray["id"]! as! Int
                            Profile.shared.sign = true
                            self.performSegue(withIdentifier: "segueProfile", sender: self)
                        }
                    case .failure(let error):
                        print("Error = ", error)
                    }
            }
            print("Succes")
           // performSegue(withIdentifier: "segueNews", sender: self)
        }
    }
    @IBAction func btnReg(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: self)
        
    }
    
}
