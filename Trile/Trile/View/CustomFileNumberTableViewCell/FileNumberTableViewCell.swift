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
        
        if selected {
            setLightGreenBackgroundColor()
        } else {
            setDarkGreenBackgroundColor()
        }
    }
    
    func setLightGreenBackgroundColor() {
        self.contentView.backgroundColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
    }
    
    func setDarkGreenBackgroundColor() {
        self.contentView.backgroundColor = UIColor(red: 69/255, green: 172/255, blue: 100/255, alpha: 1)
    }
}
