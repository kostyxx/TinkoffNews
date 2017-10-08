//
//  NewsHeaderCell.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class NewsHeaderCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publicationDateLabel: UILabel!
    
    func configureCell(title:String, date:String) {
        titleLabel.text = title
        publicationDateLabel.text = date
    }
    
}
