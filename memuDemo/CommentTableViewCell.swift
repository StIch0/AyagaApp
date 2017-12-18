//
//  CommentTableViewCell.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 13/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var loginText: UIButton!
    @IBOutlet weak var commentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentText.isEditable = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
