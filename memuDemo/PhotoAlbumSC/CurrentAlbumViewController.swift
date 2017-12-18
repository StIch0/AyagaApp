//
//  CurrentAlbumViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 02/09/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class CurrentAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var currentAlbumCollectionView: UICollectionView!
    @IBOutlet var albumTitle: UINavigationItem!
    
    var blackView = UIScrollView()
    var itemSize: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.w
        
        albumTitle.title = StringNavBarTitle
        //print(StringNavBarTitle)
        
        itemSize = (UIScreen.main.bounds.width-6)/3 - 2
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(6, 0, 7, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        blackView.isPagingEnabled = true
        blackView.showsHorizontalScrollIndicator = false
        
        currentAlbumCollectionView.collectionViewLayout = layout  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentAlbumCollectionCell", for: indexPath) as! CurrentAlbumCollectionCell                 
        
        var fullScreenPict = UIImageView()
        let xPosition = Int((UIApplication.shared.keyWindow?.frame.width)!) * indexPath.row
        // SingleTonUltimateBlood.shared.loadImg(imgURL: StringImgURLs[indexPath.row],
        //                         img: [cell.img,fullScreenPict],
          //                       spinner: cell.spinner)
        
        fullScreenPict.contentMode = .scaleAspectFit
        fullScreenPict.frame = CGRect(x: xPosition, y: 0, 
                                      width:  Int((UIApplication.shared.keyWindow?.frame.width )!), 
                                      height: Int((UIApplication.shared.keyWindow?.frame.height)!))
        blackView.contentSize.width = ((UIApplication.shared.keyWindow?.frame.width)!) * CGFloat(indexPath.row + 1)
        blackView.addSubview(fullScreenPict)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CurrentAlbumCollectionCell
        
        let xPosition = (UIApplication.shared.keyWindow?.frame.width)! * CGFloat(indexPath.row)        
        
        blackView.setContentOffset(CGPoint(x: xPosition, y: 0) , animated: false)
        makeDark()        
    }
    
    func handleDissmis ()
    {
        if let window = UIApplication.shared.keyWindow {
            //magic numbers ALERT !!!
            UIView.animate(withDuration: 0.88, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.88, options: .curveEaseOut, animations: {                 
                self.blackView.alpha = 0
            }, completion: nil)
            
        }
    }
    
    func makeDark ()
    {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.65)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmis)))
            blackView.alwaysBounceHorizontal = true
            window.addSubview(blackView)
            blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            blackView.alpha = 0
            //magic numbers ALERT !!!
            UIView.animate(withDuration: 0.88, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
            }, completion: nil)
            
        }
    }
}
