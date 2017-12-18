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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func like(_ sender: Any) {
        request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":1]).validate().responseJSON{
            responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                print (" STЫTUS = " , (jsonArray["status"] as!  String))
                if (jsonArray["status"] as!  String) == "OK" {
                    print("aaa")
                    
                    //                    var ttt = Int(self.cntLikes.text as! String)! + 1
                    //                    self.cntLikes.text = String (ttt) as! String
                }
                else {
                    print("FAIL")
                }
            case .failure(let error):
                print("Error = ",error)
            }
        }
    }
    
    @IBAction func dislike(_ sender: Any) {
        request(baseURL + "/api/set-mark" ,method: .post, parameters: ["id":Profile.shared.id,"post_id":SingleTonUltimateBlood.shared.postId,"mark":-1]).validate().responseJSON{
            responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                print (" STЫTUS = " , (jsonArray["status"] as!  String))
                if (jsonArray["status"] as!  String) == "OK" {
                    print("aaa")
                    
                    //                    var ttt = Int(self.cntLikes.text as! String)! - 1
                    //                    self.cntLikes.text = String (ttt) as! String
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
