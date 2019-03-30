//
//  QuestDetailViewController.swift
//  moodrips
//
//  Created by spoonik on 2016/01/24.
//  Copyright © 2016年 com.spoonikapps. All rights reserved.
//

import UIKit


protocol MyViewDelegate: class {
    func finishSelection(selectedItemId: NSDictionary)
}

class QuestDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

  @IBOutlet weak var text: UITextField!
  @IBOutlet weak var picker: UIPickerView!
  var _second: String = ""
  var _output: NSDictionary!
      weak var delegate: MyViewDelegate? = nil

  @IBAction func save(sender: AnyObject) {
      _output = ["type": pickerData[picker.selectedRowInComponent(0)], "action": text.text!]
        delegate?.finishSelection(_output)
      navigationController!.popViewControllerAnimated(true)
  }
  
  var pickerData: [String] = ["PowerUp", "BadGuy", "Quest"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
