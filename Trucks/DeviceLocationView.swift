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
    let defaultBackgroundColor = UIColor.yellowColor()
    
    let maxIdLength = 5
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.itemNameLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(self.itemNameLabel)
        
        self.backgroundColor = self.defaultBackgroundColor
    }
    
    func configure(location: Location) {
        self.configure(location, font: self.defaultFont)
    }
    
    func configure(location: Location, font: UIFont) {
        let itemNameStr = titleForLocation(location)
        
        self.itemNameLabel.font = font
        self.itemNameLabel.text = itemNameStr
        
        self.resizeLabel(itemNameStr)
        self.backgroundColor = self.backgroundForLocation(location)
    }
    
    func backgroundForLocation(location: Location) -> UIColor {
        switch location.type {
        case .iPad:
            return UIColor(red: 0.24, green: 0.54, blue: 0.96, alpha: 0.9) // Blue

        case .Truck:
            return UIColor.whiteColor()
            // return UIColor(red: 0.88, green: 0.45, blue: 0.45, alpha: 0.9) // Red
        }
    }
    
    func titleForLocation(location: Location) -> String {
        var deviceName = location.username
        if deviceName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > self.maxIdLength {
            deviceName = (deviceName as NSString).substringToIndex(self.maxIdLength)
        }
        
        let symbol = self.symbolForLocation(location)
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
        self.setupWidthForLabel(name)
        
        var currenctFrame = self.frame
        
        let deviceNameSize = CGSizeMake(self.imageWidth, self.imageHeight)
        currenctFrame.size = deviceNameSize
        self.itemNameLabel.frame = currenctFrame
        self.frame = currenctFrame
    }
    
    func setupWidthForLabel(name: String) {
        let constraintSize = CGSizeMake(1000, 1000)
        let labelSize = self.mu_stringSize(name,
            font: self.itemNameLabel.font,
            constrainedToSize: constraintSize
        )
        
        let proposedWidth = 8 + labelSize.width
        self.imageWidth = max(self.imageWidth, proposedWidth)
    }
    
    func mu_stringSize(string: NSString, font: UIFont, constrainedToSize size: CGSize) -> CGSize {
        let opts: NSStringDrawingOptions = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        var computedSize = string.boundingRectWithSize(size,
            options: opts,
            attributes: [
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle
            ],
            context: nil).size
        
        computedSize.height = ceil(computedSize.height)
        computedSize.width = ceil(computedSize.width)
        return computedSize
    }
    
    func mu_asImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.renderInContext(context)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return capturedImage
        }
        
        return nil
    }
}
