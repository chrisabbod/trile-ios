//
//  FileNumberTableViewCell.swift
//  Trile
//
//  Created by Chris Abbod on 1/16/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class FileNumberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fileNumberLabel: UILabel!
    @IBOutlet weak var offenseLabel: UILabel!
    @IBOutlet weak var bondLabel: UILabel!
    @IBOutlet weak var continuancesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
