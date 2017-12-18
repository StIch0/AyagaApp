//
//  CurrentHistoryController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 26/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class CurrentHistoryController: UIViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var dataTime: UILabel!
    @IBOutlet var text: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var titleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataTime.text = JSONTaker.shared.convertDate(date: StringDataField)
        text.text = StringText
        titleText.text = StringLblText
        
        text.setHTML(html: text.text!)
        
        JSONTaker.shared.loadImg(imgURL: StringUrlImg, img: img, spinner: spinner)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
