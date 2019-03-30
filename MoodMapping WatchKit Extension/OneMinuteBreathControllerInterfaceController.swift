//
//  OneMinuteBreathControllerInterfaceController.swift
//  moodrips
//
//  Created by spoonik on 2015/11/01.
//  Copyright © 2015年 com.spoonikapps. All rights reserved.
//

import WatchKit
import Foundation


class OneMinuteBreathControllerInterfaceController: WKInterfaceController {
    @IBOutlet var imageBackground: WKInterfaceGroup!
    @IBOutlet var repeatTimeLabel: WKInterfaceLabel!
    @IBOutlet var instructionLabel: WKInterfaceLabel!

    var timer: NSTimer? = nil

    var imageStep = 36
    var countUp = -1
    var instructionStep = -1
    let instructionTexts = [    //呼吸の指示をするテキスト
        "wait",
        "breathe in", "hold", "breathe out", "breathe out",
        "breathe in", "hold", "breathe out", "breathe out",
        "breathe in", "hold", "breathe out",
        "finish"]
    let stepInterval = 0.135   //イメージを更新する時間間隔(sec)

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            stepInterval,
            target: self,
            selector: "updateTimerImage",
            userInfo: nil,
            repeats: true)
    }

    func updateTimerImage() {
        if (imageStep == 36) {
            countUp = -1
            instructionStep++
            WKInterfaceDevice.currentDevice().playHaptic((instructionStep == 12) ? WKHapticType.Success : WKHapticType.Click)
        } else if (imageStep == 0) {
            countUp = 1
            instructionStep++
            WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Click)
        }
        
        self.instructionLabel.setText(instructionTexts[instructionStep])
        self.imageBackground.setBackgroundImageNamed("progress-\(imageStep)" + ((countUp == -1) ? "-r": ""))

        switch instructionStep {
        case 0:
            self.repeatTimeLabel.setText("0")
        case 1...4:
            self.repeatTimeLabel.setText("1")
        case 5...8:
            self.repeatTimeLabel.setText("2")
        case 9...11:
            self.repeatTimeLabel.setText("3")
        case 12:
            self.repeatTimeLabel.setText("fine")
            timer!.invalidate()
            return
        default:
            return
        }

        imageStep += countUp
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        timer!.invalidate()
        super.didDeactivate()
    }
    
}
