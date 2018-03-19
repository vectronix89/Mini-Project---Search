//
//  CustomCollectionFlowLayout.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 2
            
            let itemWidth = (self.collectionView!.frame.size.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize.init(width: itemWidth, height: 280)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
}
