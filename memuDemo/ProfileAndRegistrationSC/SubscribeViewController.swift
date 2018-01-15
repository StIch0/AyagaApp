//
//  SubscribeViewController.swift
//  appAyaga
//
//  Created by Dugar Badagarov on 24/12/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import  Alamofire
class SubscribeViewController: UIViewController { 
    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    @IBAction func subscribe(_ sender: Any) {
        print("нажал на кнопку label == ",(self.subscribe.titleLabel?.text!)!)
       
        if subscribe.titleLabel?.text == "Подписаться" {
            Subscribe()
            self.subscribe.setTitle("Отписаться", for: .normal)
        }
        else
        {
            request(baseURL + "/api/del-subscribe",method: .post, parameters : ["user_id":Profile.shared.id,"author_id":SingleTonUltimateBlood.shared.UserID]).validate().responseJSON { (responseJSON)  in
                switch responseJSON.result {
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                    if jsonArray["status"] as! String == "OK"{
                        print("(UnsbscribeBtn)вы  отписались от этого пользователя")
                        //self.subscribe()
                        // print("label == ",(self.subscrideBtn.titleLabel?.text!)!)
                        
                    }
                    else {
                        print("(Unubscribe) вы не были подписаны на этого пользователя")
                        //self.subscrideBtn.setTitle("Подписаться", for: .normal)
                        //self.subscrideBtn.titleLabel?.text = "Отписаться"
                        
                    }
                case .failure(let error):
                    print("Error : ", error)
                }                                
                
            }
            
            self.subscribe.setTitle("Подписаться", for: .normal)
            
        }
    }
    func Subscribe (){
        // var foo = true
        request(baseURL + "/api/add-subscribe",method: .post, parameters : ["user_id":Profile.shared.id ,"author_id":SingleTonUltimateBlood.shared.UserID]).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                if jsonArray["status"] as! String == "OK"{
                    print("(Subscribe)вы подписались на этого пользоваеля")
                    // foo = false
                    //}
                }
                else {
                    print("(Subscribe)вы были подписаны на этого пользователя ")
                    //self.subscrideBtn.setTitle("Отписаться", for: .normal)
                    
                }
            case .failure(let error):
                print("Error : ", error)
            }
            
            
            
        }
    }
    func UnScribe() -> Void {
        print(SingleTonUltimateBlood.shared.UserID)
        request(baseURL + "/api/del-subscribe",method: .post, parameters : ["user_id":Profile.shared.id,"author_id":SingleTonUltimateBlood.shared.UserID]).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                if jsonArray["status"] as! String == "OK"{
                    print("(Unsbscribe)вы  были подписаны на этого пользователя")
                    print("(Unsbscribe)вы  отписались от этого пользователя")
                    self.Subscribe()
                    self.subscribe.setTitle("Отписаться", for: .normal)
                    
                    //print("label == ",(self.subscrideBtn.titleLabel?.text!)!)
                    
                }
                else {
                    print("(Unubscribe) вы не были подписаны на этого пользователя")
                    self.subscribe.setTitle("Подписаться", for: .normal)
                    //self.subscrideBtn.titleLabel?.text = "Отписаться"
                    
                }
            case .failure(let error):
                print("Error : ", error)
            }
            
            
            
        }
    }
    

    @IBOutlet var subscribe: UIButton!
    @IBOutlet var sub_num: UILabel!
    @IBOutlet var City: UILabel!
    @IBOutlet var SurName: UILabel!
    @IBOutlet var birthDate: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))        
            
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        
        request(baseURL + "/api/user-info", method: .post, parameters: ["id":SingleTonUltimateBlood.shared.UserID]).responseJSON{ responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                print(jsonArray)
                if jsonArray["status"]! as! String == "ОК" {
                    self.name.text = (jsonArray["name"]! as? String)!
                    self.SurName.text = (jsonArray["family"]! as? String)!
                    self.phone.text = "Телефон: " + (jsonArray["tel"]! as! String)
                    self.City.text =  "Город: " + (jsonArray["city"]! as! String)
                    self.sub_num.text = "Подписчиков: " + (jsonArray["sub_num"]! as! String)
                    self.birthDate.text = "Дата Рождения: " + (jsonArray["birth_date"]! as! String)
                }
            case .failure(let error):
                print("Error : ", error)
            }
        // Do any additional setup after loading the view.
        }
      
        UnScribe()
        
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
