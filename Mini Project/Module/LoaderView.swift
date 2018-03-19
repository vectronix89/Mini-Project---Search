//
//  LoaderView.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class LoaderView:UIView{
    
    override init(frame : CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        let loaderImage = UIActivityIndicatorView()
        loaderImage.color = .white
        loaderImage.startAnimating()
        self.addSubview(loaderImage)
        loaderImage.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
