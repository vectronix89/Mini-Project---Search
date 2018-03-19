//
//  SearchFilter.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON
import LGButton
import RangeSeekSlider
import FontAwesome_swift

final class SearchFilter:BaseViewController, UITextFieldDelegate, RangeSeekSliderDelegate {
    @IBOutlet weak var minField:SkyFloatingLabelTextField!
    @IBOutlet weak var maxField:SkyFloatingLabelTextField!
    @IBOutlet weak var brandStack:UIStackView!
    @IBOutlet weak var scrollBrand:UIScrollView!
    @IBOutlet weak var sortBtn:LGButton!
    @IBOutlet weak var toogle:UISwitch!
    @IBOutlet weak var rangeSlider:RangeSeekSlider!
    
    var modalFrom:String!
    var filter:FilterParameter!
    
    var isPresenting:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSlider.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        minField.font = UIFont.systemFont(ofSize: 12)
        maxField.font = UIFont.systemFont(ofSize: 12)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFilter()
    }
    
    @objc @IBAction func backClicked(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let count:Int = (textField.text?.characters.count)!
        if count > 0{
            textField.text = textField.text?.replacingOccurrences(of: "Rp. ", with: "")
            textField.text = textField.text?.replacingOccurrences(of: ".", with: "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let count:Int = (textField.text?.characters.count)!
        if textField == minField {
            if count > 0 {
                filter.minVal = (textField.text as! NSString).floatValue
                setupMinPrice()
                rangeSlider.minValue = CGFloat(filter.minVal)
            }else{
                filter.minVal = -1
                setupMinPrice()
                rangeSlider.minValue = 0
            }
        }else if textField == maxField {
            if count > 0 {
                filter.maxVal = (textField.text as! NSString).floatValue
                setupMaxPrice()
                rangeSlider.maxValue = CGFloat(filter.maxVal)
            }else{
                filter.maxVal = -1
                setupMaxPrice()
                rangeSlider.maxValue = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShopTypeFilter, segue.identifier == "show_shop_type_segue" {
            isPresenting = true
            vc.filter = self.filter
        }
    }
    
    @IBAction func unwindFilter(segue: UIStoryboardSegue){
        if (segue.source .isKind(of: ShopTypeFilter.self)){
            isPresenting = false
            let vc:ShopTypeFilter = segue.source as! ShopTypeFilter
            self.filter = vc.filter
            setupSelectedBrands()
        }
    }
    
    @IBAction func brandClicked(_ sender:UIButton){
        self.performSegue(withIdentifier: "show_shop_type_segue", sender: self)
    }
    
    @IBAction func filterClicked(_ sender:UIButton){
        self.performSegue(withIdentifier: "dismiss_filter_to_list", sender: self)
    }
    
    
    func setupMinPrice(){
        if filter.minVal < 0 {
            minField.text = ""
        }else{
            minField.text = filter.minVal.currencyIDR.replacingOccurrences(of: "Rp", with: "Rp. ")
        }
    }
    
    func setupMaxPrice(){
        if filter.maxVal < 0 {
            maxField.text = ""
            rangeSlider.maxValue = CGFloat(1000000000)
        }else{
            maxField.text = filter.maxVal.currencyIDR.replacingOccurrences(of: "Rp", with: "Rp. ")
        }
    }
    
    func setupSelectedSort(){
//        let sortString:String = filter.filterSortName[filter.selectedSortIndex]
//        sortBtn.titleString = sortString
    }
    
    func setupSelectedBrands(){
        for item in brandStack.arrangedSubviews{
            item.removeFromSuperview()
        }
        
        if filter.selelectedShop.count > 0 {
            scrollBrand.isHidden = false
        }else{
            scrollBrand.isHidden = true
        }

        for i in 0..<filter.selelectedShop.count{
            let shopName:String = filter.selelectedShop[i]
            let itemBrand:UIButton = UIButton.init(type: UIButtonType.custom)
            itemBrand.backgroundColor = .white
            itemBrand.tag = 2000+i
            itemBrand.addTarget(self, action: #selector(self.itemShopTypeClicked(_:)), for: UIControlEvents.touchUpInside)

            let image:UIImage = UIImage.fontAwesomeIcon(name: .timesCircle, textColor: .gray, size: CGSize.init(width: 20, height: 20))
            itemBrand.setImage(image, for: .normal)
            itemBrand.setTitle(shopName, for: .normal)
            itemBrand.setTitleColor(.black, for: .normal)
            itemBrand.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            itemBrand.titleLabel?.lineBreakMode = .byClipping
            itemBrand.semanticContentAttribute = .forceRightToLeft
            itemBrand.titleEdgeInsets.right = 10
            itemBrand.titleEdgeInsets.left = 5
            itemBrand.imageEdgeInsets.right = -5
            itemBrand.layer.cornerRadius = 5
            itemBrand.layer.borderWidth = 1
            itemBrand.layer.borderColor = UIColor.lightGray.cgColor
            itemBrand.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            brandStack.addArrangedSubview(itemBrand)
            itemBrand.snp.updateConstraints({ make in
                let labelWidth:CGFloat = itemBrand.intrinsicContentSize.width + 20
                make.width.equalTo(labelWidth)
                make.height.equalTo(30)
            })
        }
        scrollBrand.sizeToFit()
    }
    
    @objc func itemShopTypeClicked(_ sender:UIButton){
        let shopName:String = filter.selelectedShop[sender.tag-2000]
        self.filter.selelectedShop.remove(at: sender.tag-2000)
        self.setupSelectedBrands()
    }
    
    @IBAction func resetClicked(_ sender:UIBarButtonItem){
        filter.minVal = -1
        filter.maxVal = -1
        filter.wholesale = false
        filter.selelectedShop = []
        
        
        rangeSlider.minValue = 0
        rangeSlider.maxValue = CGFloat(1000000000)
        
        updateFilter()
    }
    
    @IBAction func toggleClicked(){
//        print(filter.wholesale)
        filter.wholesale = toogle.isOn
        setupWholesale()
//        print(filter.wholesale)
    }
    
    func setupWholesale(){
        if filter.wholesale{
            toogle.isOn = true
        }else{
            toogle.isOn = false
        }
    }
    
    func updateFilter(){
        setupMinPrice()
        setupMaxPrice()
        setupWholesale()
        setupSelectedBrands()
        
        
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        filter.minVal = Float(minValue)
        filter.maxVal = Float(maxValue)
        setupMinPrice()
        setupMaxPrice()
    }
}
