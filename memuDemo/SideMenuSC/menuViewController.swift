//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var RandomTextUnderPict: UILabel!    
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!            
    
    public static var shared = menuViewController()
    
    var viewControllersDict: [String:[String]] =
        ["Новости":["ViewController","ViewController"],
         "Мой профиль":["ProfileViewController","ProfileDataViewController"],
         "Сообщения":["DialogSSSViewController","DialogSSSViewController"],
         "Лента подписок":["ViewController","ViewController"],
         "Историческая справка":["CardsMenuViewController","CardsMenuViewController"],
         "Карта":["MapViewController","MapViewController"],
         "Создать новость":["CreateFeedViewController","CreateFeedViewController"],
         "Настройки":["SettingsViewController","SettingsViewController"]] 
    
    var ManuNameArray:[String] = [
        "Новости",
        "Мой профиль",
        "Сообщения",
        "Лента подписок",
        "Историческая справка",
        "Карта",
        "Создать новость",
        "Настройки"
    ]
    
    var iconArray:Array = [UIImage]()   
    var didLoadCalled = true
    
    func handleDissmis (bugged: Bool=false)
    {
        if let window = UIApplication.shared.keyWindow {
            //magic numbers ALERT !!!
            UIView.animate(withDuration: 0.68, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.88, options: .curveEaseOut, animations: { 
                //blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                blackView.alpha = 0
            }, completion: nil)
        
            if (!bugged) {revealViewController().revealToggle(animated: true)}
        }                
    }
    
    func makeDark ()
    {                                            
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmis)))
        
        revealViewController().frontViewController.view.addSubview(blackView)
        blackView.frame = revealViewController().frontViewController.view.frame 
        blackView.alpha = 0
        //magic numbers ALERT !!!                        
        
        UIView.animate(withDuration: 0.725, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            blackView.alpha = 1                
        }, completion: nil)
            
        
    }           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("MENUUUUU DID LOAD !!!!")
        SingleTonUltimateBlood.shared.setStatusBarColorOrange()
        self.view.layer.shadowRadius = 0;
        
        revealViewController().toggleAnimationType = SWRevealToggleAnimationType.spring
        revealViewController().toggleAnimationDuration = 0.725 //magic numbers ALERT !!!                                                
        
        if let window = UIApplication.shared.keyWindow {
            revealViewController().rearViewRevealWidth = window.frame.width * 0.65
            revealViewController().draggableBorderWidth = window.frame.width * 0.05         
        }                
        
        
        iconArray = [UIImage(named:"1")!,
                     UIImage(named:"2")!,
                     UIImage(named:"3")!,
                     UIImage(named:"4")!,
                     UIImage(named:"5")!,
                     UIImage(named:"6")!,
                     UIImage(named:"7")!,
                     UIImage(named:"2")!,
                     UIImage(named:"1")!
        ]                    
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true 
        // Do any additional setup after loading the view.        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        handleDissmis(bugged: true)
        
        DispatchQueue.main.async(execute: {
            while (blackView.alpha != 0) {
                blackView.removeFromSuperview()
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        RandomTextUnderPict.text = "Аяга Аяга"
        makeDark()
        SingleTonUltimateBlood.shared.setStatusBarColorOrange()
        
        if (didLoadCalled == true) {
            (self.tblTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MenuCell).setSelected(true, animated: true)            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell        
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        cell.frame.size = CGSize(width: cell.frame.size.width, height: 200)                  
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDissmis()        
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)        
        
        if (didLoadCalled == true) {
            if (indexPath.row != 0) {
                (self.tblTableView.cellForRow(at: IndexPath(row: 0, section: 0)))?.setSelected(false, animated: true)
            }
            didLoadCalled = false
        }

        callViewController(controllerName: cell.lblMenuname.text!)
    }

    public func callViewController (controllerName: String) {
        for i in 0...ManuNameArray.count-1 {
            if ManuNameArray[i] == controllerName {
                SingleTonUltimateBlood.shared.location = i
            }
        }
//        if Profile.shared.sign{}
//        print(SingleTonUltimateBlood.shared.location)
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: viewControllersDict[controllerName][1])var newViewcontroller : UIViewController = UIViewController()
        print(Profile.shared.sign)
        var newViewcontroller : UIViewController = UIViewController()
        if  !Profile.shared.sign{
            newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: viewControllersDict[controllerName]![0])
        }
        else {
            newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: viewControllersDict[controllerName]![0])            
        }
                        
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
        //sv = UIViewController.displaySpinner(onView: UIApplication.shared.keyWindow!)
        revealViewController().pushFrontViewController(newFrontController, animated: true)        
    }    
}
