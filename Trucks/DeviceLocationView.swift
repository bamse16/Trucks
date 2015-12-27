//
//  DeviceLocationView.swift
//  Trucks
//
//  Created by Marius Ursache on 27/12/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit

class DeviceLocationView: UIImageView {
    
    var itemName: NSString = ""
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
    
    func configure(deviceName: NSString) {
        self.configure(deviceName, font: self.defaultFont)
    }
    
    func configure(deviceName: NSString, font: UIFont){
        self.itemName = deviceName
        
        if deviceName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > self.maxIdLength {
            self.itemName = deviceName.substringToIndex(self.maxIdLength)
        }
        
        self.itemNameLabel.font = font
        self.itemNameLabel.text = self.itemName as String
        
        self.resizeLabel()
    }
    
    func resizeLabel() {
        self.setupWidthForLabel()
        
        var currenctFrame = self.frame
        
        let deviceNameSize = CGSizeMake(self.imageWidth, self.imageHeight)
        currenctFrame.size = deviceNameSize
        self.itemNameLabel.frame = currenctFrame
        self.frame = currenctFrame
    }
    
    func setupWidthForLabel() {
        let constraintSize = CGSizeMake(1000, 1000)
        let labelSize = self.mu_stringSize(self.itemName,
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
    
    func mu_asImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
