//
//  CellView.swift
//  Things
//
//  Created by Adam Rosenberg on 2/22/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class CellView: UICollectionViewCell{
    
    //MARK: init
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
