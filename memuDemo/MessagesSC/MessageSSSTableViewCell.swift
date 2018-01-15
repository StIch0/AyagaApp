//
//  CardTableViewCell.swift
//  Cards
//
//  Created by Pavel Burdukovskii on 20/12/17.
//  Copyright © 2017 Pavel Burdukovskii. All rights reserved.
//

import UIKit

class MessageSSSTableViewCell: UITableViewCell {
    @IBOutlet weak var Titlelbl: UILabel!//date XD
    @IBOutlet weak var txtField: UITextView!
    
    @IBOutlet var txtFieldHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
