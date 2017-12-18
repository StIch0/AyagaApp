//
//  HistoryTableViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 25/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController 
{
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    var paramDict: [String:[String]] = Dictionary()
    
    var pagParamDict:[String:[String]] = Dictionary()
    var cntNews = 10000;
    var allLoaded = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }
                
        self.paramDict = SingleTonUltimateBlood.shared.loadData(API: "history?page=\(cntNews)", paramNames: ["id", "title","date", "short",  "image", "text"])
        
        if  paramDict["id"] != nil && paramDict["id"]!.count > 0 { 
            cntNews = Int((paramDict["id"]?[0])!)!
        }
        
        var ы = cntNews%20
        
        if (ы > 0) {ы = 1;}
        
        cntNews = cntNews/20 + ы
        
        paramDict["id"]!.reverse()
        paramDict["title"]!.reverse()
        paramDict["date"]!.reverse()
        paramDict["short"]!.reverse()
        paramDict["image"]!.reverse()
        paramDict["text"]!.reverse()
        
        cntNews = cntNews - 1

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return self.paramDict["id"]!.count
    }
    
    var dataString: [String] = []
    override func viewDidAppear(_ animated: Bool) {
        tableView.allowsSelection = true
        UIViewController.removeSpinner(spinner: sv)
    }
    @objc(tableView:didSelectRowAtIndexPath:) override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        //print("You selected name : "+(self.paramDict["date"]?[indexPath.row])!)
        
        var cell = tableView.cellForRow(at: indexPath) as! HistoryTableViewCell
//        
//        StringLblText   = (self.paramDict["title"]?[indexPath.row])! 
//        StringText  = (self.paramDict["text"]?[indexPath.row])!
//        StringDataField = (self.paramDict["date"]?[indexPath.row])!
        StringUrlImg    = (self.paramDict["image"]?[indexPath.row])!
     //   GlobalImg = cell.img.image
        print(StringUrlImg, "in select")
        tableView.allowsSelection = false

        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell                                                                
        
       // cell.dataTime.text = JSONTaker.shared.convertDate(date: (self.paramDict["date"]?[indexPath.row])!)
        cell.dataTime.text = (self.paramDict["date"]?[indexPath.row])
        cell.titleLbl.text = self.paramDict["title"]?[indexPath.row]
        cell.shortText.text = self.paramDict["short"]?[indexPath.row]
        if self.paramDict["image"]?[indexPath.row] != "" {
        SingleTonUltimateBlood.shared.loadImg(imgURL: (self.paramDict["image"]?[indexPath.row])!, img: cell.img, spinner: cell.spinner)
        }
        cell.shortText.sizeToFit()
        cell.img.sizeToFit()
        
        cell.shortText.numberOfLines = 0     
        
        if !allLoaded && indexPath.row == (paramDict["id"]?.count)!-1 {
            
            
            self.pagParamDict = SingleTonUltimateBlood.shared.loadData(API: "history?page=\(cntNews)", paramNames: ["id","title","date", "short",  "image", "text"])
            
            pagParamDict["id"]!.reverse()
            pagParamDict["title"]!.reverse()
            pagParamDict["date"]!.reverse()
            pagParamDict["short"]!.reverse()
            pagParamDict["image"]!.reverse()
            pagParamDict["text"]!.reverse()
            
            cntNews = cntNews-1
            
            print(pagParamDict)                         
            
            if (cntNews == -1) {
                print("  ALL LOADED !!!")
                allLoaded = true
                return cell
            }
            
            
            if (allLoaded == true) {
                for var iPag in pagParamDict.keys {
                    for var paramIpag in pagParamDict[iPag]! {
                        paramDict[iPag]?.append(paramIpag)
                    }
                }
            if pagParamDict["image"]?[indexPath.row] != ""{
                tableView.reloadData()
                }
            }
        }
                
        return cell
    }

}

//https://www.raywenderlich.com/129059/self-sizing-table-view-cells
