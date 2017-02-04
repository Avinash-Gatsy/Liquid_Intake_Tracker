//
//  PushButtonView.swift
//  Liquid_Intake_Tracker
//
//  Created by Avinash on 01/02/17.
//  Copyright © 2017 avinash. All rights reserved.
//

import UIKit
@IBDesignable //live rendering

class PushButtonView: UIButton {

    //@IBInspectable is an attribute you can add to a property that makes it readable by Interface Builder.
    @IBInspectable var fillColor: UIColor = UIColor.init(red: 0.281, green: 0.706, blue: 0.373, alpha: 1)
    @IBInspectable var isAddButton: Bool = true
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green

    
    override func draw(_ rect: CGRect) {
        
        //First create an oval-shaped UIBezierPath that is the size of the rectangle passed to it.
        //let path = UIBezierPath(ovalIn: rect)
        
        let width = rect.width
        let height = rect.height
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: width/2, height: height/2))
        path.addClip()
        
        //To draw the path, you gave the current context a fill color, and then fill the path.
        //UIColor.blue.setFill()
        //fillColor.setFill()
        //path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:path.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        //Each UIView has a graphics context, and all drawing for the view renders into this context before being transferred to the device’s hardware. iOS updates the context by calling draw(_:) whenever the view needs to be updated.
        
        //Any drawing done in draw(_:) goes into the view’s graphics context. if you start drawing outside of draw(_:), you’ll have to create your own graphics context.
        
        //Note: Never call draw(_:) directly. If your view is not being updated, then call setNeedsDisplay() on the view. setNeedsDisplay() does not itself call draw(_:), but it flags the view as ‘dirty’, triggering a redraw using draw(_:) on the next screen update cycle. Even if you call setNeedsDisplay() five times in the same method you’ll only ever actually call draw(_:) once.
        
        //set up the width and height variables for the horizontal stroke
        let plusHeight: CGFloat = 5.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(x: bounds.width/2 - plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(x: bounds.width/2 + plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        
        if isAddButton {
        //vertical line
        //move to the start of the vertical stroke
        plusPath.move(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 - plusWidth/2 + 0.5))
        
        //add the end point to the vertical stroke
        plusPath.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + plusWidth/2 + 0.5))
        }
        //set the stroke color
        UIColor.white.setStroke()
        
        //draw the stroke
        plusPath.stroke()
        
        //Note: For pixel perfect lines, you can draw and fill a UIBezierPath(rect:) instead of a line, and use the view’s contentScaleFactor to calculate the width and height of the rectangle. Unlike strokes that draw outwards from the center of the path, fills only draw inside the path.
    }

}
