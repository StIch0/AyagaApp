//
//  AlbumCollectionCell.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 31/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var photosCnt: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var backgroundLbl: UILabel!    
    @IBOutlet var titleWidthConstraint: NSLayoutConstraint!        
}
