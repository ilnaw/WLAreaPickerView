//
//  ViewController.swift
//  WLAreaPickerView
//
//  Created by 万里 on 16/5/6.
//  Copyright © 2016年 wanli. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,WLAreaPickerViewDelegate{

    var pickerView = WLAreaPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.wlPickerViewDelegate = self
    }
    @IBOutlet var showButton: UIButton!

    @IBAction func show(sender: AnyObject) {
        pickerView.show()
    }
    
//MARK:delegate
    func didselectedareaNameAndId(province: String, city: String, area: String, id: String) {
        showButton.setTitle(province+city+area, forState: UIControlState.Normal)
    }

}

