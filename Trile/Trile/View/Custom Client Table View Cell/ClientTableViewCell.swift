//
//  ClientTableViewCell.swift
//  Trile
//
//  Created by Chris Abbod on 1/16/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    @IBOutlet weak var clientImageView: UIImageView!
    @IBOutlet weak var clientNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        changeBackgroundColor()
        makeCircularView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: UI Beautification Functions
    
    func makeCircularView() {
        clientImageView.layer.masksToBounds = true
        clientImageView.layer.cornerRadius = clientImageView.bounds.width / 2
    }

    func changeBackgroundColor() {
        self.contentView.backgroundColor = UIColor(red: 69/255, green: 172/255, blue: 100/255, alpha: 1)
    }
}
