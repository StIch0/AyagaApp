//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class KhuralScheduleViewController: UITableViewController,UINavigationBarDelegate,UINavigationControllerDelegate {
    var cntPag = 10000;
    var allLoaded = false
    var pagParamDict:[String:[String]] = Dictionary()

    @IBOutlet var btnMenuButton: UIBarButtonItem!
    
    var paramDict:[String:[String]] = Dictionary()
    
    var btnDict = [String:IndexPath]()
    
    @IBAction func orderBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "segue", sender: self)
        
        
        let indx = (btnDict[sender.accessibilityIdentifier!]?.row)!
        
//        StringLblText   = (self.paramDict["title"]?[indx])! 
//        StringDataField = (self.paramDict["date"]?[indx])!         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //revealViewController().rearViewRevealWidth = 270
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)                        
        }
                        
        
        paramDict = SingleTonUltimateBlood.shared.loadData(API: "rasp?page=\(cntPag)", paramNames: ["id_rasp", "day", "title", "date", "text"])
        
        if  paramDict["id_rasp"] != nil && paramDict["id_rasp"]!.count > 0 { 
            cntPag = Int((paramDict["id_rasp"]?[0])!)!
        }
        
        var ы = cntPag%20
        
        if (ы > 0) {ы = 1;}
        
        cntPag = cntPag/20 + ы
        
        cntPag -= 1
        
        paramDict["id_rasp"]!.reverse()
        paramDict["title"]!.reverse()
        paramDict["date"]!.reverse()
        paramDict["day"]!.reverse()
        paramDict["text"]!.reverse()
        
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 34 
        
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paramDict["id_rasp"]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HuralCell") as! HuralCell
      
        cell.orderBtn.accessibilityIdentifier = (paramDict["id_rasp"]?[indexPath.row])!
        btnDict[(paramDict["id_rasp"]?[indexPath.row])!] = indexPath
        cell.titleLbl.text = (paramDict["title"]?[indexPath.row])!
        cell.textLbl.setHTML(html: (paramDict["text"]?[indexPath.row])!)
       // cell.dateFieldLbl.text = JSONTaker.shared.convertDate(date: ((paramDict["day"]?[indexPath.row])! + " " + (paramDict["date"]?[indexPath.row])!))
        cell.dateFieldLbl.text = (paramDict["day"]?[indexPath.row])!
            + " " + (paramDict["date"]?[indexPath.row])!
        cell.orderBtn.restorationIdentifier = (paramDict["id_rasp"]?[indexPath.row])!
        if cntPag != -1 && !allLoaded && indexPath.row == (paramDict["id_rasp"]?.count)!-1 {
            
            self.pagParamDict = SingleTonUltimateBlood.shared.loadData(API: "rasp?page=\(cntPag)", paramNames: ["id_rasp", "day", "title", "date", "text"])
            
            pagParamDict["id_rasp"]!.reverse()
            pagParamDict["title"]!.reverse()
            pagParamDict["date"]!.reverse()
            pagParamDict["day"]!.reverse()
            pagParamDict["text"]!.reverse()
            
            cntPag = cntPag-1
            
             
            if (cntPag == -1) {
                print("  ALL LOADED !!!")
                allLoaded = true
                return cell
            }
            
            
            for var iPag in pagParamDict.keys {
                for var paramIpag in pagParamDict[iPag]! {
                    paramDict[iPag]?.append(paramIpag)
                }
            }
            
            tableView.reloadData()
        }

        return cell
    }
}
