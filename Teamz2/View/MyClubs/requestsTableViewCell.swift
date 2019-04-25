//
//  requestsTableViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 25/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol requestTableViewDelegate: AnyObject {
    func acceptButtonPressed(cell: requestsTableViewCell)
    func declineButtonPressed(cell: requestsTableViewCell)
    
}

class requestsTableViewCell: UITableViewCell {
    
    weak var delegate: requestTableViewDelegate?

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        delegate?.acceptButtonPressed(cell: self)
    }
    
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        delegate?.declineButtonPressed(cell: self)
    }
    
}
