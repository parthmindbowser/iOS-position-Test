//
//  PostListCell.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet var lblPostTitle: UILabel!
    @IBOutlet var lblPostBody: UILabel!
    @IBOutlet var lblUser: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
