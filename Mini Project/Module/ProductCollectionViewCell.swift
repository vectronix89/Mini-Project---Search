//
//  ProductCollectionViewCell.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var normalPrice: UILabel!
    var isLoadingImage:Bool = false
    var json:JSON!
    var rowIndex:Int!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        title = nil
//        normalPrice = nil
    }
    
    func reloadImage(){
        if self.imageView?.image == nil && self.isLoadingImage == false{
            self.isLoadingImage = true
            APIService.shared.requestImage(path:self.json["image_uri"].stringValue, completionHandler:{ image in
                let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: CGSize.init(width: 70, height: 70))
                self.imageView?.image = aspectScaledToFitImage
                self.isLoadingImage = false
            })
        }
        
    }
}
