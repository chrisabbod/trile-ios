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
}
