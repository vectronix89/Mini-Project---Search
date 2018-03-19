//
//  ShopTypeFilter.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import LGButton

final class ShopTypeFilter:BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var footerView:UIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var saveBtn:LGButton!
    
    var filter:FilterParameter!
    var result:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    func resetFilter(){
        filter.selelectedShop = []
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "ShopTypeCell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.textColor = .darkGray
        let shopName:String = filter.typeShopName[indexPath.row]
        cell.textLabel?.text = shopName
        
        if filter.selelectedShop != nil, filter.selelectedShop.contains(shopName) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shopName:String = filter.typeShopName[indexPath.row]
        if filter.selelectedShop.contains(shopName){
            filter.selelectedShop.remove(at: filter.selelectedShop.index(of: shopName)!)
        }else{
            filter.selelectedShop.append(shopName)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func saveClicked(_ sender:UIButton) {
        self.performSegue(withIdentifier: "dismiss_shop_to_filter", sender: self.saveBtn)
    }
    
    @IBAction func backClicked(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender:UIBarButtonItem){
        filter.selelectedShop = []
        tableView.reloadData()
    }
}
