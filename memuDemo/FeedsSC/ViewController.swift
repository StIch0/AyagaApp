//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navBar: UINavigationItem!
    var limit : Int = 20
    var offset : Int = 0
    var paramDict : [[String:AnyObject]] = Array()
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()                                                                                                                        
        print("Name = ", Profile.shared.name)               
        
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
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))        
            
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

    }
 
    override func viewDidAppear(_ animated: Bool) {
        SingleTonUltimateBlood.shared.setStatusBarColorOrange()
        tableView.allowsSelection = true                                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramDict.count
    }
        
    var dataString: [String] = []
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("You selected name : "+((self.paramDict[indexPath.row]["date"])! as! String),indexPath.row," ",paramDict.count)        
        print("Dataaaaaaaa",(self.paramDict[indexPath.row]["title"] as? String)!,
              (self.paramDict[indexPath.row]["text"] as? String)!)
        SingleTonUltimateBlood.shared.StringLblText   =  (self.paramDict[indexPath.row]["title"] as? String)!
        SingleTonUltimateBlood.shared.StringText =  (self.paramDict[indexPath.row]["text"] as? String)!
        SingleTonUltimateBlood.shared.StringDataField =  (self.paramDict[indexPath.row]["date"] as? String)!
        SingleTonUltimateBlood.shared.postId = self.paramDict[indexPath.row]["post_id"] as! Int
        
        print ("Login    =     ", self.paramDict[indexPath.row]["user_login"] as? String)
        
        if ((self.paramDict[indexPath.row]["user_login"] as? String) == nil) {
            SingleTonUltimateBlood.shared.StringUserName = "###"
        }
        else {
            SingleTonUltimateBlood.shared.StringUserName = (self.paramDict[indexPath.row]["user_login"] as? String)!
        }
    
        
        SingleTonUltimateBlood.shared.StringImgURLs = (self.paramDict[indexPath.row]["images"] as? [String])
            
//        StringUrlImg    = (self.paramDict["image"]?[indexPath.row])!
        
//        cell.textLabel?.text = self.paramDict[indexPath.row]["title"] as? String
//        cell.dataTime.text = self.paramDict[indexPath.row]["date"] as? String
//        cell.shortText.text = self.paramDict[indexPath.row]["text"] as? String
//
//
//        
//        GlobalImg = cell.img.image
       // tableView.allowsSelection = false
        request(baseURL + "/api/set-view", method: .post, parameters: ["id":Profile.shared.id, "post_id": paramDict[indexPath.row]["post_id"]!]).validate().responseJSON{
                responseJSON in
            switch responseJSON.result{
            case .success(_): guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                if jsonArray["status"] as! String != "fail" {
//                    var ttt = Int(self.paramDict[indexPath.row]["views"] as! String)! + 1                     
//                    self.paramDict[indexPath.row]["views"] = String (ttt) as AnyObject
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
        
        cell.dateTime.text = paramDict[indexPath.row]["date"] as? String
        cell.titleText.text = paramDict[indexPath.row]["title"] as? String
        cell.shortText.text = paramDict[indexPath.row]["short"] as? String
        print ("VERRRRY SHOOOOORT TEEEEEEEXT !!!!!!!!   ", cell.shortText)
        cell.marksLbl.text = String(paramDict[indexPath.row]["mark"] as! Int)
        cell.cntViews.text = paramDict[indexPath.row]["views"] as? String
        cell.postId = String(paramDict[indexPath.row]["post_id"] as! Int)
        cell.userMark = paramDict[indexPath.row]["user_mark"] as! Int
        cell.loginText.titleLabel?.text = paramDict[indexPath.row]["user_login"] as? String
        
        //cell.imgHeightConstrait.constant = 0.0
        if (paramDict[indexPath.row]["images"] as? [String])!.count == 0 {
            cell.imgHeightConstrait.constant = 0.0
        }
        else {
            cell.imgHeightConstrait.constant = 400.0
            SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDict[indexPath.row]["images"]as![String])[0], img: cell.img)
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
                case .failure(let error):
                    print("Error : ", error)
                }

            }
            
        }
        
        return cell
    }

}

//https://www.youtube.com/watch?v=K1qrk6XOuIU
