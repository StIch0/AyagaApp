//
//  LecturesTableViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 29/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class FollowsNewsTableViewController: UITableViewController {

    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    var paramDict : [[String:AnyObject]] = Array()

   // var paramDict:[String:[String]] = Dictionary()
    var pagParamDict:[String:[String]] = Dictionary()
    var cntNews = 100000;
    var prevPage = ""
    var allLoaded = false
    var limit : Int = 20
    var offset : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }             
        request(baseURL + "/api/get-sub-posts", method: .post, parameters: ["limit": limit, "offset" :offset,"user_id" : Profile.shared.id]).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                let result = jsonArray["news"] as! [AnyObject]
                self.paramDict = result as! [[String : AnyObject]]
                self.tableView.reloadData()
            case .failure(let error):
                print("Error : ", error)
            }
            
        }

//        paramDict = SingleTonUltimateBlood.shared.loadData(API: "lectures?page=\(cntNews)", paramNames: ["id","title","date", "short",  "image", "text"])
//        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
//            cntNews = Int((paramDict["id"]?[0])!)!
//        }
//        
//        var ы = cntNews%20
//        
//        if (ы > 0) {ы = 1;}
//        
//        cntNews = cntNews/20 + ы
//        
//        paramDict["id"]!.reverse()
//        paramDict["title"]!.reverse()
//        paramDict["date"]!.reverse()
//        paramDict["short"]!.reverse()
//        paramDict["image"]!.reverse()
//        paramDict["text"]!.reverse()
//        
//        cntNews = cntNews - 1
        
            //loadAstrologicalData(baseURL: "file:///Users/dugar/Downloads/feed.json")
            //print (paramDict)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramDict.count
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.allowsSelection = true

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected name : "+(self.paramDict["date"]?[indexPath.row])!)
        var cell = tableView.cellForRow(at: indexPath) as! FeedsCell
//        
//        StringLblText   = (self.paramDict["title"]?[indexPath.row])! 
//        StringText = (self.paramDict["text"]?[indexPath.row])!
//        StringDataField = (self.paramDict["date"]?[indexPath.row])!    
        //StringUrlImg = (self.paramDict["image"]?[indexPath.row])!
       // GlobalImg = cell.img.image
       // tableView.allowsSelection = false

        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedsCell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedsCell

        cell.dateTime.text = paramDict[indexPath.row]["date"] as? String
        cell.titleText.text = paramDict[indexPath.row]["title"] as? String
        cell.shortText.text = paramDict[indexPath.row]["short"] as? String
        cell.marksLbl.text = String(paramDict[indexPath.row]["mark"] as! Int)
        cell.cntViews.text = paramDict[indexPath.row]["views"] as? String
        cell.postId = String(paramDict[indexPath.row]["post_id"] as! Int)
        cell.userMark = paramDict[indexPath.row]["user_mark"] as! Int
        cell.loginText.titleLabel?.text = paramDict[indexPath.row]["user_login"] as? String
        
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
