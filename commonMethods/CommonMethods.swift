//
//  CommonMethods.swift
//  Edelweiss Subbroker
//
//  Created by Amit Bachhawat on 8/20/18.
//  Copyright © 2018 Amit Bachhawat. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {
    
    //MARK: Alert Function
    class public func ShowAlert(vc: UIViewController, title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: KEYBORD MANAGE
    class public func kyboardManage(moveDistance: Int,view:UIView,up: Bool)
    {
        let movementDistance = moveDistance
        // tweak as needed
        let movementDuration: Float = 0.3
        // tweak as needed
        let movement: Int = up ? -movementDistance : movementDistance
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(movementDuration))
        view.frame = view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    
    class func arrRemoveDuplicates(array: NSArray) -> NSArray {
        let arrData : NSMutableArray = NSMutableArray()
        arrData.removeAllObjects()
        for (_,element) in array.enumerated() {
            if arrData.contains(element) {
                
            }
            else {
                arrData.add(element)
            }
        }
        return arrData
    }
    
    //get currnet viewcontroller
    func getCurrentViewController() -> UIViewController {
        if UIApplication.shared.delegate!.window!!.rootViewController != nil {
            var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
            while (topViewController.presentedViewController != nil) {
                topViewController = topViewController.presentedViewController!
            }
            return topViewController
        }
        else {
            let viewController:UIViewController = UIViewController()
            return viewController
        }
    }
    

    
    
    class func searchAutocomplite(arrRecords:NSArray,substring:NSString)-> NSArray {
        var searchArray = NSMutableArray()
        if substring.length != 0 {
            searchArray.removeAllObjects()
            //searchArray = arrayDirectory.filter { ($0["displayName2"] as! String).range(of: searchText!, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[C] %@", substring)
            
            searchArray = ((arrRecords as NSArray).filtered(using: searchPredicate) as! NSMutableArray).mutableCopy() as! NSMutableArray
            //let predicate = NSPredicate(format: "SELF contains[c] %@", substring)
            //searchArray = arrRecords.filtered(using: predicate) as! NSMutableArray
        } else {
            searchArray = arrRecords as! NSMutableArray
        }
        return searchArray
    }
 
}

//MARK: remove null value from Dictionary
extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        
        return dict
    }
    
    
}

//MARK: AddBottom Border To TextField
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
        
    }
    
}

//MARK: Configure childViewController
extension UIViewController {
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParentViewController: self)
        childController.willMove(toParentViewController: self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    //MARK: Container Mehods
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController,containerView:UIView) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:containerView)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animate(withDuration: 0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
}


//MARK: cardView shadowColor and corner radius
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func cardView(shadowColor:UIColor) {
        
        let cornerRadius: CGFloat = 5
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 3
        let shadowColor: UIColor? = shadowColor
        let shadowOpacity: Float = 0.5
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func cardView(shadowColor:UIColor, withRadious:CGFloat) {
        
 
        
        let shadowColor: UIColor? = shadowColor
        
        layer.shadowOpacity = 0.5
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowRadius = withRadious
        layer.cornerRadius = withRadious
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
        
        
    }
    
    func cellCardView(shadowColor:UIColor, withRadious:CGFloat) {
    
        let shadowColor: UIColor? = shadowColor
        
        layer.shadowOpacity = 0.5
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowRadius = withRadious
        layer.cornerRadius = withRadious
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.masksToBounds = false
        
        
    }
    
    //MARK: AddCornerRadiusToView
    func addCornerRadiusToView(view:UIView,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor) {
        
        let brdColor: UIColor? = borderColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = brdColor?.cgColor
    }
}

extension String {
    //This function trim only white space:
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    //This function trim whitespeaces and new line that you enter:
    func trimWhiteSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func converToCurrencyFormat() -> String {
        let currentValueFloat: Float = (self as NSString).floatValue
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = Locale(identifier: "en_IN")
        numberFormatter.currencySymbol = "₹"
        
        let formattedNumber1 = numberFormatter.string(from: NSNumber(value:currentValueFloat))
        return String(format:"%@",formattedNumber1!)
    }
    func converToCurrencyFormatWithOutDecimal() -> String {
        let currentValueFloat: Float = (self as NSString).floatValue
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = Locale(identifier: "en_IN")
        numberFormatter.currencySymbol = "₹"
        
        let formattedNumber1 = numberFormatter.string(from: NSNumber(value:currentValueFloat))
        return String(format:"%@",formattedNumber1!)
    }
    func converToCurrencyFormatWithoutSymbol() -> String {
        let currentValueFloat: Float = (self as NSString).floatValue
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = Locale(identifier: "en_IN")
        numberFormatter.currencySymbol = ""
        
        let formattedNumber1 = numberFormatter.string(from: NSNumber(value:currentValueFloat))
        return String(format:"%@",formattedNumber1!)
    }
    
}

extension Float {
    var cleanValue: Double {
        let strStrng:NSString = (self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)) as NSString
        return Double(strStrng.integerValue)
    }
}

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)   // QUALITY min = 0 / max = 1
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class PaddedTextField: UITextField {
    
    @IBInspectable var padding: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
}
extension UIViewController{
    func showAlert(alert:String, message:String){
        let alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

@IBDesignable
class roundButton:UIButton{
    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
    }
  }
    @IBInspectable var borderColor:UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
    }
  }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
}

@IBDesignable
class textFieldRound:UITextField{
    
    @IBInspectable  var CornorRadius:CGFloat = 0{
        didSet{
            self.layer.cornerRadius = CornorRadius
        }
    }
    @IBInspectable var borderColor:UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var padding: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
}
