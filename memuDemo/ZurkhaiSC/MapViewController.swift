//
//  khuralScheduleViewController.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 11/08/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit
import MapKit
import Toaster
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet var map: MKMapView!
    
    var paramDict:[String:[String]] = Dictionary()
    var pagParamDict:[String:[String]] = Dictionary()
    
    let loacManag = CLLocationManager()
        
    var message = [String]()
    var color = [UIColor]()
    override func viewDidLoad() {
        super.viewDidLoad()      
        SingleTonUltimateBlood.shared.senderForMessageSegue = self
        map.mapType = .standard
        map.delegate = self
        map.showsPointsOfInterest = false      
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.menu.target = revealViewControllers
            menu.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        
        
        request(baseURL + "/api/get-map", method: .post).validate().responseJSON { (responseJSON)  in
            switch responseJSON.result {
            case .success(_):
                guard let jsonArray = responseJSON.value as? [String: AnyObject]else {return}
                let result = jsonArray["map"] as! [AnyObject]
                //self.paramDict = result as! [[String : AnyObject]]
                print (result)
                
                for strs in result {
                    var poly = self.convertToDictionary(text: strs as! String)! as [String: AnyObject]                    
                    var ptss = (poly["geometry"] as! [String: AnyObject])                    
                    let polygons = ((ptss["coordinates"] as? [[[String]]])!)                    
                    var props = poly["properties"] as! [String: AnyObject]
                    
                    //init polygons                     
                    for plg in polygons {
                        var points = [CLLocationCoordinate2D]()
                        
                        for pt in plg {
                            guard let latitude  = NumberFormatter().number(from: pt[1]) else { return }
                            guard let longitude = NumberFormatter().number(from: pt[0]) else { return }
                            points.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
                        }
                        
                        let polygon = MKPolygon(coordinates: &points, count: points.count)
                        
                        polygon.accessibilityLabel = (props["text"] as? String ?? "")                  
                        polygon.title = props["color"] as? String
                        
                        self.map.add(polygon)
                    }
                }
                
            case .failure(let error):
                print("Error : ", error)
            }
            
        }                                
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor(hexString: overlay.title!!)                
        renderer.alpha = 0.5
        
        return renderer
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    @IBAction func Ooooh_youTouchMyTralala /*Ooooooh, my singleton...*/ (_ sender: Any) {
        guard let touch = sender as? UITapGestureRecognizer else {return}
                
        
        let touchLocation = touch.location(in: map)
        let coords = map.convert(touchLocation, toCoordinateFrom: map)
        
        let pointtt = MKMapPointForCoordinate(coords)
        let mapRect = MKMapRectMake(pointtt.x, pointtt.y, 0.0, 0.0);
        
        for var plgn in (map.overlays) {
            let pl = (plgn as? MKPolygon) 
            if (pl == nil) {continue} 
            if (pl?.intersects(mapRect))! {
                if let currentToast = ToastCenter.default.currentToast {
                    currentToast.cancel()
                }
                let e = Toast(text: pl?.accessibilityLabel!, duration: Delay.long)
                e.show()
            }            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }        
    
}
