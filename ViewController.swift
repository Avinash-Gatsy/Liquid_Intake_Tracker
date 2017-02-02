//
//  ViewController.swift
//  Liquid_Intake_Tracker
//
//  Created by Avinash on 01/02/17.
//  Copyright © 2017 avinash. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    //Label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPushButton(button: PushButtonView) {
        
        let CounterClass = CounterView()
        let MaxCount = CounterClass.NoOfGlasses
        
        if  button.isAddButton {
            if counterView.counter < MaxCount{
                counterView.counter += 1
            }else{
                counterView.counter = MaxCount
            }
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        if isGraphViewShowing {
            counterViewTap(gesture: nil)
        }
    }
    
    @IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        //UIView.transitionFromView(_:toView:duration:options:completion:) performs a horizontal flip transition
        //The transition masks the ShowHideTransitionViews constant, so you don’t have to remove the view to prevent it from being shown.
        
        if (isGraphViewShowing) {
            
            //hide Graph
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [UIViewAnimationOptions.transitionFlipFromLeft , UIViewAnimationOptions.showHideTransitionViews], completion: nil)
        } else {
            
            //show Graph
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [UIViewAnimationOptions.transitionFlipFromRight , UIViewAnimationOptions.showHideTransitionViews], completion: nil)
            
            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func setupGraphDisplay() {
        
        //Use 7 days for graph - can use any number, but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        //indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        
        //calculate average from graphPoints using Swift’s reduce to sum up all the elements in an array.
        let average = graphView.graphPoints.reduce(0, +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //get today's day number
        //This section put the current day’s number from the iOS calendar into the property weekday.
        let dateFormatter = DateFormatter()
        let calendar = NSCalendar.current
        let component = calendar.component(.weekday, from:NSDate() as Date)
        var weekday = component
        
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        
        //set up the day name labels with correct day
        //This loop just goes from 7 to 1, gets the view with the corresponding tag number and extracts the correct day title from the days array.
        for i in (1...days.count) {
            let j = (days.count) - (i-1)
            if let labelView = graphView.viewWithTag(j) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                if weekday >= i {
                    labelView.text = days[weekday - i]
                } else {
                    labelView.text = days[i - 1]
                }
                print(labelView.text)
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
}

