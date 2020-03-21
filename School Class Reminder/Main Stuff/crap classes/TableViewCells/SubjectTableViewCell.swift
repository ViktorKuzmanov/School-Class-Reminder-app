//
//  SubjectTableViewCell.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 10/3/17.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var labelEndsAtTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //labelEndsAtTime.adjustsFontSizeToFitWidth = false
        //labelEndsAtTime.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
