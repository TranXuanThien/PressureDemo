//
//  AltimeterTableViewCell.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/16/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import UIKit

class AltimeterTableViewCell: UITableViewCell {

    @IBOutlet weak var alimeter: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var altimeterFt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
