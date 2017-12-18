//
//  ProfileDataViewController.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 10/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ProfileDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSerName: UILabel!
    @IBOutlet weak var lblSubNum: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        request(baseURL + "/api/user-info", method: .post, parameters: ["id":Profile.shared.id]).responseJSON{ responseJSON in
            switch responseJSON.result{
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                //  let result = jsonArray["news"] as! [AnyObject]
                print(jsonArray)
                if jsonArray["status"]! as! String != "ОК" {
                    SingleTonUltimateBlood.shared.showAlert(title: jsonArray["status"] as! String, message: "", viewController: self)
                }
                else {
                    self.lblName.text = jsonArray["name"]! as? String
                    self.lblSerName.text = jsonArray["family"]! as? String
                    self.lblPhone.text = "Телефон: " + (jsonArray["tel"]! as! String)
                    self.lblCity.text = "Город: " + (jsonArray["city"]! as! String)
                    self.lblSubNum.text = "Подписчиков: " + (jsonArray["sub_num"]! as! String)
                    Profile.shared.sub_num = (jsonArray["sub_num"]! as? String)!
                    Profile.shared.Save()
                }
                
            case .failure(let error):
                print("Error : ", error)
            }
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
