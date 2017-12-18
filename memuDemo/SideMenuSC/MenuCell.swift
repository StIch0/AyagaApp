//
//  MenuCell.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet var lblMenuRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMenuname: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var lblFont = UIFont()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let window = UIApplication.shared.keyWindow {
            lblMenuRightConstraint.constant = -window.frame.width * 0.2
        }
        
        lblMenuname.sizeToFit()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            lblMenuname.textColor = UIColor.orange                        
            lblMenuname.font = UIFont(name: "Helvetica-Bold", size: 11)
        }
        else {
            lblMenuname.textColor = UIColor.black
            lblMenuname.font = UIFont(name: "Helvetica-Light", size: 11.5)
        }
        // Configure the view for the selected state
    }
}
