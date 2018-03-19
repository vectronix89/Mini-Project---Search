//
//  SearchList.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SearchList:BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout: CustomCollectionFlowLayout!
    var filter:FilterParameter!
    var result:[JSON] = []
    var loadMore:Bool = false
    var timer:Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout = CustomCollectionFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Search"
        if filter != nil {
            self.fetchSearch()
        }
    }
    
    @objc @IBAction func backClicked(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func fetchSearch(){
        self.showLoader()
        APIService
        .fetchProductByCategory(self.filter)
        .subscribe(
            onNext:{ products in
                //print(products)
                
                if products["data"].array != nil {
                    self.result += products["data"].arrayValue
                    
                    var ph = [String]()
                    var newjson = [JSON]()
                    for dict:JSON in self.result {
                        if ph.contains(dict["id"].stringValue) {
                            let index:Int = ph.index(of: dict["id"].stringValue)!
                            newjson[index] = dict
                        } else {
                            ph.append(dict["id"].stringValue)
                            newjson.append(dict)
                        }
                    }
                    
                    self.result = newjson
                    self.collectionView.reloadData()
                }
                self.loadMore = false
                self.hideLoader()
        },
            onError:{ error in
                //
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        let item:JSON = result[indexPath.row]
        cell.json = item
        cell.reloadImage()
        cell.title.text = item["name"].stringValue
        cell.normalPrice.text = item["price"].stringValue
        
        return cell
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !loadMore && (scrollView == self.collectionView &&
            Int(scrollView.contentOffset.y + scrollView.frame.size.height) == Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
            print("Hit End Scrolll")
            if result.count % 10 > 0 {
                return
            }
            
            self.timer.invalidate()
            
            self.filter.page = NSNumber.init(value: (result.count / 10) + 1)
            loadMore = true
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fetchSearch), userInfo: nil, repeats: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchFilter, segue.identifier == "show_serach_filter_segue" {
            vc.filter = self.filter
        }
    }
    
    @IBAction func unwindSearchList(segue: UIStoryboardSegue){
        if (segue.source .isKind(of: SearchFilter.self)){
            let vc:SearchFilter = segue.source as! SearchFilter
            self.filter = vc.filter
            self.fetchSearch()
        }
    }
    
    @IBAction func filterClicked(_ sender:UIButton){
        self.performSegue(withIdentifier: "show_serach_filter_segue", sender: sender)
    }
    
    
}
