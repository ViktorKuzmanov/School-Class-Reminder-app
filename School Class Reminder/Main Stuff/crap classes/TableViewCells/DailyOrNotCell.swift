//
//  DailyOrNotCell.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 12/18/17.
//

import UIKit

class DailyOrNotCell: UITableViewCell {

    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelStartsAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
