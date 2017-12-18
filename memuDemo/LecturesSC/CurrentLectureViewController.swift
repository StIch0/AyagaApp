//
//  CurrentLectureViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 29/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class CurrentLectureViewController: UIViewController {

    
    @IBOutlet var videoFrame: UIWebView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()            
        
        dateLbl.text = StringDataField
        titleLbl.text = StringLblText
        textLbl.text = StringText
        
        JSONTaker.shared.loadVideo(videoCode: StringVideoID, myWebView: videoFrame)
        
        if !videoFrame.isLoading {
            videoFrame.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
