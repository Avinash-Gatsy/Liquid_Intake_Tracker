//
//  ViewController.swift
//  Liquid_Intake_Tracker
//
//  Created by Avinash on 01/02/17.
//  Copyright © 2017 avinash. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!

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
    }
}

