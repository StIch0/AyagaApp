//
//  SettingsViewController.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 24/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import Toaster

class SettingsViewController: UIViewController {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var sur_name: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var birth_date: UITextField!
    @IBAction func changeBirth_date(_ sender: UITextField) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    func dateChanged (sender: UIDatePicker){
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .none
        dateFormater.dateFormat = "yyyy-MM-dd"
        birth_date.text = dateFormater.string(from: sender.date)
        dateFormater.date(from: birth_date.text!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var prifileIcon: UIImageView!
    @IBAction func loadImage(_ sender: Any) {
    }
    @IBAction func chgeDtaProfile(_ sender: Any) {
      // if textFieldName.text != "" && textFieldPsswd.text != "" && textFieldSity.text != "" && textFieldLogin.text != "" && textFieldPhone.text != "" && textFieldSerName.text != "" &&
            //textField.text != ""{
            request(baseURL + "/api/change-user-info", method: .post, parameters: [
                "id":Profile.shared.id,
                "pass": passwd.text!,
                "name":name.text!,
                "family":sur_name.text!,
                "city":city.text!,
                "birth_date":birth_date.text!,
                "image":"",
                "tel":phone.text!]).validate().responseJSON{
                    responseJSON in
                    switch responseJSON.result {
                    case .success(_):
                        guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                        //  let result = jsonArray["news"] as! [AnyObject]
                        print(jsonArray)
                        
                        if jsonArray["status"]! as! String == "OK" {
                            let e = Toast(text: "Изменения сохранились\nнеобходимо заново авторизоваться", duration: Delay.long)
                            e.show()
                          //SingleTonUltimateBlood.shared.showAlert(title: "Изменения сохранились\nнеобходимо заново авторизоваться", message: "", viewController: self)
                            Profile.shared.setData(
                                                            login: Profile.shared.login,
                                                            pswd: self.passwd.text!,
                                                            name: self.name.text!,
                                                            serName: self.sur_name.text!,
                                                            phone: self.phone.text!,
                                                            city: self.city.text!,
                                                            birth_date: self.birth_date.text!,
                                                            id: Profile.shared.id)
                                                        Profile.shared.sign = true
                                                        Profile.shared.Save()
                            print ("Profile.shared.login",Profile.shared.login)
                            self.performSegue(withIdentifier: "segue", sender: self.self)
                        }
                        else {
                              
                            SingleTonUltimateBlood.shared.showAlert(title: "Проверте точность введенных данных (eps = 1e-10)", message: "", viewController: self)
                         //   self.performSegue(withIdentifier: "segue", sender: self)
                     
                        }
                    case .failure(let error):
                        print("Error : ", error)
                    }
            }
            
        //}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleTonUltimateBlood.shared.senderForMessageSegue = self
        name.text = Profile.shared.name
        sur_name.text = Profile.shared.serName
        city.text = Profile.shared.city
        phone.text = Profile.shared.phone
        birth_date.text = Profile.shared.birth_date
       
        print ("Profile.shared.name" , Profile.shared.name)
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))      
            
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
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
