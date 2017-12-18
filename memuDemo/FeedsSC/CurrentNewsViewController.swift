//
//  CurrentNewsViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 23/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class CurrentNewsViewController: UITableViewController//, UICollectionViewDelegate, UICollectionViewDataSource 
{
    
    var post_id : Int = Int()
    var titleText: UITextView = UITextView()
    
    var paramDict : [[String:AnyObject]] = Array()
    let date = Date()
    let formatter = DateFormatter()
    
    
    var images = [UIImage]()
    var currentDateTime: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        currentDateTime = formatter.string(from: date)
      // print("qwerty Date = ", currentDateTime)
        post_id = SingleTonUltimateBlood.shared.postId
              
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        getComment()

    }
    func getComment(){
        request(baseURL + "/api/get-comments", method: .post, parameters: [
            "post_id": post_id /*SingleTonUltimateBlood.shared.postId*/]).validate().responseJSON { (responseJSON)  in
                switch responseJSON.result {
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print(jsonArray)
                    let result = jsonArray["comments"] as! [AnyObject]
                    self.paramDict = result as! [[String : AnyObject]]
                    //              self.paramDict = [jsonArray]
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error : ", error)
                }
                
        }
    }
    
    @IBAction func addComment(_ sender: Any) {
        let indexP = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexP) as? CurrentNewsTableViewCell
        if cell?.commentText.text != "" {
        request(baseURL + "/api/add-comment", method: .post, parameters: [
            "post_id": post_id /*SingleTonUltimateBlood.shared.postId*/,
            "user_id":Profile.shared.id,
            "text":cell?.commentText.text! ?? "",
            "date":currentDateTime]).validate().responseJSON { (responseJSON)  in
                switch responseJSON.result {
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    if (jsonArray["status"] as! String) == "OK" {
                        self.tableView.reloadData()
                        self.getComment()
                        cell?.commentText.text = ""
                        print("Comment were added")
                    }
                    else {
                        print("WTF?")
                    }
                case .failure(let error):
                    print("Error : ", error)
                }
            }
                
        }
    }
    
    
    
//    @available(iOS 6.0, *)
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentNewsCollectionViewCell", for: indexPath) as! CurrentNewsCollectionViewCell
//        if SingleTonUltimateBlood.shared.StringImgURLs != nil && SingleTonUltimateBlood.shared.StringImgURLs?.count != 0 {
//            SingleTonUltimateBlood.shared.loadImg(imgURL: SingleTonUltimateBlood.shared.StringImgURLs![indexPath.row], img: cell.img!)
//        }
//        else {cell.img.isHidden = true}
//        return cell
//    }
//    
//    
//    @available(iOS 6.0, *)
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print ("IMG CNTTTTTTTTTT = ", SingleTonUltimateBlood.shared.StringImgURLs!.count)
//        return SingleTonUltimateBlood.shared.StringImgURLs!.count
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell: CurrentNewsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CurrentNewsTableViewCell", for: indexPath) as? CurrentNewsTableViewCell)!
                
            cell.userName.titleLabel?.text = SingleTonUltimateBlood.shared.StringUserName
            cell.textView.text = SingleTonUltimateBlood.shared.StringText
            cell.cntViews.text = SingleTonUltimateBlood.shared.StringVisibleCnt
            cell.cntMarks.text = SingleTonUltimateBlood.shared.StringMarks
            cell.dateLbl.text = SingleTonUltimateBlood.shared.StringDataField
            
            cell.textViewHeightConstrait.constant = cell.textView.contentSize.height
            
            if SingleTonUltimateBlood.shared.StringImgURLs == nil || SingleTonUltimateBlood.shared.StringImgURLs?.count == 0 {
                cell.collectionViewHeightConstrait.constant = 0
            }
            
            return cell
        }
        
        let cell: CommentTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell)!
       
        
        cell.commentText.text = (paramDict[indexPath.row]["text"] as? String)!        
        cell.dateTime.text = paramDict[indexPath.row]["date"] as? String
        cell.loginText.titleLabel?.text = paramDict[indexPath.row]["user_login"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramDict.count
    }

}
