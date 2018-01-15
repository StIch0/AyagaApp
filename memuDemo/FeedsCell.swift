//
//  FeedsCell.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 18/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FeedsCell: UITableViewCell {
    @IBOutlet var like: UIButton!
    @IBOutlet var dislike: UIButton!
    var postId : String!  = String() //Ы!    
    var userMark: Int! = Int()  
    @IBOutlet var spinner: UIActivityIndicatorView!    
    @IBOutlet var profileIcon: UIImageView!
    
    @IBOutlet var titleHeightConstrait: NSLayoutConstraint!
    
    @IBOutlet var imgHeightConstrait: NSLayoutConstraint!
    @IBOutlet var shortTextViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet var cntViews: UILabel!
    @IBOutlet var marksLbl: UILabel!
    @IBOutlet var titleText: UITextView!
    @IBOutlet var shortText: UITextView!
    @IBOutlet var loginText: UIButton!
    @IBOutlet var dateTime: UILabel!
    @IBAction func goToSubscribe(_ sender: UIButton) {
        SingleTonUltimateBlood.shared.UserID = Int(sender.accessibilityIdentifier!)!
        //?????????
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
//    @IBOutlet weak var marksLbl: UITextField!
//    @IBOutlet weak var cntViews: UITextField!
//    @IBOutlet weak var shortText: UITextField!
//    @IBOutlet weak var titleText: UITextField!
//    @IBOutlet weak var dateTime: UITextField!
//    @IBOutlet weak var loginText: UITextField! котлеты сбились
  
    @IBAction func like(_ sender: UIButton) {
        sender.isEnabled = false
        if sender.backgroundColor != .red {
            print ("ыхыхыыхыхых")
            print (postId)
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":self.postId,"mark":1]).validate().responseJSON{
                responseJSON in 
                switch responseJSON.result{
                case .success(_): 
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        var ttt = Int((self.marksLbl.text!))! + 1
                        if (self.dislike.backgroundColor == .red) {ttt = ttt+1}
                        self.marksLbl.text = String (ttt)
                        self.like.backgroundColor = .red
                        self.dislike.backgroundColor = .none
                        sender.isEnabled = true
                        
                    }
                    else {
                        print("FAIL")
                    }
                case .failure(let error):
                    print("Error = ",error)
                }
            }
        }
        else {
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":self.postId,"mark":-1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.marksLbl.text!))! - 1
                        self.marksLbl.text = String (ttt)
                        self.like.backgroundColor = .none
                        //self.dislike.backgroundColor = .red
                        sender.isEnabled = true
                        
                    }
                    else {
                        print("FAIL")
                    }
                case .failure(let error):
                    print("Error = ",error)
                }
            }
            
        }
    }
    @IBAction func dislike(_ sender: UIButton) { 
        sender.isEnabled = false
        if sender.backgroundColor != .red {
            print ("ыхыхыыхыхых")
            print (postId)
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":self.postId,"mark":-1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        var ttt = Int((self.marksLbl.text!))! - 1
                        
                        if (self.like.backgroundColor == .red) {ttt = ttt-1}                        
                        self.marksLbl.text = String (ttt)
                        self.dislike.backgroundColor = .red
                        self.like.backgroundColor = .none
                        sender.isEnabled = true
                    }
                    else {
                        print("FAIL")
                    }
                case .failure(let error):
                    print("Error = ",error)
                }
            }
        }
        else {
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":self.postId,"mark":1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.marksLbl.text!))! + 1
                        self.marksLbl.text = String (ttt)
                        self.dislike.backgroundColor = .none
//                        self.like.backgroundColor = .red
                        sender.isEnabled = true
                        
                    }
                    else {
                        print("FAIL")
                    }
                case .failure(let error):
                    print("Error = ",error)
                }
            }
            
        }
        
    }

    @IBOutlet var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state            
    }
}
