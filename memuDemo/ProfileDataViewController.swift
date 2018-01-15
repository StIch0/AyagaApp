//
//  ProfileDataViewController.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 10/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ProfileDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet var navItem: UINavigationItem!
    var FirstTimeLoaded : Bool = false
    
    @IBAction func subscribe(_ sender: UIButton) {
        print("нажал на кнопку label == ",(sender.titleLabel?.text!)!)
        
        if sender.titleLabel?.text == "Подписаться" {
            Subscribe()
            sender.setTitle("Отписаться", for: .normal)
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
                        //котлеты навернулись
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
            
            sender.setTitle("Подписаться", for: .normal)
            
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
    func UnScribe(btn: UIButton) -> Void {
        print(SingleTonUltimateBlood.shared.UserID)
        request(baseURL + "/api/del-subscribe",method: .post, parameters : ["user_id":Profile.shared.id,"author_id":SingleTonUltimateBlood.shared.UserID]).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                if jsonArray["status"] as! String == "OK"{
                    print("(Unsbscribe)вы  были подписаны на этого пользователя")
                    print("(Unsbscribe)вы  отписались от этого пользователя")
                    self.Subscribe()
                    btn.setTitle("Отписаться", for: .normal)
                    
                    //print("label == ",(self.subscrideBtn.titleLabel?.text!)!)
                    
                }
                else {
                    print("(Unubscribe) вы не были подписаны на этого пользователя")
                    btn.setTitle("Подписаться", for: .normal)
                    //self.subscrideBtn.titleLabel?.text = "Отписаться"
                    
                }
            case .failure(let error):
                print("Error : ", error)
            }
            
            
            
        }
    }            
    
    var lblName:    String = ""
    var lblPhone:   String = ""
    var lblSerName: String = ""
    var lblSubNum:  String = ""
    var lblCity:    String = ""
    var lblDate:    String = ""
    var textMessage : String = "0"
    var limit : Int = 20
    var offset : Int = 0
    var paramDict : [[String:AnyObject]] = Array()
    
   // @IBOutlet var textMessage: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBAction func btnDeleteFeed(_ sender: UIButton) {
        let post_id : Int = Int(sender.accessibilityHint!)!
        let index : Int = Int(sender.accessibilityLabel!)!
        let idxPath = IndexPath(row: index-1, section: 0) 
        request(baseURL + "/api/del-post", method: .post, parameters: ["id":post_id]).responseJSON{ responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                //  let result = jsonArray["news"] as! [AnyObject]
                print(jsonArray)//я думал, что резалт 0_о
                if jsonArray["status"]! as! String != "ОК" {
                    self.paramDict.remove(at: index - 1)
                    
                    self.tableView.deleteRows(at: [idxPath], with: .left)
                    self.tableView.reloadData()  
                }
                
                break
            case .failure(let error):
                print("Error : ", error)
            }
        }
    }
    
    @IBAction func exitBtn(_ sender: UIButton) {
        Profile.shared.sign = false
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "sign")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        request(baseURL + "/api/user-info", method: .post, parameters: ["id":SingleTonUltimateBlood.shared.UserID]).responseJSON{ responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                //  let result = jsonArray["news"] as! [AnyObject]
                print(jsonArray)
                if jsonArray["status"]! as! String != "ОК" {
                    SingleTonUltimateBlood.shared.showAlert(title: jsonArray["status"] as! String, message: "", viewController: self)
                }
                else {
                    self.lblName = (jsonArray["name"]! as? String)!
                    self.lblSerName = (jsonArray["family"]! as? String)!
                    self.lblPhone = "Телефон: " + (jsonArray["tel"]! as! String)
                    self.lblCity = "Город: " + (jsonArray["city"]! as! String)
                    self.lblSubNum = "Подписчиков: " + (jsonArray["sub_num"]! as! String)
                    self.lblDate = "Дата Рождения: " + (jsonArray["birth_date"]! as! String)
                    Profile.shared.sub_num = (jsonArray["sub_num"]! as? String)!
                    Profile.shared.Save()
                }
                break
            case .failure(let error):
                print("Error : ", error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleTonUltimateBlood.shared.senderForMessageSegue = self
        
        if SingleTonUltimateBlood.shared.location == 1 {
           SingleTonUltimateBlood.shared.UserID = Profile.shared.id 
        }
                
        
        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SingleTonUltimateBlood.shared.setStatusBarColorOrange()
        tableView.allowsSelection = true                                
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell: FeedsCell2 = tableView.dequeueReusableCell(withIdentifier: "FeedsCell2", for: indexPath) as! FeedsCell2
        print("You selected name : "+((self.paramDict[indexPath.row]["date"])! as! String),indexPath.row," ",paramDict.count)        
        //        print("Dataaaaaaaa",(self.paramDict[indexPath.row]["title"] as? String)!,
        //              (self.paramDict[indexPath.row]["text"] as? String)!)
        SingleTonUltimateBlood.shared.StringLblText   =  (self.paramDict[indexPath.row]["title"] as? String)!
        SingleTonUltimateBlood.shared.StringText =  (self.paramDict[indexPath.row]["text"] as? String)!
        SingleTonUltimateBlood.shared.StringDataField =  (self.paramDict[indexPath.row]["date"] as? String)!
        SingleTonUltimateBlood.shared.postId = self.paramDict[indexPath.row]["post_id"] as! Int
        SingleTonUltimateBlood.shared.StringMarks = String(self.paramDict[indexPath.row]["mark"] as! Int)
        //        print ("Login    =     ", self.paramDict[indexPath.row]["user_login"] as? String)
        SingleTonUltimateBlood.shared.IntUser_Marks = (self.paramDict[indexPath.row]["user_mark"] as! Int)
        if ((self.paramDict[indexPath.row]["user_login"] as? String) == nil) {
            SingleTonUltimateBlood.shared.StringUserName = "###"
        }
        else {
            SingleTonUltimateBlood.shared.StringUserName = (self.paramDict[indexPath.row]["user_login"] as? String)!
        }
        
        SingleTonUltimateBlood.shared.UserID = self.paramDict[indexPath.row]["user_id"] as! Int
        SingleTonUltimateBlood.shared.StringImgURLs = (self.paramDict[indexPath.row]["images"] as? [String])
        
        request(baseURL + "/api/set-view", method: .post, parameters: ["id":Profile.shared.id, "post_id": paramDict[indexPath.row]["post_id"]!]).validate().responseJSON{
            responseJSON in
            switch responseJSON.result{
            case .success(_): guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
            if jsonArray["status"] as! String != "fail" {
                cell.cntViews.text = String(Int(self.paramDict[indexPath.row]["views"] as! String)! + 1)
                }
            case .failure(let error): print("Error = ",error)
                
            }
            
        }
        SingleTonUltimateBlood.shared.StringVisibleCnt = paramDict[indexPath.row]["views"] as! String
        //print(paramDict.count, "in select")
        performSegue(withIdentifier: "segue", sender: self)                       
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {        
        if indexPath.row == 0 {
            let cell: ProfileDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileDataTableViewCell", for: indexPath) as! ProfileDataTableViewCell
            
            cell.lblCity.text = self.lblCity
            cell.lblDate.text = self.lblDate
            cell.lblName.text = self.lblName
            cell.lblPhone.text = self.lblPhone
            cell.lblSubNum.text = self.lblSubNum
            cell.lblSerName.text = self.lblSerName
            
            self.UnScribe(btn: cell.subscribe)
            
            textMessage = cell.textMessage.text!
            if textMessage == "" {
                cell.textMessage.text! = ""
            }
            if (SingleTonUltimateBlood.shared.UserID == Profile.shared.id) {
                cell.subscribe.isHidden = true
                cell.btnStartDialog.isHidden = true
                cell.textMessage.isHidden = true
                navItem.title = "Мой профиль"
            }
            else {
                navItem.title = "Профиль " + (cell.lblName.text ?? "ERROR")
                cell.btnExit.isHidden = true
            }
            
            if FirstTimeLoaded == false {
                FirstTimeLoaded = true
                request(baseURL + "/api/get-posts", method: .post, parameters: ["limit": limit, "offset" :offset,"user_id" : Profile.shared.id ]).validate().responseJSON { (responseJSON)  in
                    switch responseJSON.result {
                    case .success(_):
                        guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                        let result = jsonArray["news"] as! [AnyObject]
                        self.paramDict = result as! [[String : AnyObject]]
                        print (self.paramDict)
                        
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error : ", error)
                    }
                    
                }
            }
            
            return cell
        }
        let cell: FeedsCell2 = tableView.dequeueReusableCell(withIdentifier: "FeedsCell2", for: indexPath) as! FeedsCell2
        cell.indicator.hidesWhenStopped = true
        cell.indicator.startAnimating()
        
        var idx = indexPath.row - 1
        
        cell.dateTime.text = paramDict[idx]["date"] as? String
        cell.titleText.text = paramDict[idx]["title"] as? String
        cell.shortText.text = paramDict[idx]["short"] as? String
        print ("VERRRRY SHOOOOORT TEEEEEEEXT !!!!!!!!   ", cell.shortText)
        cell.marksLbl.text = String(paramDict[idx]["mark"] as! Int)
        cell.cntViews.text = paramDict[idx]["views"] as? String
        cell.postId = String(paramDict[idx]["post_id"] as! Int)
        cell.userMark = paramDict[idx]["user_mark"] as! Int
        cell.loginText.setTitle(paramDict[idx]["user_login"] as? String, for: .normal)
        cell.btnDelete.accessibilityHint = cell.postId
        cell.btnDelete.accessibilityLabel = String(indexPath.row)        
        
        //cell.imgHeightConstrait.constant = 0.0
        if (paramDict[idx]["images"] as? [String])!.count == 0 {
            cell.imgHeightConstrait.constant = 0.0
            cell.indicator.stopAnimating()
            cell.indicator.hidesWhenStopped = true
        }
        else {
            cell.imgHeightConstrait.constant = 400.0
            SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDict[idx]["images"]as![String])[0], img: cell.img)
        }
        //        SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDict[indexPath.row]["images"]as!Array)[0], img: cell.img)
        
        //        else {
        //            SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDict[indexPath.row]["images"]as!Array)[0], img: cell.img)
        //        }
        
        cell.shortTextViewHeightConstrait.constant = cell.shortText.contentSize.height
        cell.titleHeightConstrait.constant = cell.titleText.contentSize.height
        cell.shortText.sizeToFit()   
        cell.titleText.sizeToFit()
        cell.dateTime.sizeToFit()
        cell.img.sizeToFit()
        
        if indexPath.row == limit - 1 {
            offset=limit
            limit+=20
            request(baseURL + "/api/get-posts", method: .post, parameters: ["limit": limit, "offset" :offset,"user_id" :Profile.shared.id]).validate().responseJSON { (responseJSON)  in
                switch responseJSON.result {
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    let result = jsonArray["news"] as! [AnyObject]
                    //                    var newParamDict = result as! [[String : AnyObject]]
                    //                    
                    //                    for var s in newParamDict {
                    //                        self.paramDict.append(s)
                    //                    } 
                    self.paramDict.append(contentsOf: result as! [[String : AnyObject]])
                    
                    self.tableView.reloadData()
                    cell.indicator.stopAnimating()
                case .failure(let error):
                    print("Error : ", error)
                    cell.indicator.stopAnimating()
                }
                
            }
            
        }
        
        return cell            
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + paramDict.count
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
