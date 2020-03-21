//
//  WorkDayCell.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 10/2/17.
//

import UIKit

class WorkDayCell: UITableViewCell {

@IBOutlet weak var dayLabel: UILabel!
@IBOutlet weak var switchOne: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
