//
//  GraphView.swift
//  Liquid_Intake_Tracker
//
//  Created by Avinash on 02/02/17.
//  Copyright © 2017 avinash. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    //Weekly sample data
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
    
    //the properties for the gradient
    //You set up the start and end colors for the gradient as @IBInspectable properties, so that you’ll be able to change them in the storyboard.
    
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
                               byRoundingCorners: UIRectCorner.allCorners,
                               cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //get the current context
        //CG drawing functions need to know the context in which they will draw, so you use the UIKit method UIGraphicsGetCurrentContext() to obtain the current context. That’s the one that drawRect(_:) draws into.
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //set up the color space
        //All contexts have a color space. This could be CMYK or grayscale, but here you’re using the RGB color space.
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //set up the color stops
        //The color stops describe where the colors in the gradient change over. In this example, you only have two colors, red going to green, but you could have an array of three stops, and have red going to blue going to green. The stops are between 0 and 1, where 0.33 is a third of the way through the gradient.
        
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //create the gradient
        //Create the actual gradient, defining the color space, colors and color stops.
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        //draw the gradient
        //Finally, you draw the gradient. CGContextDrawLinearGradient()
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        //calculate the x point
        //columnXPoint takes a column as a parameter, and returns a value where the point should be on the x-axis.
        
        let margin:CGFloat = 20.0
        var columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        
        //Because the origin is in the top-left corner and you draw a graph from an origin point in the bottom-left corner, columnYPoint adjusts its return value so that the graph is oriented as you would expect.
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()
        var columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up the points line
        var graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                      y:columnYPoint(graphPoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //graphPath.stroke()
        
        //create a gradient underneath this path by using the path as a clipping path.
        //Create the clipping path for the graph gradient
        
        //save the state of the context
        context!.saveGState() //refer note1
        
        //make a copy of the path, Copy the plotted path to a new path that defines the area to fill with a gradient.
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //add lines to the copied path to complete the clip area
        //Complete the area with the corner points and close the path. This adds the bottom-right and bottom-left points of the graph.
        
        clippingPath.addLine(to: CGPoint(
            x: columnXPoint(graphPoints.count - 1),
            y:height))
        clippingPath.addLine(to: CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.close()
        
        //Add the clipping path to the context. When the context is filled, only the clipped path is actually filled.
        clippingPath.addClip()
        
        //find the highest number of glasses drunk and use that as the starting point of the gradient.
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context!.restoreGState() //refer note1
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn:
                CGRect(origin: point,
                       size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
            }
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x:margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin,
                                     y:topBorder))
        
        //center line
        linePath.move(to: CGPoint(x:margin,
                                  y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                     y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x:margin,
                                  y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                     y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
}

//Note1 : Graphics contexts can save states. When you set many context properties, such as fill color, transformation matrix, color space or clip region, you’re actually setting them for the current graphics state. You can save a state by using CGContextSaveGState(), which pushes a copy of the current graphics state onto the state stack. You can also make changes to context properties, but when you call CGContextRestoreGState(), the original state is taken off the stack and the context properties revert.
    //By doing this, you:
        //Push the original graphics state onto the stack with CGContextSaveGState().
        //Add the clipping path to a new graphics state.
        //Draw the gradient within the clipping path.
        //Restore the original graphics state with CGContextRestoreGState() — this was the state before you added the clipping path.
