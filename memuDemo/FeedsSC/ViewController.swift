//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UNUserNotificationCenterDelegate {
     @IBOutlet weak var mainIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBar: UINavigationItem!
    var limit : Int = 20
    var offset : Int = 0
    var IDD = 0
    var getReq = ""
    var notifSet = Set<String>()
    var paramDict : [[String:AnyObject]] = Array()
    let requestIdentifier = "SampleRequest"  
    var kindex = 0;
    var ctrlIndex = 0;

    @IBAction func gotoProfile(_ sender: UIButton) {
        SingleTonUltimateBlood.shared.UserID = Int(sender.accessibilityIdentifier!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()                  
        SingleTonUltimateBlood.shared.senderForMessageSegue = self
        print("Name = ", Profile.shared.name)
        
        if SingleTonUltimateBlood.shared.location == 0 {
            getReq = "/api/get-posts"
            navBar.title = "Новости"
            IDD = 0
        }
        else {
            getReq = "/api/get-sub-posts"
            navBar.title = "Лента подписок"
            IDD = Profile.shared.id
        }
        
        print (getReq, "     " , IDD)
        
        self.displaySpinner(onView: self.view)
        
        request(baseURL + getReq, method: .post, parameters: ["limit": limit, "offset" :offset,"user_id" : IDD]).responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                let result = jsonArray["news"] as! [AnyObject]
                self.paramDict = result as! [[String : AnyObject]]
                 //print (self.paramDict)
                self.removeSpinner(spinner: self.view.subviews.last)
                
                self.tableView.reloadData()
            case .failure(let error):
                print("Error : ", error)
             }            
        }
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))      
            
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        //SingleTonUltimateBlood.shared.huyoviyReval = revealViewController()
        Timer.scheduledTimer(timeInterval: 2.7, target: self, selector: #selector(load), userInfo: nil, repeats: true)
    }
 
    public func load (){
        request(baseURL + "/api/get-messages", method: .post, parameters:["id":Profile.shared.id]).validate(statusCode: 200..<600).responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                //  print(jsonArray)
                let result = jsonArray["messages"] as! [AnyObject]
                let paramDict = result as! [[String : AnyObject]]
                MessageContent.shared.messParam = result as! [[String : AnyObject]]
                                                
                for read in paramDict {                    
                    let rr = read["user_messages"] as! [[String : AnyObject]]             
                    
                    for msg in rr {                        
                        if (msg["is_readed"] as! Int) == 0 {
                          
                            if !(self.notifSet.contains((msg["date"] as? String ?? "##"))) {
                                if (msg["from_id"] as? Int ?? 0) != Profile.shared.id {
                                    self.notifSet.insert((msg["date"] as? String ?? "##"))
                                    let content = UNMutableNotificationContent()
                                    content.title = read["user_login"] as? String ?? "ERROR userlogin"
                                    content.subtitle = msg["date"] as? String ?? "ERROR date"
                                    content.body = msg["text"] as? String ?? "ERROR text"
                                    content.sound = UNNotificationSound.default()
                                    self.ctrlIndex = self.kindex
                                    // Deliver the notification in five seconds.                                
                                    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10.1, repeats: false)
                                    let request = UNNotificationRequest(identifier:self.requestIdentifier, content: content, trigger: trigger)                                                                
                                    
                                    print ("center  = ", UNUserNotificationCenter.current())
                                    
                                    UNUserNotificationCenter.current().delegate = self
                                    UNUserNotificationCenter.current().add(request) {(error) in                                   
                                        print (request)
                                        if (error != nil) {
                                            print("ERORRRO: ",error?.localizedDescription ?? "***")
                                        }
                                    }
                                }
                            }                                                                                    
                        }
                    }
                    
                    self.kindex += 1
                }                                            
                
            case .failure(let error):
                print("Error : ", error)
            }
        }
        print("Current ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SingleTonUltimateBlood.shared.setStatusBarColorOrange()
        tableView.allowsSelection = true       
        if SingleTonUltimateBlood.shared.location == 0 {
            getReq = "/api/get-posts"
            IDD = 0
        }
        else {
            getReq = "/api/get-sub-posts"
            IDD = Profile.shared.id
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramDict.count
    }
        
    var dataString: [String] = []
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell: FeedsCell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedsCell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell
        cell.indicator.hidesWhenStopped = true
        cell.indicator.startAnimating()
        cell.dateTime.text = paramDict[indexPath.row]["date"] as? String
        cell.titleText.text = paramDict[indexPath.row]["title"] as? String
        cell.shortText.text = paramDict[indexPath.row]["short"] as? String
        cell.marksLbl.text = String(paramDict[indexPath.row]["mark"] as! Int)
        cell.cntViews.text = paramDict[indexPath.row]["views"] as? String
        cell.postId = String(paramDict[indexPath.row]["post_id"] as! Int)
        cell.userMark = paramDict[indexPath.row]["user_mark"] as! Int
        cell.loginText.setTitle(paramDict[indexPath.row]["user_login"] as? String, for: .normal)
        cell.loginText.accessibilityIdentifier = String(paramDict[indexPath.row]["user_id"] as! Int)
        
//        print ("LIIIIIIIIIIIIIIIIIIKE  = " , paramDict[indexPath.row]["user_mark"])
        if paramDict[indexPath.row]["user_mark"] as! Int == 1 {
            cell.like.backgroundColor = .red
            cell.dislike.backgroundColor = .none
        }
        else  {
            if paramDict[indexPath.row]["user_mark"] as! Int == -1 {
                cell.dislike.backgroundColor = .red
                cell.like.backgroundColor = .none
                
            }
        }
        //cell.imgHeightConstrait.constant = 0.0
        if (paramDict[indexPath.row]["images"] as? [String])!.count == 0 {
            cell.imgHeightConstrait.constant = 0.0
            cell.indicator.stopAnimating()
            cell.indicator.hidesWhenStopped = true
        }
        else {
            cell.imgHeightConstrait.constant = 400.0
            SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDict[indexPath.row]["images"]as![String])[0], img: cell.img)
        }

        
        cell.shortTextViewHeightConstrait.constant = cell.shortText.contentSize.height
        cell.titleHeightConstrait.constant = cell.titleText.contentSize.height
        
        if indexPath.row == limit - 1 {
            offset=limit
            limit+=20
            request(baseURL + self.getReq, method: .post, parameters: ["limit": limit, "offset" :offset,"user_id" : self.IDD]).validate().responseJSON { (responseJSON)  in
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
                    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        SingleTonUltimateBlood.shared.index = self.ctrlIndex
        print ("ctrlIndex = ", ctrlIndex)
        
        (SingleTonUltimateBlood.shared.senderForMessageSegue as? UIViewController ?? UIViewController()).performSegue(withIdentifier: "messageSegue", sender: SingleTonUltimateBlood.shared.senderForMessageSegue)
        
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

//https://www.youtube.com/watch?v=K1qrk6XOuIU
