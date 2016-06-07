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
        
        let label = UILabel.init(frame: CGRectMake(0, 0, 100, 40))
        label.text = "wlbranch"
        self.view.addSubview(label)
        
        label.removeFromSuperview()
        
        let gitTextLabel = UILabel.init(frame: CGRectMake(0, 60, 100, 40))
        gitTextLabel.text = "gitText"
        self.view.addSubview(gitTextLabel)
        
        let Str = "end"
        

        let str2 = "hehe"
        
        let str3 = "好吧"
        
        let str4 = "恩"
        
        let str5 = "wanli"
        
        let str6 = "liuzhen"

        print("dev new commit")
        
        print("策略")
        
        print("haol")
        
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

