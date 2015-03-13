//
//  CellTableViewCell.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/13/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myUsernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
