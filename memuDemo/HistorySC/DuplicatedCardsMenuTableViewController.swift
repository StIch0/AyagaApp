//
//  DuplicatedCardsMenuTableViewController.swift
//  appAyaga
//
//  Created by Dugar Badagarov on 24/12/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class DuplicatedCardsMenuTableViewController: UITableViewController {
    var paramDict: [[String:AnyObject]] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = SingleTonUltimateBlood.shared.catID
        SingleTonUltimateBlood.shared.senderForMessageSegue = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        request(baseURL + "/api/get-card-categories", method: .post, parameters: ["parent":id]).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                let result = jsonArray["categories"] as! [AnyObject]
                self.paramDict = result as! [[String : AnyObject]]
                // print(self.paramDict)
                self.tableView.reloadData()
            case .failure(let error):
                print("Error : ", error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = paramDict[indexPath.row]["id"] as! Int
        let children = paramDict[indexPath.row]["childrens"] as! Int
        print("id = =      ",id)
        if children != 1 {
            print("id = =      ",id)
            request(baseURL + "/api/get-card-categories", method: .post, parameters: ["parent":id]).validate().responseJSON { (responseJSON)  in
                switch responseJSON.result {
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject] else {return}
                    let result = jsonArray["categories"] as! [AnyObject]
                    self.paramDict = result as! [[String : AnyObject]]
                    // print(self.paramDict)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error : ", error)
                }
            }
        }else {                   
            SingleTonUltimateBlood.shared.catID = id
            performSegue(withIdentifier: "segue", sender: self)
            
        }
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paramDict.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DuplicatedCardsMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DuplicatedCardsMenuTableViewCell", for: indexPath) as! DuplicatedCardsMenuTableViewCell
        // print((paramDict[indexPath.row]["title"] as? String)!)
        cell.titlelbl?.text = paramDict[indexPath.row]["title"] as? String
        return cell
    }
}
