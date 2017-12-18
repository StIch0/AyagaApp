//
//  PhotoAlbumTableViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 31/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class PhotoAlbumTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {        

    @IBOutlet var btnMenuButton: UIBarButtonItem!
    @IBOutlet var photoCollectionView: UICollectionView!
    
    var album = [String:String]()
    var photosInCurrentAlbum:[String:String] = [String:String]()
    
    var paramDictAlbum: [String:[String]] = [String:[String]]()
    var paramDict: [String:[String]] = [String:[String]]()
    var itemSize:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.btnMenuButton.target = revealViewControllers
            btnMenuButton.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
            
        }
                paramDictAlbum = SingleTonUltimateBlood.shared.loadData(API: "albums/list", paramNames: ["id","short","name", "image"])
            paramDict = SingleTonUltimateBlood.shared.loadData(API: "photos/list", paramNames: ["id_photos","image", "album","short"])
            
        
        
        var bigString = ""
        
        //initialize album to not nil
        
        if (paramDict["id_photos"]?.count == 0) {return}
        
        for var i in paramDictAlbum["id"]! {
            photosInCurrentAlbum[i] = ""
        }
        
        
        if (paramDict["id_photos"]?.count)! > 0 {
            for var i: Int in 0...((paramDict["id_photos"]?.count)! - 1) { self.album[(paramDict["album"]?[i])!] = "" }
            for var i: Int in 0...((paramDict["id_photos"]?.count)! - 1) {
                
                if (photosInCurrentAlbum.keys.contains((paramDict["album"]?[i])!)) {
                    if (self.photosInCurrentAlbum[(paramDict["album"]?[i])!] == "") {
                        self.photosInCurrentAlbum[(paramDict["album"]?[i])!] = (paramDict["image"]?[i])!
                    }
                    else {
                        self.photosInCurrentAlbum[(paramDict["album"]?[i])!] = self.photosInCurrentAlbum[(paramDict["album"]?[i])!]! + "\n" + (paramDict["image"]?[i])!
                    }
                }
                else {
                    print ("may be old photo don't have valid album_id. T_T ", (paramDict["album"]?[i])!)
                }
            }
        }
        
        print (photosInCurrentAlbum)
        
        
        itemSize = (UIScreen.main.bounds.width-16)/2 - 4
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 9, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize*0.9)
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        photoCollectionView.collectionViewLayout = layout
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {                
       // StringImgURLs = (photosInCurrentAlbum[(paramDictAlbum["id"]?[indexPath.row])!]?.components(separatedBy: "\n"))!
        print (indexPath.row)
       // collectionView.allowsSelection = false

        StringNavBarTitle = (paramDictAlbum["short"]?[indexPath.row])!
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // UITableView.allowsSelection = true

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if paramDictAlbum.count == 0 {return 0}
        return (paramDictAlbum["id"]?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath) as! AlbumCollectionCell        
        
        cell.title.text = paramDictAlbum["name"]?[(paramDictAlbum["id"]?.count)!-1 - indexPath.row]//"Title"//(paramDict["short"]?[indexPath.row])!
        
        cell.photosCnt.text = (String(((photosInCurrentAlbum[(paramDictAlbum["id"]?[(paramDictAlbum["id"]?.count)!-1 - indexPath.row])!])!.components(separatedBy: "\n").count)))
        
        cell.title.layer.zPosition = 1
        cell.photosCnt.layer.zPosition = 1
        
        cell.title.textColor = UIColor.white
        cell.photosCnt.textColor = UIColor.white
        
        cell.title.sizeToFit()
        cell.photosCnt.sizeToFit()
        
        cell.backgroundLbl.backgroundColor = UIColor(white: 0, alpha: 0.66)          
        cell.titleWidthConstraint.constant = itemSize*0.8
        
        cell.photosCnt.frame = CGRect(x: cell.photosCnt.bounds.origin.x - cell.photosCnt.bounds.width, 
                                      y: cell.photosCnt.bounds.origin.y, 
                                      width: cell.photosCnt.bounds.width, 
                                      height: cell.photosCnt.bounds.height)
        
        cell.photosCnt.textAlignment = NSTextAlignment.right                
        
        SingleTonUltimateBlood.shared.loadImg(imgURL: (paramDictAlbum["image"]?[(paramDictAlbum["id"]?.count)!-1 - indexPath.row])!, img: cell.img, spinner: cell.spinner)
        
        return cell
    }       
}
