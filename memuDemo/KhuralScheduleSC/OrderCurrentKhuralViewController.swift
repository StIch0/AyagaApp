//
//  OrderCurrentKhuralViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 08/09/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class OrderCurrentKhuralViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!    
    @IBOutlet var commentForStar: UILabel!
    @IBOutlet var summTaker: UITextField!
    var dateFormater = DateFormatter()
    var stringDatePicker : String = ""
    var khuralTitle : String = ""
    var khuralDate :  String = "" 
    
    @IBAction func orderKhuralButton(_ sender: Any) {
        //checkInputData
        //print("oooh, you tuch my tralala")
        
        if (fullNameTextField.text == "") {
            SingleTonUltimateBlood.shared.showAlert(title: "Обязательные поля заполнены не верно", message: "", viewController: self)
        }
        else {                
            dateFormater.dateFormat = "dd-MM-yyyy"
            stringDatePicker = dateFormater.string(from: datePicker.date)          
            StringSumm = summTaker.text!
            
            SingleTonUltimateBlood.shared.onPostTapped(API: "/order/create", parameters:[
                "name": fullNameTextField.text!,
                "date": stringDatePicker,
                "summ": summTaker.text!,
                "title": khuralTitle,
                "khuralDate": khuralDate]) 
            
                
                //JSONTaker.shared.showAlert(title: "Запрос на заказ хурала отправлен", message: "", viewController: self)
            
            
                performSegue(withIdentifier: "segueYan", sender: self)
            
            
            datePicker.setDate(NSDate() as Date, animated: true)
            fullNameTextField.text = ""
        }
        
        //yandex money
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        khuralTitle = StringLblText
//        khuralDate = StringDataField
        commentForStar.sizeToFit()
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        datePicker.maximumDate = Calendar.current.date(from: components)
        // Do any additional setup after loading the view.
        
        fullNameTextField.enablesReturnKeyAutomatically = true
        summTaker.keyboardType = UIKeyboardType.decimalPad
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        datePicker.maximumDate = Calendar.current.date(from: components)
        //datePicker.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }
}
