//
//  DeviceLocationView.swift
//  Trucks
//
//  Created by Marius Ursache on 27/12/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit

class DeviceLocationView: UIImageView {
    
    let itemNameLabel: UILabel = UILabel()
    
    var imageWidth: CGFloat = 33
    let imageHeight: CGFloat = 17
    let defaultFont: UIFont = UIFont(name: "HelveticaNeue", size: 12)!
    let defaultBackgroundColor = UIColor.yellow
    
    let maxIdLength = 5
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.itemNameLabel.textAlignment = NSTextAlignment.center
        self.addSubview(self.itemNameLabel)
        
        self.backgroundColor = self.defaultBackgroundColor
    }
    
    func configure(location: Location) {
        self.configure(location: location, font: self.defaultFont)
    }
    
    func configure(location: Location, font: UIFont) {
        let itemNameStr = titleForLocation(location: location)
        
        self.itemNameLabel.font = font
        self.itemNameLabel.text = itemNameStr
        
        self.resizeLabel(name: itemNameStr)
        self.backgroundColor = self.backgroundForLocation(location: location)
    }
    
    func backgroundForLocation(location: Location) -> UIColor {
        switch location.type {
        case .iPad:
            return UIColor(red: 0.24, green: 0.54, blue: 0.96, alpha: 0.9) // Blue

        case .Truck:
            return UIColor.white
            // return UIColor(red: 0.88, green: 0.45, blue: 0.45, alpha: 0.9) // Red
        }
    }
    
    func titleForLocation(location: Location) -> String {
        var deviceName = location.username
        
        if deviceName.lengthOfBytes(using: .utf8) > self.maxIdLength {
            let index = deviceName.index(deviceName.startIndex, offsetBy: self.maxIdLength)
            deviceName = deviceName.substring(to: index)
        }
        
        let symbol = self.symbolForLocation(location: location)
        return String(format: "%@%@", symbol, deviceName)
    }
    
    func symbolForLocation(location: Location) -> String {
        switch location.type {
        case .iPad:
            return "📱 "
            
        case .Truck:
            return "🚒 "
        }
    }
    
    func resizeLabel(name: String) {
        self.setupWidthForLabel(name: name)
        
        var currenctFrame = self.frame
        
        let deviceNameSize = CGSize(width: self.imageWidth, height: self.imageHeight)
        currenctFrame.size = deviceNameSize
        self.itemNameLabel.frame = currenctFrame
        self.frame = currenctFrame
    }
    
    func setupWidthForLabel(name: String) {
        let constraintSize = CGSize(width: 1000, height: 1000)
        let labelSize = self.mu_stringSize(string: name,
            font: self.itemNameLabel.font,
            constrainedToSize: constraintSize
        )
        
        let proposedWidth = 8 + labelSize.width
        self.imageWidth = max(self.imageWidth, proposedWidth)
    }
    
    func mu_stringSize(string: String, font: UIFont, constrainedToSize size: CGSize) -> CGSize {
        let opts: NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attr = [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        var computedSize = (string as NSString).boundingRect(with: size, options: opts, attributes: attr, context: nil).size
        computedSize.height = ceil(computedSize.height)
        computedSize.width = ceil(computedSize.width)
        return computedSize        
    }
    
    func mu_asImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return capturedImage
        }
        
        return nil
    }
}
