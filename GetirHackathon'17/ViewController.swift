//
//  ViewController.swift
//  GetirHackathon'17
//
//  Created by Mustafa ALP on 14/03/2017.
//  Copyright © 2017 Mustafa ALP. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class ViewController: UIViewController {
    
    let reqURL : String = "https://getir-bitaksi-hackathon.herokuapp.com/getElements"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShapes()
    }
    
    fileprivate func fetchShapes(){
        //setting parameters for POST request
        let parameters : HTTPHeaders = [
            "email" : "mustafaalp43@gmail.com",
            "name" : "Mustafa ALP",
            "gsm" : "1234567890" //privacy reasons
        ]
        //posting the request with parameters
        Alamofire.request(reqURL , method : .post , parameters : parameters).responseJSON{
            response in
            switch response.result{
            case .success(let data):
                let json = JSON(data)
                let shapeElements = json["elements"].arrayValue
                for shape in shapeElements {
                    let x = shape["xPosition"].intValue
                    let y = shape["yPosition"].intValue
                    let color = shape["color"].stringValue
                    if shape["type"] == "circle"{
                        let r = shape["r"].intValue
                        self.drawCircle(x , y , r , color)
                    }else{
                        let width = shape["width"].intValue
                        let height = shape["height"].intValue
                        self.drawRect(x , y , width , height , color)
                    }
                }
            case.failure(let err):
                print("Şekiller alınırken bir hata oluştu : " , err)
            }
        }
    }
    
    fileprivate func drawCircle(_ x : Int , _ y : Int , _ r : Int , _ color : String){
        let desiredLineWidth:CGFloat = 1
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:x,y:y),
            radius: CGFloat( r ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor(hexString: "#" + color).cgColor
        shapeLayer.strokeColor = UIColor(hexString: "#" + color).cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        self.view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func drawRect(_ x : Int , _ y : Int , _ width : Int , _ height : Int , _ color : String){
        let desiredLineWidth : CGFloat = 1
        let rectPath = UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: height))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
        
        shapeLayer.fillColor = UIColor(hexString: "#" + color).cgColor
        shapeLayer.strokeColor = UIColor(hexString: "#" + color).cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        self.view.layer.addSublayer(shapeLayer)
    }
}
//Extended UIColor for hex color values
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
