//
//  HuralCell.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 07/09/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class HuralCell: UITableViewCell {

    
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!     
    @IBOutlet var dateFieldLbl: UILabel!         
    @IBOutlet var orderBtn: UIButton!
    
    func getOerderBtn () -> UIButton {
        return orderBtn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state                
    }

}
