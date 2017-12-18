//
//  RegistrationViewController.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 09/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegistrationViewController: UIViewController {
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!

    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPsswd: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSerName: UITextField!
    @IBOutlet weak var textFieldSity: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    
    @IBAction func btnRegistration(_ sender: Any) {
        if textFieldName.text != "" && textFieldPsswd.text != "" && textFieldSity.text != "" && textFieldLogin.text != "" && textFieldPhone.text != "" && textFieldSerName.text != "" {
            request(baseURL + "/api/sign-up", method: .post, parameters: [
                "login":textFieldLogin.text!,
                "pass":textFieldPsswd.text! ,
                "name":textFieldName.text!,
                "family":textFieldSerName.text!,
                "city":textFieldSity.text!,
                "tel":textFieldPhone.text!]).validate().responseJSON{
                    responseJSON in
                    switch responseJSON.result {
                    case .success(_):
                        guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                      //  let result = jsonArray["news"] as! [AnyObject]
                        print(jsonArray)
                        if jsonArray["status"]! as! String != "Регистрация успешна" {
                            SingleTonUltimateBlood.shared.showAlert(title: jsonArray["status"] as! String, message: "", viewController: self)
                        }
                        else {
                            Profile.shared.setData(
                                login: self.textFieldLogin.text!,
                                pswd: self.textFieldPsswd.text!,
                                name: self.textFieldName.text!,
                                serName: self.textFieldSerName.text!,
                                phone: self.textFieldPhone.text!,
                                city: self.textFieldSity.text!,
                                id: jsonArray["id"] as! Int)
                                Profile.shared.sign = true
                            Profile.shared.Save()
                SingleTonUltimateBlood.shared.showAlert(title: jsonArray["status"] as! String, message: "", viewController: self)
                            self.performSegue(withIdentifier: "segue", sender: self)
                        }
                    case .failure(let error):
                        print("Error : ", error)
                    }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
