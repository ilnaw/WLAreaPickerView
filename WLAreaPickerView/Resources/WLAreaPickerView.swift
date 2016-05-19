//
//  WLAreaPickerView.swift
//  WLAreaPickerView
//
//  Created by wanli on 16/5/4.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

import UIKit

let UISCEENWIDTH = UIScreen.mainScreen().bounds.width;
let UISCEENHEIGHT = UIScreen.mainScreen().bounds.height;
let baseHeight : CGFloat = 215
let toolBarHeight : CGFloat = 44
let numberOfComponent : Int = 3

func RGBA(r:CGFloat ,g:CGFloat ,b:CGFloat,a:CGFloat) -> UIColor
{
    return UIColor(red: r/255.0,green: g/255.0,blue: b/255.0,alpha: a)
}

protocol WLAreaPickerViewDelegate {
    func didselectedareaNameAndId(province: String, city: String, area: String, id: String);
}

class WLAreaPickerView: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var wlPickerViewDelegate:WLAreaPickerViewDelegate!

    var toolBar = UIToolbar();
    var backgroundView = UIView(); //背景
    var doneBar:UIBarButtonItem!; //确定
    var cancelBar:UIBarButtonItem!; //取消
    
    var provinceArr:Array<NSDictionary> = Array();
    var cityArr:Array<NSDictionary> = Array();
    var areaArr:Array<NSDictionary> = Array();
    var provinceSelectedIndex = 0; //选中的省
    var citySelectedIndex = 0; //选中的市
    var areaSselectedIndex = 0; //选中的区
    
    override init(frame: CGRect) {
        var pickerFrame:CGRect!;
        pickerFrame = CGRectMake(0, UISCEENHEIGHT - baseHeight, UISCEENWIDTH, baseHeight);
        super.init(frame: pickerFrame);
        self.backgroundColor = RGBA(245, g: 245, b: 245, a: 1);
        self.delegate = self;
        self.dataSource = self;
        
        //加载toolBar
        self.loadToolBar();
        //加载背景
        self.loadBackgroundView();
        
        //异步取出本地数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.getLocalData();
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return numberOfComponent;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return provinceArr.count;
        case 1:
            cityArr = (provinceArr[provinceSelectedIndex]["cityList"] as? Array)!
            return cityArr.count
        case 2:
            areaArr = (cityArr[citySelectedIndex]["areaList"] as? Array)!
            return areaArr.count
        default:
            return 0;
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (component) {
        case 0:
            return provinceArr[row]["provinceName"] as? String
        case 1:
            return cityArr[row]["cityName"] as? String
        case 2:
            return areaArr[row]["areaName"] as? String
        default:
            return nil;
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
        case 0:
            provinceSelectedIndex = row;
            citySelectedIndex = 0;
            areaSselectedIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: true);
            pickerView.selectRow(0, inComponent: 2, animated: true);
        case 1:
            citySelectedIndex = row;
            areaSselectedIndex = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false);
        case 2:
            areaSselectedIndex = row;
        default:
            break;
        }
    }
//MARK:method
    func getLocalData() {
        let path = NSBundle.mainBundle().pathForResource("myArea", ofType: "plist")
        let dic : NSDictionary = NSDictionary.init(contentsOfFile: path!)!
        provinceArr = dic["obj"] as! Array;
        
        
    }
    
    func show() {
        let window = UIApplication.sharedApplication().keyWindow;
        window?.addSubview(backgroundView);
        window?.addSubview(self);
        window?.addSubview(toolBar);
    }
    func loadToolBar() {
        toolBar.frame = CGRectMake(0, UISCEENHEIGHT - self.frame.height - toolBarHeight, UISCEENWIDTH, toolBarHeight);
        
        doneBar = UIBarButtonItem(title: "    完成    ", style: UIBarButtonItemStyle.Done, target: self, action: #selector(WLAreaPickerView.doneAction));
        doneBar.tintColor = UIColor.whiteColor();
        
        cancelBar = UIBarButtonItem(title: "    取消    ", style: UIBarButtonItemStyle.Done, target: self, action: #selector(WLAreaPickerView.cancelAction));
        cancelBar.tintColor = UIColor.whiteColor();
        
        let blankBar = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: Selector(""));
        
        toolBar.items = [cancelBar,blankBar,doneBar]
        toolBar.barTintColor = RGBA(89, g: 179, b: 152, a: 1)
        
        toolBar.layer.shadowColor = UIColor.lightGrayColor().CGColor
        toolBar.layer.shadowOffset = CGSizeMake(0, 3)
        toolBar.layer.shadowRadius = 2
        toolBar.layer.shadowOpacity = 1
        
    }
    
    func loadBackgroundView() {
        backgroundView.frame = CGRectMake(0, 0, UISCEENWIDTH, UISCEENHEIGHT - self.frame.height - 44)
        backgroundView.backgroundColor = UIColor.blackColor();
        backgroundView.alpha = 0.5;
        backgroundView.userInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(WLAreaPickerView.cancelAction))
        backgroundView.addGestureRecognizer(tap);
    }
    
    func doneAction() {
        self.cancelAction();
        let province = provinceArr[provinceSelectedIndex]["provinceName"] as? String;
        let city = cityArr[citySelectedIndex]["cityName"] as? String;
        
        let area = areaArr[areaSselectedIndex]["areaName"] as? String;
        let id = areaArr[areaSselectedIndex]["areaId"] as? String;
        
        wlPickerViewDelegate.didselectedareaNameAndId(province!, city: city!, area: area!, id: id!);
    }
    
    //MARK: - cancelAction
    func cancelAction() {
        toolBar.removeFromSuperview();
        backgroundView.removeFromSuperview();
        self.removeFromSuperview();
    }

//MARK:setter
    /*
     *pickerView高度
     */
    var customHeight:CGFloat! {
        didSet {
            self.frame = CGRectMake(0, UISCEENHEIGHT - customHeight, UISCEENWIDTH, customHeight);
            toolBar.frame = CGRectMake(0, UISCEENHEIGHT - customHeight - 44, UISCEENWIDTH, 44);
            backgroundView.frame = CGRectMake(0, 0, UISCEENWIDTH, UISCEENHEIGHT - customHeight - 44);
        }
    }
    
    /*
     *cancelBar的title
     */
    var cancelBarTitle:String! {
        didSet {
            cancelBar.title = cancelBarTitle;
        }
    }
    
    /*
     *cancelBar的文字颜色
     */
    var cancelBarColor:UIColor! {
        didSet {
            cancelBar.tintColor = cancelBarColor;
        }
    }
    
    /*
     *doneBar的title
     */
    var doneBarTitle:String! {
        didSet {
            doneBar.title = doneBarTitle;
        }
    }
    
    /*
     *doneBar的文字颜色
     */
    var doneBarColor:UIColor! {
        didSet {
            doneBar.tintColor = doneBarColor;
        }
    }
}
