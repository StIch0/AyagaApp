//
//  CurrentNewsTableViewCell.swift
//  appAyaga
//
//  Created by Dugar Badagarov on 17/12/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class CurrentNewsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SingleTonUltimateBlood.shared.StringImgURLs!.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentNewsCollectionViewCell", for: indexPath) as! CurrentNewsCollectionViewCell
        if SingleTonUltimateBlood.shared.StringImgURLs?.count != 0 {
            SingleTonUltimateBlood.shared.loadImg(imgURL: SingleTonUltimateBlood.shared.StringImgURLs![indexPath.row], img: cell.img!)
        }
        else {cell.img.isHidden = true}
        return cell
    }
    
    @IBAction func goToSubscribe(_ sender: UIButton) {
        
     }
    func action(){}
    
    @IBOutlet var titleTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var commentText: UITextView!
    @IBOutlet var userName: UIButton!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var dislikeBtn: UIButton!
    @IBOutlet var cntViews: UILabel!
    @IBOutlet var cntMarks: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var collectionViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet var textViewHeightConstrait: NSLayoutConstraint!
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func like(_ sender: UIButton) {
        //sender.isEnabled = false
        if likeBtn.backgroundColor != .red {
            print ("ыхыхыыхыхых")
            print (SingleTonUltimateBlood.shared.postId)
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":1]).validate().responseJSON{
                responseJSON in 
                switch responseJSON.result{
                case .success(_): 
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.cntMarks.text!))! + 1
                        self.cntMarks.text = String (ttt)
                        self.likeBtn.backgroundColor = .red
                        self.dislikeBtn.backgroundColor = .none
                      //  sender.isEnabled = true
                        
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
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":-1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.cntMarks.text!))! - 1
                        self.cntMarks.text = String (ttt)
                        self.likeBtn.backgroundColor = .none
                        //self.dislike.backgroundColor = .red
                       // sender.isEnabled = true
                        
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
       // sender.isEnabled = false
        if dislikeBtn.backgroundColor != .red {
            print ("ыхыхыыхыхых")
            print (SingleTonUltimateBlood.shared.postId)
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":-1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.cntMarks.text!))! - 1
                        self.cntMarks.text = String (ttt)
                        self.dislikeBtn.backgroundColor = .red
                        self.likeBtn.backgroundColor = .none
                       // sender.isEnabled = true
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
            request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":1]).validate().responseJSON{
                responseJSON in
                switch responseJSON.result{
                case .success(_):
                    guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                    print (" STЫTUS = " , (jsonArray["status"] as!  String))
                    if (jsonArray["status"] as!  String) == "OK" {
                        print("aaa")
                        
                        let ttt = Int((self.cntMarks.text!))! + 1
                        self.cntMarks.text = String (ttt)
                        self.dislikeBtn.backgroundColor = .none
                        //                        self.like.backgroundColor = .red
                       // sender.isEnabled = true
                        
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

    

}
