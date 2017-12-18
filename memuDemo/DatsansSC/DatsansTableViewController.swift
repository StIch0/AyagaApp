//
//  DatsansTableViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 30/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class DatsansTableViewController: UITableViewController {
    var cntPag = 2;
    var allLoaded = false
    var pagParamDict:[String:[String]] = Dictionary()
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    var paramDict:[String:[String]] = Dictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }                           
        
        paramDict = SingleTonUltimateBlood.shared.loadData(API: "dat?page=\(cntPag)", paramNames: ["id","title", "text"])
        
        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
            cntPag = Int((paramDict["id"]?[0])!)!
        }
        
        var ы = cntPag%20
        
        if (ы > 0) {ы = 1;}
        
        cntPag = cntPag/20 + ы
        
        paramDict["id"]!.reverse()
        paramDict["title"]!.reverse()
        paramDict["text"]!.reverse()
        
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 44            
        
            //loadAstrologicalData(baseURL: "file:///Users/dugar/Downloads/feed.json")            
            //print (paramDict)            
            
           
        
        
       // tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
//    override func viewDidAppear(_ animated: Bool) {
//        tableView.allowsSelection = true
//        UIViewController.removeSpinner(spinner: sv)
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (paramDict["id"]?.count)!
//    }
//    @objc(tableView:didSelectRowAtIndexPath:) override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
//        //print("You selected name : "+(self.paramDict["date"]?[indexPath.row])!)
//        
//        //var cell = tableView.cellForRow(at: indexPath) as! DatAstroCellTableViewCell
//        
////        StringLblText   = (self.paramDict["title"]?[indexPath.row])!
////        StringText  = (self.paramDict["text"]?[indexPath.row])!
//        tableView.allowsSelection = false
//
//        performSegue(withIdentifier: "segue", sender: self)
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        var cell = tableView.dequeueReusableCell(withIdentifier: "DatAstroCellTableViewCell") as! DatAstroCellTableViewCell     
//        
//        cell.TitleLbl.text = (paramDict["title"]?[indexPath.row])!        
//        cell.sizeToFit()
//        
//        //cell.TitleLbl.font = UIFont.boldSystemFont(ofSize: 16)
//        
//        if cntPag != -1 && !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
//            
//            self.pagParamDict =  SingleTonUltimateBlood.shared.loadData(API: "dat?page=\(cntPag)", paramNames: ["id","title", "text"])
//            
//            
//            cntPag = cntPag-1
//            
//            pagParamDict["id"]!.reverse()
//            pagParamDict["title"]!.reverse()
//            pagParamDict["text"]!.reverse()
//            
//            print(pagParamDict)
//            
//            if (cntPag == -1) {
//                print("  ALL LOADED !!!")
//                allLoaded = true
//                return cell
//            }
//            
//            for var iPag in pagParamDict.keys {
//                for var paramIpag in pagParamDict[iPag]! {
//                    paramDict[iPag]?.append(paramIpag)
//                }
//            }
//            
//            tableView.reloadData()
//        }
//        return cell
//    }
}
