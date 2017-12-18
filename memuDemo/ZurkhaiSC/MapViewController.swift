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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet var map: MKMapView!
    
    var paramDict:[String:[String]] = Dictionary()
    var pagParamDict:[String:[String]] = Dictionary()
    
    let loacManag = CLLocationManager()
    
    var polygons = Array<Any>()
    var points = [CLLocationCoordinate2D]()
    var message = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()      
        map.mapType = .standard
        map.delegate = self
        map.showsPointsOfInterest = false      
        
        let revealViewControllers : SWRevealViewController? = revealViewController()
        if revealViewControllers != nil {
            self.menu.target = revealViewControllers
            menu.action = #selector(revealViewControllers?.revealToggle(_:))
            view.addGestureRecognizer((revealViewControllers?.panGestureRecognizer())!)
        }
        
        
        points.append(CLLocationCoordinate2D(latitude: 71.0,  longitude: 73.0))
        points.append(CLLocationCoordinate2D(latitude: 72.0, longitude: 133.0))
        points.append(CLLocationCoordinate2D(latitude: 49.0, longitude: 123.135214))
        
        message.append("alsdfkjal;sdkfj")
        polygons.append(points)
        
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        
        map.add(polygon)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor.blue                
        renderer.alpha = 0.1
        
        return renderer
    }
    
    @IBAction func Ooooh_youTouchMyTralala(_ sender: Any) {
        guard let touch = sender as? UITapGestureRecognizer else {return}
        
        let touchLocation = touch.location(in: map)
        let coords = map.convert(touchLocation, toCoordinateFrom: map)
        
        for var i in 0...polygons.count-1 {
            if (isPointOnPolygon(id: i as! Int, pt: coords)) {       
                if let currentToast = ToastCenter.default.currentToast {
                    currentToast.cancel()
                }
                var e = Toast(text: message[i], duration: Delay.long)
                e.show()
                print (message[i])
                break
            }
        }        
    }
    
    func isPointOnPolygon(id: Int, pt: CLLocationCoordinate2D) -> Bool
    {   
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }        
    
}
