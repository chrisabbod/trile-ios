//
//  DocumentCollectionViewCell.swift
//  Trile
//
//  Created by Chris Abbod on 1/3/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isInEditingMode: Bool = false {
        didSet {
            deleteImageView.isHidden = !isInEditingMode
        }
    }
    
//    var isInEditingMode: Bool = false {
//        didSet {
//            checkmarkLabel.isHidden = !isInEditingMode
//        }
//    }
//
//    override var isSelected: Bool {
//        didSet {
//            if isInEditingMode {
//                checkmarkLabel.text = isSelected ? "✓" : ""
//            }
//        }
//    }
}
