//
//  CommentListCell.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class CommentListCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
