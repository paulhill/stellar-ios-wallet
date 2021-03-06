//
//  OrderBookCell.swift
//  BlockEQ
//
//  Created by Satraj Bambra on 2018-05-27.
//  Copyright © 2018 Satraj Bambra. All rights reserved.
//

import UIKit

class OrderBookCell: UITableViewCell {
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    
    static let cellIdentifier = "OrderBookCell"
    static let rowHeight: CGFloat = 44.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        option1Label.textColor = Colors.darkGray
        option2Label.textColor = Colors.darkGray
        option3Label.textColor = Colors.darkGray
    }
}
